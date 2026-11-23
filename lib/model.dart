import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

part 'model.g.dart';

/// Una ubicación en la grilla del crucigrama (base 0).
abstract class Location implements Built<Location, LocationBuilder> {
  static Serializer<Location> get serializer => _$locationSerializer;

  /// Columna.
  int get x;

  /// Fila.
  int get y;

  Location get left => rebuild((b) => b.x = x - 1);
  Location get right => rebuild((b) => b.x = x + 1);
  Location get up => rebuild((b) => b.y = y - 1);
  Location get down => rebuild((b) => b.y = y + 1);

  Location leftOffset(int offset) => rebuild((b) => b.x = x - offset);
  Location rightOffset(int offset) => rebuild((b) => b.x = x + offset);
  Location upOffset(int offset) => rebuild((b) => b.y = y - offset);
  Location downOffset(int offset) => rebuild((b) => b.y = y + offset);

  String prettyPrint() => '($x, $y)';

  factory Location.at(int x, int y) {
    return Location((b) {
      b
        ..x = x
        ..y = y;
    });
  }

  factory Location([void Function(LocationBuilder)? updates]) = _$Location;
  Location._();
}

/// Dirección de una palabra: horizontal (across) o vertical (down).
class Direction extends EnumClass {
  static Serializer<Direction> get serializer => _$directionSerializer;

  static const Direction across = _$across;
  static const Direction down = _$down;

  const Direction._(super.name);

  static BuiltSet<Direction> get values => _$directionValues;
  static Direction valueOf(String name) => _$directionValueOf(name);

  @override
  String toString() => name;
}

/// Una palabra colocada en el crucigrama.
abstract class CrosswordWord
    implements Built<CrosswordWord, CrosswordWordBuilder> {
  static Serializer<CrosswordWord> get serializer => _$crosswordWordSerializer;

  /// Ordena palabras por columna y luego por fila.
  static int locationComparator(CrosswordWord a, CrosswordWord b) {
    final compareRows = a.location.y.compareTo(b.location.y);
    final compareColumns = a.location.x.compareTo(b.location.x);
    return switch (compareColumns) {
      0 => compareRows,
      _ => compareColumns,
    };
  }

  factory CrosswordWord.word({
    required String word,
    required Location location,
    required Direction direction,
  }) {
    return CrosswordWord(
      (b) => b
        ..word = word
        ..direction = direction
        ..location.replace(location),
    );
  }

  String get word;
  Location get location;
  Direction get direction;

  factory CrosswordWord([void Function(CrosswordWordBuilder)? updates]) =
      _$CrosswordWord;
  CrosswordWord._();
}

/// Un carácter de la grilla, con las palabras que lo contienen.
abstract class CrosswordCharacter
    implements Built<CrosswordCharacter, CrosswordCharacterBuilder> {
  static Serializer<CrosswordCharacter> get serializer =>
      _$crosswordCharacterSerializer;

  factory CrosswordCharacter.character({
    required String character,
    CrosswordWord? acrossWord,
    CrosswordWord? downWord,
  }) {
    return CrosswordCharacter((b) {
      b.character = character;
      if (acrossWord != null) {
        b.acrossWord.replace(acrossWord);
      }
      if (downWord != null) {
        b.downWord.replace(downWord);
      }
    });
  }

  String get character;
  CrosswordWord? get acrossWord;
  CrosswordWord? get downWord;

  factory CrosswordCharacter([
    void Function(CrosswordCharacterBuilder)? updates,
  ]) = _$CrosswordCharacter;
  CrosswordCharacter._();
}

/// El crucigrama completo.
abstract class Crossword implements Built<Crossword, CrosswordBuilder> {
  static Serializer<Crossword> get serializer => _$crosswordSerializer;

  /// Intenta agregar una palabra. Devuelve el nuevo crucigrama si la palabra
  /// respeta las reglas, o null si no se puede colocar ahí.
  Crossword? addWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    // La palabra no puede estar repetida.
    if (words.map((crosswordWord) => crosswordWord.word).contains(word)) {
      return null;
    }

    final wordCharacters = word.characters;
    bool overlap = false;

    // Cada letra debe coincidir con la que ya hay en la grilla (si hay una).
    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation = direction == Direction.across
          ? location.rightOffset(index)
          : location.downOffset(index);

