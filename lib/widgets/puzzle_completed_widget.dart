import 'package:flutter/material.dart';

/// Pantalla que se muestra al resolver el crucigrama.
class PuzzleCompletedWidget extends StatelessWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Puzzle Completed!',
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );
  }
}
