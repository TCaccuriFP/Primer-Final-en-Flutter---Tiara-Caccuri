import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Busca soluciones usando una cola de trabajo: en cada vuelta elige una
/// ubicación pendiente y, en un isolate aparte con [compute], prueba palabras
/// que se crucen ahí. Si ninguna entra, la ubicación se marca como mala.
///
/// Esta función está en su propio archivo para que el closure que se envía al
/// isolate no capture el Ref de Riverpod, que no se puede enviar.
Stream<Crossword> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
}) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );

  while (!workQueue.isCompleted) {
    final location = workQueue.locationsToTry.keys
        .toBuiltSet()
        .randomElement();
    try {
      final crossword = await compute(((WorkQueue, Location) workMessage) {
        final (workQueue, location) = workMessage;
        final direction = workQueue.locationsToTry[location]!;
        final target = workQueue.crossword.characters[location];

        // Ubicación vacía: es la primera palabra.
        if (target == null) {
          return workQueue.crossword.addWord(
            direction: direction,
            location: location,
            word: workQueue.candidateWords.randomElement(),
          );
        }

        // Prueba palabras que contengan la letra de la ubicación.
        final words = workQueue.candidateWords.toBuiltList().rebuild(
          (b) => b
            ..where((b) => b.characters.contains(target.character))
            ..shuffle(),
        );
        int tryCount = 0;
        for (final word in words) {
          tryCount++;
          for (final (index, character) in word.characters.indexed) {
            if (character != target.character) continue;

            final candidate = workQueue.crossword.addWord(
              location: direction == Direction.across
                  ? location.leftOffset(index)
                  : location.upOffset(index),
              word: word,
              direction: direction,
            );
            if (candidate != null) {
              return candidate;
            }
          }
          if (tryCount > 1000) {
            break;
          }
        }
        return null;
      }, (workQueue, location));

      if (crossword != null) {
        workQueue = workQueue.updateFrom(crossword);
        yield crossword;
      } else {
        workQueue = workQueue.remove(location);
      }
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }

  debugPrint(
    '${crossword.width} x ${crossword.height} Crossword generated in '
    '${DateTime.now().difference(start).formatted}',
  );
}
