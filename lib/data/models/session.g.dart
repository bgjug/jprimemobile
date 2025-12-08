// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: (json['id'] as num).toInt(),
      hallName: json['hallName'] as String,
      title: json['title'] as String,
      lectorName: json['lectorName'] as String?,
      talkDescription: json['talkDescription'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hallName': instance.hallName,
      'title': instance.title,
      'lectorName': instance.lectorName,
      'talkDescription': instance.talkDescription,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
