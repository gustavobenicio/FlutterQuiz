import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/components/ResponseOption.dart';
import 'package:quiz/components/finalPage.dart';
import 'package:quiz/components/question.dart';
import 'package:quiz/components/topMessage.dart';

class QuizApp extends StatefulWidget {
  final List<Map<dynamic, dynamic>> questions;
  const QuizApp({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() {
    return _QuizAppState(questions: questions);
  }
}

class _QuizAppState extends State<QuizApp> {
  var _questionIndex = 0;
  var correctCount = 0;
  var wrongCount = 0;
  var responseStatus = 'start';
  List<Map<dynamic, dynamic>> questions;

  _QuizAppState({required this.questions});

  _sendResponse(String? userChoice) {
    var isCorrect = questions[_questionIndex]['correct_answer'] == userChoice;
    responseStatus = isCorrect.toString();

    increaseCorrectIncorrectResponses(isCorrect);

    if (isLastQuestion) {
      responseStatus = "fim";
    }
    if (isValidQuestionPosition) {
      setState(() => _questionIndex++);
    }
  }

  void increaseCorrectIncorrectResponses(bool isCorrect) {
    isCorrect ? ++correctCount : ++wrongCount;
  }

  bool get isLastQuestion => _questionIndex == questions.length - 1;

  bool get isValidQuestionPosition => _questionIndex < questions.length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: const Text(
            "Quiz App",
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: TopMessage(
                responseStatus: responseStatus,
              ),
            ),
            if (_questionIndex == questions.length)
              FinalPage(
                  correctAnswers: correctCount, incorrectAnswers: wrongCount),
            if (isValidQuestionPosition)
              Center(
                child: Question(HtmlUnescape()
                    .convert(questions[_questionIndex]['question'].toString())),
              ),
            if (isValidQuestionPosition)
              ...questions[_questionIndex]['options'].map((e) =>
                  ResponseOption(text: e, action: () => _sendResponse(e)))
          ],
        ),
      ),
    );
  }
}
