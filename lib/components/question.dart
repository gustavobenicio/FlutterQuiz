import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  const Question(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      alignment: const Alignment(0.0, 0.0),
      margin: const EdgeInsets.all(12),
      height: 100,
      child: Text(
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        text,
      ),
    );
  }
}
