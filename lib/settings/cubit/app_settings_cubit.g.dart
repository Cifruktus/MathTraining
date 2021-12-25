// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return AppSettings(
    mathSessionType: json['mathSessionType'] as String,
    mathSessionDuration:
        Duration(microseconds: json['mathSessionDuration'] as int),
  );
}

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'mathSessionType': instance.mathSessionType,
      'mathSessionDuration': instance.mathSessionDuration.inMicroseconds,
    };
