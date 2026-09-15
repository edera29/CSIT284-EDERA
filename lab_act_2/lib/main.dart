import 'package:flutter/material.dart';
import 'theme.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
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
  bool answered = false;
  bool quizFinished = false;
  int score = 0;

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

  List<String> correctAnswers = [
    "Manila",
    "Mars",
    "7",
    "Dart",
    "10",
  ];

  void selectAnswer(String answer) {
    if (answered) return;

    setState(() {
      selectedAnswer = answer;
      answered = true;

      if (answer == correctAnswers[currentQuestion]) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = "";
        answered = false;
      });
    } else {
      setState(() {
        quizFinished = true;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      selectedAnswer = "";
      answered = false;
      quizFinished = false;
      score = 0;
    });
  }

  Color getButtonColor(String choice) {
    if (!answered) {
      return AppTheme.cream;
    }

    if (choice == correctAnswers[currentQuestion]) {
      return AppTheme.green;
    }

    if (choice == selectedAnswer) {
      return AppTheme.orange;
    }

    return AppTheme.cream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: quizFinished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Quiz Finished!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brown,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Your Final Score: $score / ${questions.length}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppTheme.green,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: restartQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Take Quiz Again"),
                    ),
                  ],
                ),
              )

            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Score: $score",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Question ${currentQuestion + 1} of ${questions.length}",
                    style: const TextStyle(
                      color: AppTheme.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    questions[currentQuestion],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  for (String choice in options[currentQuestion])
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getButtonColor(choice),
                            foregroundColor: answered
                                ? Colors.white
                                : AppTheme.brown,
                          ),
                          onPressed: () => selectAnswer(choice),
                          child: Text(choice),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  if (answered)
                    Text(
                      selectedAnswer == correctAnswers[currentQuestion]
                          ? "Correct!"
                          : "Wrong!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            selectedAnswer == correctAnswers[currentQuestion]
                                ? AppTheme.green
                                : AppTheme.orange,
                      ),
                    ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: answered ? nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      currentQuestion == questions.length - 1
                          ? "Finish Quiz"
                          : "Next Question",
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}