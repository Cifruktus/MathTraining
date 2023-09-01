import 'package:flutter/foundation.dart';

@immutable
class Question {
  final String formula;
  final int refAnswer;

  String get formulaWithAnswer => "$formula = $refAnswer";

  const Question(this.formula, this.refAnswer);

  bool checkAnswer(int answer) {
    return answer == refAnswer;
  }

  AnsweredQuestion asAnswered(int answer) {
    return AnsweredQuestion(formula, refAnswer, answer);
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

class AnsweredQuestion extends Question {
  final int answer;

  bool get isCorrect => checkAnswer(answer);

  const AnsweredQuestion(String formula, int refAnswer, this.answer) : super(formula, refAnswer);
}