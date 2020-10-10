import 'dart:math';

import 'package:flutter/foundation.dart';

class MathConstants {
  static const int defaultDuration = 5;
  static const List<int> durationOptions = [1, 2, 3, 5, 7, 10, 15, 20];

  static Map<String, QuestionGenerator Function()> sessionTypes = {
    "Easy": () => EasyQuestionGenerator(),
    "Normal": () => NormalQuestionGenerator(),
    "Hard": () => HardQuestionGenerator()
  };

  static List<String> get sessionDifficultyNames => sessionTypes.keys.toList();
  static String sessionDefaultDifficulty = sessionTypes.keys.skip(1).first;
}

class MathTest {
  final QuestionGenerator _questions;
  Question currentQuestion;

  var statsCorrect = 0;
  var statsIncorrect = 0;

  int get statsAnswerCount => statsIncorrect + statsCorrect;

  String get generatorName => _questions.name;

  MathTest(this._questions) {
    _next();
  }

  Question _next() {
    currentQuestion = _questions.next();
    return currentQuestion;
  }

  bool answer(int value) {
    bool isCorrect = currentQuestion.checkAnswer(value);
    if (isCorrect) {
      statsCorrect++;
    } else {
      statsIncorrect++;
    }
    _next();
    return isCorrect;
  }
}

class MathTestResult {
  final int correct;
  final int incorrect;
  final int duration;
  final String type;
  final DateTime time;

  int get questions => correct + incorrect;

  double get speed => ((correct / duration) * 60 * 100).roundToDouble() / 100;

  MathTestResult({
    @required this.correct,
    @required this.incorrect,
    @required this.time,
    @required this.duration,
    @required this.type,
  });

  static fromMap(Map<String, dynamic> map) {
    return MathTestResult(
        correct: map["correct"],
        incorrect: map["incorrect"],
        duration: map["duration"],
        type: map["type"],
        time: DateTime.fromMillisecondsSinceEpoch(map["time"]));
  }

  Map<String, dynamic> toMap() {
    return {
      "correct": correct,
      "incorrect": incorrect,
      "duration": duration,
      "type": type,
      "time": time.millisecondsSinceEpoch,
    };
  }
}

abstract class QuestionGenerator {
  String get name;

  Random r = new Random();

  Question next();

  int nextInt(int start, int end) {
    return r.nextInt(end - start) + start; //end exclusive
  }
}

class Question {
  String formula;

  String get formulaWithAnswer => "$formula = $refAnswer";

  int refAnswer;

  Question(this.formula, this.refAnswer);

  bool checkAnswer(int answer) {
    return answer == refAnswer;
  }

  factory Question.addition(int a, int b) {
    if (a < b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    return Question("$a + $b", a + b);
  }

  factory Question.subtraction(int a, int b) {
    if (a < b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    return Question("$a - $b", a - b);
  }

  factory Question.multiplication(int a, int b) {
    if (a < b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    return Question("$a × $b", a * b);
  }

  factory Question.division(int a, int b) {
    if (a < b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    return Question("$a / $b", (a / b).floor());
  }
}

class HardQuestionGenerator extends QuestionGenerator {
  @override
  String get name => "Hard";

  Question next() {
    switch (r.nextInt(4)) {
      case 0:
        return Question.addition(nextInt(101, 300), nextInt(101, 300));
      case 1:
        return Question.subtraction(nextInt(101, 300), nextInt(101, 300));
      case 2:
        return Question.division(nextInt(11, 300), nextInt(2, 10));
      default:
        return Question.multiplication(nextInt(12, 20), nextInt(11, 20));
    }
  }
}

class NormalQuestionGenerator extends QuestionGenerator {
  @override
  String get name => "Normal";

  Question next() {
    switch (r.nextInt(3)) {
      case 0:
        return Question.addition(nextInt(11, 100), nextInt(11, 100));
      case 1:
        return Question.subtraction(nextInt(11, 100), nextInt(11, 100));
      default:
        return Question.multiplication(nextInt(12, 20), nextInt(2, 10));
    }
  }
}

class EasyQuestionGenerator extends QuestionGenerator {
  @override
  String get name => "Easy";

  Question next() {
    switch (r.nextInt(2)) {
      case 0:
        return Question.addition(nextInt(11, 100), nextInt(2, 10));
      default:
        return Question.subtraction(nextInt(11, 100), nextInt(2, 10));
    }
  }
}
