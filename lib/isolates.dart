import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Busca soluciones usando una cola de trabajo. Cada vuelta se ejecuta en un
/// isolate con [compute], que a su vez lanza hasta [maxWorkerCount] isolates
/// en paralelo, uno por ubicación a probar.
///
/// Esta función está en su propio archivo para que lo que se envía a los
/// isolates no capture el Ref de Riverpod, que no se puede enviar.
Stream<WorkQueue> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
  required int maxWorkerCount,
}) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );

  while (!workQueue.isCompleted) {
    try {
      workQueue = await compute(_generate, (workQueue, maxWorkerCount));
      yield workQueue;
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }

  debugPrint(
    'Generated ${workQueue.crossword.width} x '
    '${workQueue.crossword.height} crossword in '
    '${DateTime.now().difference(start).formatted} '
    'with $maxWorkerCount workers.',
  );
}

/// Prueba varias ubicaciones a la vez, cada una en su propio isolate, y
/// agrega al crucigrama las palabras encontradas.
Future<WorkQueue> _generate((WorkQueue, int) workMessage) async {
  var (workQueue, maxWorkerCount) = workMessage;
  final candidateGeneratorFutures = <Future<(Location, Direction, String?)>>[];
  final locations = workQueue.locationsToTry.keys.toBuiltList().rebuild(
    (b) => b
      ..shuffle()
      ..take(maxWorkerCount),
  );

  for (final location in locations) {
    final direction = workQueue.locationsToTry[location]!;

    candidateGeneratorFutures.add(
      compute(_generateCandidate, (
        workQueue.crossword,
        workQueue.candidateWords,
        location,
        direction,
      )),
    );
  }

  try {
    final results = await candidateGeneratorFutures.wait;
    var crossword = workQueue.crossword;
    for (final (location, direction, word) in results) {
      if (word != null) {
        // Varias palabras pueden chocar entre sí: se vuelve a validar.
        final candidate = crossword.addWord(
          location: location,
          word: word,
          direction: direction,
        );
        if (candidate != null) {
          crossword = candidate;
        }
      } else {
        workQueue = workQueue.remove(location);
      }
    }

    workQueue = workQueue.updateFrom(crossword);
  } catch (e) {
    debugPrint('$e');
  }

  return workQueue;
}

/// Busca una palabra que se cruce en [location]. Devuelve dónde empieza la
/// palabra, o null si no encontró ninguna tras 1000 intentos o 10 segundos.
(Location, Direction, String?) _generateCandidate(
  (Crossword, BuiltSet<String>, Location, Direction) searchDetailMessage,
) {
  final (crossword, candidateWords, location, direction) = searchDetailMessage;

  final target = crossword.characters[location];
  if (target == null) {
    return (location, direction, candidateWords.randomElement());
  }

  // Solo palabras que contengan la letra de la ubicación.
  final words = candidateWords.toBuiltList().rebuild(
    (b) => b
      ..where((b) => b.characters.contains(target.character))
      ..shuffle(),
  );
  int tryCount = 0;
  final start = DateTime.now();
  for (final word in words) {
    tryCount++;
    for (final (index, character) in word.characters.indexed) {
      if (character != target.character) continue;

      final wordLocation = direction == Direction.across
          ? location.leftOffset(index)
          : location.upOffset(index);
      final candidate = crossword.addWord(
        location: wordLocation,
        word: word,
        direction: direction,
      );
      if (candidate != null) {
        return (wordLocation, direction, word);
      }
      final deltaTime = DateTime.now().difference(start);
      if (tryCount >= 1000 || deltaTime > Duration(seconds: 10)) {
        return (location, direction, null);
      }
    }
  }

  return (location, direction, null);
}
