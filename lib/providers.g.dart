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

/// Cola de trabajo de la búsqueda. Cada valor emitido trae el crucigrama
/// actual y los datos para las estadísticas.

@ProviderFor(workQueue)
final workQueueProvider = WorkQueueProvider._();

/// Cola de trabajo de la búsqueda. Cada valor emitido trae el crucigrama
/// actual y los datos para las estadísticas.

final class WorkQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.WorkQueue>,
          model.WorkQueue,
          Stream<model.WorkQueue>
        >
    with $FutureModifier<model.WorkQueue>, $StreamProvider<model.WorkQueue> {
  /// Cola de trabajo de la búsqueda. Cada valor emitido trae el crucigrama
  /// actual y los datos para las estadísticas.
  WorkQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workQueueHash();

  @$internal
  @override
  $StreamProviderElement<model.WorkQueue> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<model.WorkQueue> create(Ref ref) {
    return workQueue(ref);
  }
}

String _$workQueueHash() => r'dca73cc7fb2cef3f5dcfdcc3a0926167e88c1083';

/// Momento en que empezó la generación.

@ProviderFor(StartTime)
final startTimeProvider = StartTimeProvider._();

/// Momento en que empezó la generación.
final class StartTimeProvider extends $NotifierProvider<StartTime, DateTime?> {
  /// Momento en que empezó la generación.
  StartTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startTimeHash();

  @$internal
  @override
  StartTime create() => StartTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$startTimeHash() => r'5b637a624a48eed021215571ff83a4a2405691c3';

/// Momento en que empezó la generación.

abstract class _$StartTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Momento en que terminó la generación.

@ProviderFor(EndTime)
final endTimeProvider = EndTimeProvider._();

/// Momento en que terminó la generación.
final class EndTimeProvider extends $NotifierProvider<EndTime, DateTime?> {
  /// Momento en que terminó la generación.
  EndTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endTimeHash();

  @$internal
  @override
  EndTime create() => EndTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$endTimeHash() => r'7acd30f633755ae938883bcb0ba25a40387194df';

/// Momento en que terminó la generación.

abstract class _$EndTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Estimación del tiempo que falta para terminar.

@ProviderFor(expectedRemainingTime)
final expectedRemainingTimeProvider = ExpectedRemainingTimeProvider._();

/// Estimación del tiempo que falta para terminar.

final class ExpectedRemainingTimeProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// Estimación del tiempo que falta para terminar.
  ExpectedRemainingTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expectedRemainingTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expectedRemainingTimeHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return expectedRemainingTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$expectedRemainingTimeHash() =>
    r'45f19e0d3e281c34cb54ed7f67cc783ec5073889';

/// Si se muestra o no el panel de estadísticas.

@ProviderFor(ShowDisplayInfo)
final showDisplayInfoProvider = ShowDisplayInfoProvider._();

/// Si se muestra o no el panel de estadísticas.
final class ShowDisplayInfoProvider
    extends $NotifierProvider<ShowDisplayInfo, bool> {
  /// Si se muestra o no el panel de estadísticas.
  ShowDisplayInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showDisplayInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showDisplayInfoHash();

  @$internal
  @override
  ShowDisplayInfo create() => ShowDisplayInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showDisplayInfoHash() => r'75a0679db4cc1a0d5cfa7aa33afc633faf08fc24';

/// Si se muestra o no el panel de estadísticas.

abstract class _$ShowDisplayInfo extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Cantidad de isolates elegida (4 por defecto).

@ProviderFor(WorkerCount)
final workerCountProvider = WorkerCountProvider._();

/// Cantidad de isolates elegida (4 por defecto).
final class WorkerCountProvider
    extends $NotifierProvider<WorkerCount, BackgroundWorkers> {
  /// Cantidad de isolates elegida (4 por defecto).
  WorkerCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workerCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workerCountHash();

  @$internal
  @override
  WorkerCount create() => WorkerCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundWorkers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundWorkers>(value),
    );
  }
}

String _$workerCountHash() => r'2ad37f8d0910bc9feecb657f3b6286d4ab34ed99';

/// Cantidad de isolates elegida (4 por defecto).

abstract class _$WorkerCount extends $Notifier<BackgroundWorkers> {
  BackgroundWorkers build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BackgroundWorkers, BackgroundWorkers>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BackgroundWorkers, BackgroundWorkers>,
              BackgroundWorkers,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Estadísticas formateadas para el panel.

@ProviderFor(DisplayInfo)
final displayInfoProvider = DisplayInfoProvider._();

/// Estadísticas formateadas para el panel.
final class DisplayInfoProvider
    extends $NotifierProvider<DisplayInfo, model.DisplayInfo> {
  /// Estadísticas formateadas para el panel.
  DisplayInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayInfoHash();

  @$internal
  @override
  DisplayInfo create() => DisplayInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(model.DisplayInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<model.DisplayInfo>(value),
    );
  }
}

String _$displayInfoHash() => r'6516f6bf346baa6914fdfffad1ccee8a5345a137';

/// Estadísticas formateadas para el panel.

abstract class _$DisplayInfo extends $Notifier<model.DisplayInfo> {
  model.DisplayInfo build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<model.DisplayInfo, model.DisplayInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<model.DisplayInfo, model.DisplayInfo>,
              model.DisplayInfo,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