      final target = characters[characterLocation];
      if (target != null) {
        overlap = true;
        if (target.character != character) {
          return null;
        }
        if (direction == Direction.across && target.acrossWord != null ||
            direction == Direction.down && target.downWord != null) {
          return null;
        }
      }
    }

    // Salvo la primera, toda palabra debe cruzarse con otra.
    if (words.isNotEmpty && !overlap) {
      return null;
    }

    final candidate = rebuild(
      (b) => b
        ..words.add(
          CrosswordWord.word(
            word: word,
            direction: direction,
            location: location,
          ),
        ),
    );

    if (candidate.valid) {
      return candidate;
    } else {
      return null;
    }
  }

  /// Comprueba que el crucigrama cumple todas las reglas.
  bool get valid {
    // No puede haber palabras repetidas.
    final wordStrings = words.map((word) => word.word).toSet();
    if (wordStrings.length != words.length) {
      return false;
    }

    for (final MapEntry(key: location, value: character)
        in characters.entries) {
      // Toda letra debe pertenecer a una palabra horizontal o vertical.
      if (character.acrossWord == null && character.downWord == null) {
        return false;
      }

      // Toda letra debe estar dentro de la grilla.
      if (location.x < 0 ||
          location.y < 0 ||
          location.x >= width ||
          location.y >= height) {
        return false;
      }

      // Las letras de arriba y abajo deben ser de la misma palabra vertical.
      final upTile = characters[location.up];
      if (upTile != null) {
        if (character.downWord == null) return false;
        if (upTile.downWord != character.downWord) return false;
      }

      final downTile = characters[location.down];
      if (downTile != null) {
        if (character.downWord == null) return false;
        if (downTile.downWord != character.downWord) return false;
      }

      // Las letras de izquierda y derecha deben ser de la misma palabra
      // horizontal.
      final leftTile = characters[location.left];
      if (leftTile != null) {
        if (character.acrossWord == null) return false;
        if (leftTile.acrossWord != character.acrossWord) return false;
      }

      final rightTile = characters[location.right];
      if (rightTile != null) {
        if (character.acrossWord == null) return false;
        if (rightTile.acrossWord != character.acrossWord) return false;
      }
    }

    return true;
  }

  /// Calcula [characters] a partir de [words] cada vez que se construye.
  @BuiltValueHook(finalizeBuilder: true)
  static void _fillCharacters(CrosswordBuilder b) {
    b.characters.clear();

    for (final word in b.words.build()) {
      for (final (idx, character) in word.word.characters.indexed) {
        switch (word.direction) {
          case Direction.across:
            b.characters.updateValue(
              word.location.rightOffset(idx),
              (b) => b.rebuild((bInner) => bInner.acrossWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                acrossWord: word,
                character: character,
              ),
            );
          case Direction.down:
            b.characters.updateValue(
              word.location.downOffset(idx),
              (b) => b.rebuild((bInner) => bInner.downWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                downWord: word,
                character: character,
              ),
            );
        }
      }
    }
  }

  /// Representación en texto del crucigrama, útil para depurar.
  String prettyPrintCrossword() {
    final buffer = StringBuffer();
    final grid = List.generate(
      height,
      (_) => List.generate(width, (_) => '░'),
    );

    for (final MapEntry(key: Location(:x, :y), value: character)
        in characters.entries) {
      if (x >= 0 && x < width && y >= 0 && y < height) {
        grid[y][x] = character.character;
      }
    }

    for (final row in grid) {
      buffer.writeln(row.join());
    }

    buffer.writeln();
    buffer.writeln('Across:');
    for (final word
        in words.where((w) => w.direction == Direction.across).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    buffer.writeln();
    buffer.writeln('Down:');
    for (final word
        in words.where((w) => w.direction == Direction.down).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    return buffer.toString();
  }

  factory Crossword.crossword({
    required int width,
    required int height,
    Iterable<CrosswordWord>? words,
  }) {
    return Crossword((b) {
      b
        ..width = width
        ..height = height;
      if (words != null) {
        b.words.addAll(words);
      }
    });
  }

  int get width;
  int get height;
  BuiltList<CrosswordWord> get words;
  BuiltMap<Location, CrosswordCharacter> get characters;

  factory Crossword([void Function(CrosswordBuilder)? updates]) = _$Crossword;
  Crossword._();
}

/// Cola de trabajo: el crucigrama actual, las ubicaciones donde se puede
/// intentar cruzar una palabra y las palabras candidatas que quedan.
abstract class WorkQueue implements Built<WorkQueue, WorkQueueBuilder> {
  static Serializer<WorkQueue> get serializer => _$workQueueSerializer;

  /// El crucigrama sobre el que se trabaja.
  Crossword get crossword;

  /// Ubicaciones pendientes y la dirección de la palabra a probar en cada una.
  BuiltMap<Location, Direction> get locationsToTry;

  /// Ubicaciones donde ya se probó y no entró ninguna palabra.
  BuiltSet<Location> get badLocations;

  /// Palabras que todavía no se usaron.
  BuiltSet<String> get candidateWords;

  /// La búsqueda termina cuando no quedan ubicaciones o palabras.
  bool get isCompleted => locationsToTry.isEmpty || candidateWords.isEmpty;

  /// Crea una cola de trabajo a partir de un crucigrama.
  static WorkQueue from({
    required Crossword crossword,
    required Iterable<String> candidateWords,
    required Location startLocation,
  }) => WorkQueue((b) {
    if (crossword.words.isEmpty) {
      // Descarta palabras demasiado largas para la grilla.
      b.candidateWords.addAll(
        candidateWords.where(
          (word) => word.characters.length <= crossword.width,
        ),
      );

      b.crossword.replace(crossword);

      b.locationsToTry.addAll({startLocation: Direction.across});
    } else {
      // Quita las palabras que ya están en el crucigrama.
      b.candidateWords.addAll(
        candidateWords.toBuiltSet().rebuild(
          (b) => b.removeAll(crossword.words.map((word) => word.word)),
        ),
      );
      b.crossword.replace(crossword);

      // Una letra es un buen punto de cruce si pertenece a una sola palabra
      // y no tiene vecinos que lo impidan.
      crossword.characters
          .rebuild(
            (b) => b.removeWhere((location, character) {
              if (character.acrossWord != null &&
                  character.downWord != null) {
                return true;
              }
              final left = crossword.characters[location.left];
              if (left != null && left.downWord != null) return true;
              final right = crossword.characters[location.right];
              if (right != null && right.downWord != null) return true;
              final up = crossword.characters[location.up];
              if (up != null && up.acrossWord != null) return true;
              final down = crossword.characters[location.down];
              if (down != null && down.acrossWord != null) return true;
              return false;
            }),
          )
          .forEach((location, character) {
            b.locationsToTry.addAll({
              location: switch ((character.acrossWord, character.downWord)) {
                (null, null) => throw StateError(
                  'Character is not part of a word',
                ),
                (null, _) => Direction.across,
                (_, null) => Direction.down,
                (_, _) => throw StateError('Character is part of two words'),
              },
            });
          });
    }
  });

  /// Marca una ubicación como mala y la saca de la cola.
  WorkQueue remove(Location location) {
    final crossword = this.crossword;
    final candidateWords = this.candidateWords;
    final locationsToTry = this.locationsToTry.rebuild(
      (b) => b.remove(location),
    );
    final badLocations = this.badLocations.rebuild((b) => b.add(location));

    return WorkQueue((b) {
      b.crossword.replace(crossword);
      b.candidateWords.replace(candidateWords);
      b.locationsToTry.replace(locationsToTry);
      b.badLocations.replace(badLocations);
    });
  }

  /// Actualiza la cola con un crucigrama derivado del actual.
  WorkQueue updateFrom(Crossword crossword) =>
      WorkQueue.from(
        crossword: crossword,
        candidateWords: candidateWords,
        startLocation: locationsToTry.isNotEmpty
            ? locationsToTry.keys.first
            : Location.at(0, 0),
      ).rebuild(
        (b) => b
          ..badLocations.addAll(badLocations)
          ..locationsToTry.removeWhere(
            (location, _) => badLocations.contains(location),
          ),
      );

  factory WorkQueue([void Function(WorkQueueBuilder)? updates]) = _$WorkQueue;
  WorkQueue._();
}

/// Datos ya formateados para el panel de estadísticas.
abstract class DisplayInfo implements Built<DisplayInfo, DisplayInfoBuilder> {
  static Serializer<DisplayInfo> get serializer => _$displayInfoSerializer;

  String get wordsInGridCount;
  String get candidateWordsCount;
  String get locationsToExploreCount;
  String get knownBadLocationsCount;
  String get gridFilledPercentage;

  /// Calcula las estadísticas a partir de la cola de trabajo.
  static DisplayInfo from({required WorkQueue workQueue}) {
    final gridFilled =
        (workQueue.crossword.characters.length /
        (workQueue.crossword.width * workQueue.crossword.height));
    final fmt = NumberFormat.decimalPattern();

    return DisplayInfo(
      (b) => b
        ..wordsInGridCount = fmt.format(workQueue.crossword.words.length)
        ..candidateWordsCount = fmt.format(workQueue.candidateWords.length)
        ..locationsToExploreCount = fmt.format(workQueue.locationsToTry.length)
        ..knownBadLocationsCount = fmt.format(workQueue.badLocations.length)
        ..gridFilledPercentage = '${(gridFilled * 100).toStringAsFixed(2)}%',
    );
  }

  /// Estadísticas vacías, para cuando todavía no hay datos.
  static DisplayInfo get empty => DisplayInfo(
    (b) => b
      ..wordsInGridCount = '0'
      ..candidateWordsCount = '0'
      ..locationsToExploreCount = '0'
      ..knownBadLocationsCount = '0'
      ..gridFilledPercentage = '0%',
  );

  factory DisplayInfo([void Function(DisplayInfoBuilder)? updates]) =
      _$DisplayInfo;
  DisplayInfo._();
}

/// Serializadores para todos los modelos.
@SerializersFor([
  Location,
  Direction,
  CrosswordWord,
  CrosswordCharacter,
  Crossword,
  WorkQueue,
  DisplayInfo,
])
final Serializers serializers = _$serializers;
