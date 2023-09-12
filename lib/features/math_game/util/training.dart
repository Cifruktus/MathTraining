import 'dart:math';

import 'package:math_training/core/settings/models/math_session_type.dart';
import 'package:math_training/features/math_game/util/question.dart';

QuestionGenerator getQuestionGenerator(MathSessionType type) {
  switch (type) {
    case MathSessionType.easy:
      return EasyQuestionGenerator();
    case MathSessionType.normal:
      return NormalQuestionGenerator();
    case MathSessionType.hard:
      return HardQuestionGenerator();
    case MathSessionType.hexDecode:
      return HexQuestionGenerator();
  }
}

abstract class QuestionGenerator {
  Random r = Random();

  Question next();

  int nextInt(int start, int end) {
    return r.nextInt(end - start) + start; //end exclusive
  }
}

class HardQuestionGenerator extends QuestionGenerator {
  @override
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
  Question next() {
    switch (r.nextInt(2)) {
      case 0:
        return Question.addition(nextInt(11, 100), nextInt(2, 10));
      default:
        return Question.subtraction(nextInt(11, 100), nextInt(2, 10));
    }
  }
}

class HexQuestionGenerator extends QuestionGenerator {
  @override
  Question next() {
    int val = r.nextInt(255);
    return new Question("0x" + val.toRadixString(16).toUpperCase(), val);
  }
}
