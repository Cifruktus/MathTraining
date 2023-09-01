import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:math_training/core/settings/models/math_session_type.dart';

part 'app_settings_cubit.g.dart';

class AppSettingsCubit extends HydratedCubit<AppSettings> {
  AppSettingsCubit() : super(AppSettings.defaultValue());

  set mathSessionDuration (Duration val) => emit(state.copyWith(mathSessionDuration: val));
  set mathSessionType (String val) => emit(state.copyWith(mathSessionType: val));

  @override
  AppSettings fromJson(Map<String, dynamic> json) => AppSettings.fromJson(json);

  @override
  Map<String, dynamic> toJson(AppSettings state) => state.toJson();
}

@immutable @JsonSerializable()
class AppSettings {
  final String mathSessionType;
  final Duration mathSessionDuration;

  AppSettings copyWith({
    String? mathSessionType,
    Duration? mathSessionDuration,
  }) {
    return AppSettings(
        mathSessionType: mathSessionType ?? this.mathSessionType,
        mathSessionDuration: mathSessionDuration ?? this.mathSessionDuration);
  }

  factory AppSettings.defaultValue () => const AppSettings(
    mathSessionDuration: defaultDuration,
    mathSessionType: sessionDefaultDifficulty,
  );

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  const AppSettings({required this.mathSessionType, required this.mathSessionDuration});
}
