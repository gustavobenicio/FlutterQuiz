import 'package:flutter/material.dart';

class FinalPage extends StatelessWidget {
  final int correctAnswers;
  final int incorrectAnswers;

  const FinalPage(
      {super.key,
      required this.correctAnswers,
      required this.incorrectAnswers});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      alignment: const Alignment(0.0, 0.0),
      margin: const EdgeInsets.all(12),
      height: 600,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              "Final Score ",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                "Acertos:  $correctAnswers"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              "Erros:  $incorrectAnswers",
            ),
          ),
        ],
      ),
    );
  }
}
