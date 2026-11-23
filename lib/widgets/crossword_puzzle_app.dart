import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';

/// Pantalla principal: muestra la generación, luego el juego y, al
/// resolverlo, la pantalla de felicitaciones.
class CrosswordPuzzleApp extends StatelessWidget {
  const CrosswordPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: [_CrosswordPuzzleAppMenu()],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: Text('Crossword Puzzle'),
        ),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzleSolved = ref.watch(
                puzzleProvider.select((puzzle) => puzzle.solved),
              );
              final puzzleReady = ref.watch(
                puzzleProvider.select(
                  (puzzle) => puzzle.crossword.words.isNotEmpty,
                ),
              );

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty &&
                      puzzleReady) {
                    return CrosswordPuzzleWidget();
                  }
                  return CrosswordGeneratorWidget();
                },
                error: (error, stackTrace) => Center(child: Text('$error')),
                loading: () => Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Carga la lista de palabras apenas arranca la app.
class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

/// Menú para elegir tamaño, cantidad de isolates y mostrar estadísticas.
class _CrosswordPuzzleAppMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
    menuChildren: [
      for (final entry in CrosswordSize.values)
        MenuItemButton(
          onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
          leadingIcon: entry == ref.watch(sizeProvider)
              ? Icon(Icons.radio_button_checked_outlined)
              : Icon(Icons.radio_button_unchecked_outlined),
          child: Text(entry.label),
        ),
      SubmenuButton(
        menuChildren: [
          for (final count in BackgroundWorkers.values)
            MenuItemButton(
              leadingIcon: count == ref.watch(workerCountProvider)
                  ? Icon(Icons.radio_button_checked_outlined)
                  : Icon(Icons.radio_button_unchecked_outlined),
              onPressed: () =>
                  ref.read(workerCountProvider.notifier).setCount(count),
              child: Text(count.label),
            ),
        ],
        child: Text('Background Workers'),
      ),
      MenuItemButton(
        leadingIcon: ref.watch(showDisplayInfoProvider)
            ? Icon(Icons.check_box_outlined)
            : Icon(Icons.check_box_outline_blank_outlined),
        onPressed: () => ref.read(showDisplayInfoProvider.notifier).toggle(),
        child: Text('Display Info'),
      ),
    ],
    builder: (context, controller, child) => IconButton(
      onPressed: () => controller.open(),
      icon: Icon(Icons.settings),
    ),
  );
}
