import 'package:flutter/material.dart';

class ResponseOption extends StatelessWidget {
  final String text;
  final Function() action;
  const ResponseOption({super.key, required this.text, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 55.0,
        margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: ElevatedButton(
          onPressed: action,
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blueGrey[800])),
          child: Text(text),
        ));
  }
}
