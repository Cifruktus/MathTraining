import 'package:equatable/equatable.dart';
import 'package:math_training/math_game/models/question.dart';

class MathGameState extends Equatable {
  final int duration;
  final String inputValue;
  final List<AnsweredQuestion> answered;
  final Question currentQuestion;
  final GameStateType stateType;

  bool get noMistakes {
    return answered.where((answered) => !answered.isCorrect).isEmpty;
  }

  const MathGameState({
    required this.duration,
    this.answered = const [],
    required this.currentQuestion,
    this.inputValue = "",
    required this.stateType,
  });

  MathGameState copyWith({
    int? duration,
    String? inputValue,
    List<AnsweredQuestion>? answered,
    GameStateType? stateType,
    Question? currentQuestion,
  }) {
    return MathGameState(
      duration: duration ?? this.duration,
      inputValue: inputValue ?? this.inputValue,
      answered: answered ?? this.answered,
      stateType: stateType ?? this.stateType,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }

  @override
  List<Object> get props => [
        duration,
        inputValue,
        answered,
        stateType,
      ];
}

enum GameStateType { ready, going, paused, finished }
