import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/components/ResponseOption.dart';
import 'package:quiz/components/finalPage.dart';
import 'package:quiz/components/question.dart';
import 'package:quiz/components/topMessage.dart';
import 'package:http/http.dart' as http;

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuizAppState();
  }
}

class _QuizAppState extends State<QuizApp> {
  var _questionIndex = 0;
  var correctCount = 0;
  var wrongCount = 0;
  var responseStatus = 'start';
  List<Map<dynamic, dynamic>> questions = List.empty();
  Future<List<Map<dynamic, dynamic>>>? questionsFuture;
  bool restart = false;

  _QuizAppState();

  void _sendResponse(String? userChoice) {
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

  void restartGame() {
    setState(() {
      questionsFuture = null;
      questions = List.empty();
      _questionIndex = 0;
      correctCount = 0;
      wrongCount = 0;
      responseStatus = 'start';
      questionsFuture = QuestionService().getQuestions();
      restart = true;
    });
    print("RESTARTING GAME...");
  }

  bool isRestart() {
    bool temp = restart;
    restart = false;
    return temp;
  }

  @override
  void initState() {
    super.initState();
    questionsFuture = QuestionService().getQuestions();
  }

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
            body: Container(
              child: FutureBuilder(
                future: questionsFuture,
                builder: (context, snapshot) {
                  Widget child;
                  if (snapshot.hasData && !isRestart()) {
                    questions = snapshot.data!;
                    child = questionsAppWidget();
                  } else {
                    child = const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                        ]);
                  }
                  return Center(
                    child: child,
                  );
                },
              ),
            )));
  }

  Column questionsAppWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: TopMessage(
            responseStatus: responseStatus,
          ),
        ),
        if (_questionIndex == questions.length)
          FinalPage(
            correctAnswers: correctCount,
            incorrectAnswers: wrongCount,
            buttonText: "Jogar novamente",
            buttonAction: restartGame,
          ),
        if (isValidQuestionPosition)
          Center(
            child: Question(HtmlUnescape()
                .convert(questions[_questionIndex]['question'].toString())),
          ),
        if (isValidQuestionPosition)
          ...questions[_questionIndex]['options'].map(
              (e) => ResponseOption(text: e, action: () => _sendResponse(e)))
      ],
    );
  }
}

class QuestionService {
  String api =
      'http://opentdb.com/api.php?category=27&difficulty=easy&amount=10';

  List<Map<dynamic, dynamic>> questions = List.empty();

  void customizeAnswerOptions(List<dynamic> results) {
    for (var question in results) {
      var options = List.of(question['incorrect_answers']);
      question['correct_answer'] =
          HtmlUnescape().convert(question['correct_answer']);
      options.add(HtmlUnescape().convert(question['correct_answer']));
      options.shuffle();
      options =
          options.map((element) => HtmlUnescape().convert(element)).toList();
      question['options'] = options;
    }
  }

  List<Map<dynamic, dynamic>> customizeAppQuestions(List<dynamic> results) =>
      results.map((e) => Map.from(e)).toList();

  Future<List<Map<dynamic, dynamic>>> getQuestions() async {
    var future = http.get(Uri.parse(api));

    return future.then((response) {
      var resp = jsonDecode(response.body);
      List<dynamic> results = resp['results'];
      customizeAnswerOptions(results);
      questions = customizeAppQuestions(results);
      return questions;
    });
  }
}
