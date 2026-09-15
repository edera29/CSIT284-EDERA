import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  String selectedAnswer = "";

  List<String> questions = [
    "What is the capital of the Philippines?",
    "Which planet is known as the Red Planet?",
    "How many days are there in a week?",
    "Which language is used to build Flutter apps?",
    "What is 5 + 5?",
  ];

  List<List<String>> options = [
    ["Cebu", "Davao", "Manila", "Baguio"],
    ["Earth", "Mars", "Jupiter", "Venus"],
    ["5", "6", "7", "8"],
    ["Java", "Dart", "Python", "C++"],
    ["8", "9", "10", "11"],
  ];

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              questions[currentQuestion],
              style: const TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            for (String choice in options[currentQuestion])
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswer == choice
                        ? Colors.blue
                        : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    selectAnswer(choice);
                  },
                  child: Text(choice),
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text("Next Question"),
            ),
          ],
        ),
      ),
    );
  }
}