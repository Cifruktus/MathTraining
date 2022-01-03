import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:math_training/math_game/models/result.dart';


part 'scored_bloc.g.dart';

@immutable @JsonSerializable()
class Scores {
  final List<MathTestResult> mathTestScores;

  const Scores({this.mathTestScores = const []});

  Iterable<MathTestResult> getResultsBySessionName(String name){
    return mathTestScores.where((r) => r.type == name);
  }

  int getProblemsSolvedBySessionName(String name){
    return mathTestScores
        .where((r) => r.type == name)
        .fold(0, (int sum, r) => sum + r.correct);
  }

  double getAverageAccuracyBySessionName(String name) {
    var selectedScores = mathTestScores.where((r) => r.type == name);
    var problemCount = selectedScores.fold(0, (int sum, r) => sum + r.questions);
    var correct = selectedScores.fold(0, (int sum, r) => sum + r.correct);

    if (problemCount == 0) return 0;
    return correct / problemCount;
  }

  double getAverageSpeedBySessionName(String name) {
    var selectedScores = mathTestScores.where((r) => r.type == name);
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
