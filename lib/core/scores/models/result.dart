import 'package:json_annotation/json_annotation.dart';
import 'package:math_training/core/settings/models/math_session_type.dart';

part 'result.g.dart';

@JsonSerializable()
class MathTestResult {
  final int correct;
  final int incorrect;
  final int duration;
  final MathSessionType type;
  final DateTime time;

  int get questions => correct + incorrect;

  double get speed => ((correct / duration) * 60 * 100).roundToDouble() / 100;

  MathTestResult({
    required this.correct,
    required this.incorrect,
    required this.time,
    required this.duration,
    required this.type,
  });

  factory MathTestResult.fromJson(Map<String, dynamic> json) => _$MathTestResultFromJson(json);

  Map<String, dynamic> toJson() => _$MathTestResultToJson(this);
}
