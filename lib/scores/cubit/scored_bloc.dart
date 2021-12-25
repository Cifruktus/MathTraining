import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:math_training/math_game/models/result.dart';


part 'scored_bloc.g.dart';

@immutable @JsonSerializable()
class Scores {
  final List<MathTestResult> mathTestScores;

  const Scores({this.mathTestScores = const []});

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
