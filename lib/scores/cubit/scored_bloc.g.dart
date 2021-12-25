// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scored_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scores _$ScoresFromJson(Map<String, dynamic> json) {
  return Scores(
    mathTestScores: (json['mathTestScores'] as List<dynamic>)
        .map((e) => MathTestResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ScoresToJson(Scores instance) => <String, dynamic>{
      'mathTestScores': instance.mathTestScores,
    };
