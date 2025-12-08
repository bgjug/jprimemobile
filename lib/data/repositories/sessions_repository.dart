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
}
