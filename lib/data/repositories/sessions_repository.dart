import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:jprimemobile/data/models/session.dart';

@lazySingleton
class SessionsRepository {
  final http.Client _client;
  static const String baseUrl = 'https://jprime.io';

  SessionsRepository(this._client);

  Future<Either<String, List<Session>>> getSessionsByHall(String hallName) async {
    try {
      final encodedHallName = Uri.encodeComponent(hallName);
      final url = Uri.parse('$baseUrl/pwa/findSessionsByHall?hallName=$encodedHallName');

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final sessions = jsonList
            .map((json) => Session.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(sessions);
      } else {
        return Left('Failed to load sessions: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error loading sessions: $e');
    }
  }

  Future<Either<String, List<Session>>> getSessionsByHallAndDate(
    String hallName,
    DateTime date,
  ) async {
    final result = await getSessionsByHall(hallName);
    return result.map((sessions) {
      return sessions.where((session) {
        return session.startTime.year == date.year &&
            session.startTime.month == date.month &&
            session.startTime.day == date.day;
      }).toList();
    });
  }

  Future<Either<String, List<DateTime>>> getAvailableDates() async {
    try {
      final halls = ['hall A', 'hall B', 'workshops'];
      final allDates = <DateTime>{};

      for (final hall in halls) {
        final result = await getSessionsByHall(hall);
        result.fold(
          (error) => null,
          (sessions) {
            for (final session in sessions) {
              final date = DateTime(
                session.startTime.year,
                session.startTime.month,
                session.startTime.day,
              );
              allDates.add(date);
            }
          },
        );
      }

      final sortedDates = allDates.toList()..sort();
      return Right(sortedDates);
    } catch (e) {
      return Left('Error loading available dates: $e');
    }
  }
}
