// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lista de palabras cargada desde assets/words.txt.

@ProviderFor(wordList)
final wordListProvider = WordListProvider._();

/// Lista de palabras cargada desde assets/words.txt.

final class WordListProvider
    extends
        $FunctionalProvider<
          AsyncValue<BuiltSet<String>>,
          BuiltSet<String>,
          FutureOr<BuiltSet<String>>
        >
    with $FutureModifier<BuiltSet<String>>, $FutureProvider<BuiltSet<String>> {
  /// Lista de palabras cargada desde assets/words.txt.
  WordListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordListHash();

  @$internal
  @override
  $FutureProviderElement<BuiltSet<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BuiltSet<String>> create(Ref ref) {
    return wordList(ref);
  }
}

String _$wordListHash() => r'07003444d7241448561b638500001e31610b4717';

/// Tamaño seleccionado del crucigrama.

@ProviderFor(Size)
final sizeProvider = SizeProvider._();

/// Tamaño seleccionado del crucigrama.
final class SizeProvider extends $NotifierProvider<Size, CrosswordSize> {
  /// Tamaño seleccionado del crucigrama.
  SizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sizeHash();

  @$internal
  @override
  Size create() => Size();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrosswordSize value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrosswordSize>(value),
    );
  }
}

String _$sizeHash() => r'e551985965bf4119e8d90c0e8aa4f4d68a555b73';

/// Tamaño seleccionado del crucigrama.

abstract class _$Size extends $Notifier<CrosswordSize> {
  CrosswordSize build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CrosswordSize, CrosswordSize>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CrosswordSize, CrosswordSize>,
              CrosswordSize,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Genera un crucigrama colocando palabras al azar cada 100 ms
/// hasta llenar el 80 % de las celdas.

@ProviderFor(crossword)
final crosswordProvider = CrosswordProvider._();

/// Genera un crucigrama colocando palabras al azar cada 100 ms
/// hasta llenar el 80 % de las celdas.

final class CrosswordProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.Crossword>,
          model.Crossword,
          Stream<model.Crossword>
        >
    with $FutureModifier<model.Crossword>, $StreamProvider<model.Crossword> {
  /// Genera un crucigrama colocando palabras al azar cada 100 ms
  /// hasta llenar el 80 % de las celdas.
  CrosswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crosswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crosswordHash();

  @$internal
  @override
  $StreamProviderElement<model.Crossword> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<model.Crossword> create(Ref ref) {
    return crossword(ref);
  }
}

String _$crosswordHash() => r'5de9f05091b3f0dad7c14a322ba090df2e63fae0';
