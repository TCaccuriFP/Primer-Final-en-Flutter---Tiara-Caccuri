import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Vuelve a construir su contenido en cada frame. Sirve para mostrar un
/// reloj que avanza en tiempo real.
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({super.key, required this.builder});

  final Widget Function(BuildContext) builder;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_handleTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleTick(Duration elapsed) {
    setState(() {
      // Fuerza la reconstrucción.
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder.call(context);
}
