import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required int id,
    required String hallName,
    required String title,
    String? lectorName,
    String? talkDescription,
    required DateTime startTime,
    required DateTime endTime,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
