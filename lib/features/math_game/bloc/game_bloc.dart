import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:math_training/core/scores/models/result.dart';
import 'package:math_training/core/settings/cubit/app_settings_cubit.dart';
import 'package:math_training/features/math_game/bloc/game_events.dart';
import 'package:math_training/features/math_game/bloc/game_state.dart';
import 'package:math_training/features/math_game/util/ticker.dart';
import 'package:math_training/features/math_game/util/training.dart';

class MathGameBloc extends Bloc<MathGameEvent, MathGameState> {
  final Ticker _ticker;
  final QuestionGenerator _questions;
  final Duration _duration;

  Duration get duration => _duration;

  String get sessionType => _questions.name;

  StreamSubscription<int>? _tickerSubscription;

  factory MathGameBloc.fromSettings(AppSettings settings) {
    var questions = getQuestionGenerator(settings.mathSessionType);
    var duration = settings.mathSessionDuration;

    return MathGameBloc(
      questions: questions,
      duration: duration,
    );
  }

  MathGameBloc({required QuestionGenerator questions, required Duration duration})
      : _ticker = const Ticker(),
        _questions = questions,
        _duration = duration,
        super(MathGameState(
          answered: [],
          inputValue: '',
          duration: duration.inSeconds,
          stateType: GameStateType.ready,
          currentQuestion: questions.next(),
        )) {
    on<MathGamePaused>(_onPaused);
    on<MathGameResumed>(_onResumed);
    on<MathGameTimerTicked>(_onTicked);
    on<MathGameNewInputData>(_onNewInputData);
    on<MathGameOnOkInput>(_onAccept);
    on<MathGameStart>(_onStartGame);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  MathTestResult? getResult() {
    if (state.stateType != GameStateType.finished) return null;

    var time = DateTime.now();
    int correct = 0;
    int incorrect = 0;
    for (var question in state.answered) {
      if (question.isCorrect) {
        correct++;
      } else {
        incorrect++;
      }
    }

    return MathTestResult(
      duration: _duration.inSeconds,
      correct: correct,
      incorrect: incorrect,
      time: time,
      type: _questions.name,
    );
  }

  void _onStartGame(MathGameStart event, Emitter<MathGameState> emit) {
    if (state.stateType == GameStateType.ready) {
      emit(state.copyWith(stateType: GameStateType.going));
      _tickerSubscription?.cancel();
      _tickerSubscription =
          _ticker.tick(ticks: state.duration).listen((duration) => add(MathGameTimerTicked(duration: duration)));
      return;
    }
  }

  void _onNewInputData(MathGameNewInputData event, Emitter<MathGameState> emit) {
    emit(state.copyWith(inputValue: event.input));
  }

  void _onAccept(MathGameOnOkInput event, Emitter<MathGameState> emit) {
    if (state.stateType == GameStateType.going) {
      if (event.input.isEmpty) return;
      var answered = state.currentQuestion.asAnswered(int.tryParse(event.input) ?? -1);
      var next = _questions.next();
      emit(state.copyWith(
        inputValue: "",
        answered: [...state.answered, answered],
        currentQuestion: next,
      ));
    }
  }

  void _onPaused(MathGamePaused event, Emitter<MathGameState> emit) {
    if (state.stateType == GameStateType.going) {
      _tickerSubscription?.pause();
      emit(state.copyWith(stateType: GameStateType.paused));
    }
  }

  void _onResumed(MathGameResumed resume, Emitter<MathGameState> emit) {
    if (state.stateType == GameStateType.paused) {
      _tickerSubscription?.resume();
      emit(state.copyWith(stateType: GameStateType.going));
    }
  }

  void _onTicked(MathGameTimerTicked event, Emitter<MathGameState> emit) {
    emit(
      event.duration > 0
          ? state.copyWith(duration: event.duration)
          : state.copyWith(stateType: GameStateType.finished, duration: 0),
    );
  }
}
