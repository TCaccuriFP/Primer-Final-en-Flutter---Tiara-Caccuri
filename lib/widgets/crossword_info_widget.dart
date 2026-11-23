import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../utils.dart';
import 'ticker_builder.dart';

/// Panel con estadísticas de la generación, en la esquina inferior derecha.
class CrosswordInfoWidget extends ConsumerWidget {
  const CrosswordInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    final displayInfo = ref.watch(displayInfoProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final remaining = ref.watch(expectedRemainingTimeProvider);
    final workers = ref.watch(workerCountProvider);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32.0, bottom: 32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(230),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  children: [
                    _infoRow(
                      label: 'Grid Size',
                      value: '${size.width} x ${size.height}',
                    ),
                    _infoRow(label: 'Max worker count', value: workers.label),
                    _infoRow(
                      label: 'Words in grid',
                      value: displayInfo.wordsInGridCount,
                    ),
                    _infoRow(
                      label: 'Candidate words',
                      value: displayInfo.candidateWordsCount,
                    ),
                    _infoRow(
                      label: 'Locations to explore',
                      value: displayInfo.locationsToExploreCount,
                    ),
                    _infoRow(
                      label: 'Known bad locations',
                      value: displayInfo.knownBadLocationsCount,
                    ),
                    _infoRow(
                      label: 'Grid filled',
                      value: displayInfo.gridFilledPercentage,
                    ),
                    switch ((startTime, endTime)) {
                      (null, _) => _infoRow(
                        label: 'Time elapsed',
                        value: 'Not started yet',
                      ),
                      (DateTime start, null) => TableRow(
                        children: [
                          _cell(Text('Time elapsed')),
                          _cell(
                            TickerBuilder(
                              builder: (context) => Text(
                                DateTime.now().difference(start).formatted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      (DateTime start, DateTime end) => _infoRow(
                        label: 'Completed in',
                        value: end.difference(start).formatted,
                      ),
                    },
                    if (startTime != null && endTime == null)
                      _infoRow(
                        label: 'Est. remaining',
                        value: remaining.formatted,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TableRow _infoRow({required String label, required String value}) =>
    TableRow(children: [_cell(Text(label)), _cell(Text(value))]);

Widget _cell(Widget child) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 4.0),
  child: child,
);
