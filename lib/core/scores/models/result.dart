import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false, createFactory: false)
class MathTestResult {
  final int correct;
  final int incorrect;
  final int duration;
  final String type;
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

  factory MathTestResult.fromJson(Map<String, dynamic> map) {
    return MathTestResult(
        correct: map["correct"],
        incorrect: map["incorrect"],
        duration: map["duration"],
        type: map["type"],
        time: DateTime.fromMillisecondsSinceEpoch(map["time"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "correct": correct,
      "incorrect": incorrect,
      "duration": duration,
      "type": type,
      "time": time.millisecondsSinceEpoch,
    };
  }
}
