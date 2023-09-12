import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:math_training/core/scores/models/result.dart';
import 'package:math_training/core/settings/models/math_session_type.dart';


part 'scored_bloc.g.dart';

@immutable @JsonSerializable()
class Scores {
  final List<MathTestResult> mathTestScores;

  const Scores({this.mathTestScores = const []});

  Iterable<MathTestResult> getResultsBySessionType(MathSessionType type){
    return mathTestScores.where((r) => r.type == type);
  }

  int getProblemsSolvedBySessionType(MathSessionType type){
    return mathTestScores
        .where((r) => r.type == type)
        .fold(0, (int sum, r) => sum + r.correct);
  }

  double getAverageAccuracyBySessionType(MathSessionType type) {
    var selectedScores = mathTestScores.where((r) => r.type == type);
    var problemCount = selectedScores.fold(0, (int sum, r) => sum + r.questions);
    var correct = selectedScores.fold(0, (int sum, r) => sum + r.correct);

    if (problemCount == 0) return 0;
    return correct / problemCount;
  }

  double getAverageSpeedBySessionType(MathSessionType type) {
    var selectedScores = mathTestScores.where((r) => r.type == type);
    var totalProblems = selectedScores.fold(0, (int sum, r) => sum + r.correct);
    var totalTime = selectedScores.fold(0, (int sum, r) => sum + r.duration) / 60; // converting to minutes

    if (totalTime == 0) return 0;
    return totalProblems / totalTime;
  }

  static Scores fromJson(Map<String, dynamic> json){
    return _$ScoresFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ScoresToJson(this);
  }
}

class ScoresCubit extends HydratedCubit<Scores> {
  ScoresCubit() : super(const Scores());

  void addScore(MathTestResult score) {
    emit(Scores(mathTestScores: [...state.mathTestScores, score]));
  }

  void clearScores(){
    emit(const Scores(mathTestScores: []));
  }

  @override
  Scores? fromJson(Map<String, dynamic> json) {
    return Scores.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Scores state) {
    return state.toJson();
  }
}
