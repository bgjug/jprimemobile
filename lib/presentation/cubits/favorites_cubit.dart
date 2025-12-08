import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jprimemobile/data/repositories/favorites_repository.dart';

part 'favorites_cubit.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    required Set<int> favoriteIds,
    required bool isLoading,
  }) = _FavoritesState;

  factory FavoritesState.initial() => const FavoritesState(
        favoriteIds: {},
        isLoading: false,
      );
}

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(FavoritesState.initial()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    emit(state.copyWith(isLoading: true));
    final favorites = await _repository.getFavorites();
    emit(state.copyWith(favoriteIds: favorites, isLoading: false));
  }

  Future<void> toggleFavorite(int sessionId) async {
    await _repository.toggleFavorite(sessionId);
    await _loadFavorites();
  }

  bool isFavorite(int sessionId) {
    return state.favoriteIds.contains(sessionId);
  }
}
