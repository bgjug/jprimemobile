import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class FavoritesRepository {
  static const String _favoritesKey = 'favorite_session_ids';
  final SharedPreferences _prefs;

  FavoritesRepository(this._prefs);

  Future<Set<int>> getFavorites() async {
    final jsonString = _prefs.getString(_favoritesKey);
    if (jsonString == null) {
      return {};
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<int>().toSet();
  }

  Future<void> addFavorite(int sessionId) async {
    final favorites = await getFavorites();
    favorites.add(sessionId);
    await _saveFavorites(favorites);
  }

  Future<void> removeFavorite(int sessionId) async {
    final favorites = await getFavorites();
    favorites.remove(sessionId);
    await _saveFavorites(favorites);
  }

  Future<void> toggleFavorite(int sessionId) async {
    final favorites = await getFavorites();
    if (favorites.contains(sessionId)) {
      favorites.remove(sessionId);
    } else {
      favorites.add(sessionId);
    }
    await _saveFavorites(favorites);
  }

  bool isFavorite(int sessionId, Set<int> favorites) {
    return favorites.contains(sessionId);
  }

  Future<void> _saveFavorites(Set<int> favorites) async {
    final jsonString = json.encode(favorites.toList());
    await _prefs.setString(_favoritesKey, jsonString);
  }
}
