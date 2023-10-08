import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz/Quiz.dart';
import 'package:http/http.dart' as http;

main() {
  const api =
      'http://opentdb.com/api.php?category=27&difficulty=easy&amount=10';

  List<Map<dynamic, dynamic>> questions = new List.empty();
  callRunApp() => runApp(QuizApp(questions: questions));

  var future = http.get(Uri.parse(api));

  future.then((response) {
    var resp = jsonDecode(response.body);
    List<dynamic> results = resp['results'];
    customizeAnswerOptions(results);
    questions = customizeAppQuestions(results);
    callRunApp();
  });
}

List<Map<dynamic, dynamic>> customizeAppQuestions(List<dynamic> results) =>
    results.map((e) => Map.from(e)).toList();

void customizeAnswerOptions(List<dynamic> results) {
  for (var question in results) {
    var options = List.of(question['incorrect_answers']);
    options.add(question['correct_answer']);
    options.shuffle();
    question['options'] = options;
  }
}
