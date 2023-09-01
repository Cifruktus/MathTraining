
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:math_training/features/math_game/util/question.dart';


part 'game_state.freezed.dart';

@freezed
class MathGameState with _$MathGameState {
  const MathGameState._();

  const factory MathGameState({
    required int duration,
    required String inputValue,
    required List<AnsweredQuestion> answered,
    required Question currentQuestion,
    required GameStateType stateType,
  }) = _MathGameState;

  bool get noMistakes {
    return answered.where((answered) => !answered.isCorrect).isEmpty;
  }
}

enum GameStateType { ready, going, paused, finished }
