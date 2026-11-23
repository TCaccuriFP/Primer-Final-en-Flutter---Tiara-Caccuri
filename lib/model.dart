import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';

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

/// Serializadores para todos los modelos.
@SerializersFor([
  Location,
  Direction,
  CrosswordWord,
  CrosswordCharacter,
  Crossword,
])
final Serializers serializers = _$serializers;
