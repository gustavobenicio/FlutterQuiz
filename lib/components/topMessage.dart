import 'package:flutter/material.dart';

class TopMessage extends StatelessWidget {
  final String responseStatus;
  const TopMessage({required this.responseStatus, super.key});

  @override
  Widget build(BuildContext context) {
    var responseBoolean = bool.tryParse(responseStatus);

    var mesageToShow = responseBoolean == null
        ? responseStatus == 'start'
            ? "😎 Olá Gustavo !!"
            : "😎 Good Game !!"
        : responseStatus == 'true'
            ? "😁 Acertou "
            : "😕   Errou ";

    return Container(
      child: Text(
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          mesageToShow),
      color: responseBoolean != null
          ? responseBoolean
              ? Colors.green[900]
              : Colors.red[900]
          : Colors.grey[900],
      height: 60.0,
      alignment: Alignment(0.0, 0.0),
    );
  }
}
