import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/data/repositories/sessions_repository.dart';

part 'sessions_cubit.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState.initial() = _Initial;
  const factory SessionsState.loading() = _Loading;
  const factory SessionsState.loaded(List<Session> sessions) = _Loaded;
  const factory SessionsState.error(String message) = _Error;
}

@injectable
class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository;

  SessionsCubit(this._repository) : super(const SessionsState.initial());

  Future<void> loadSessions(String hallName, {DateTime? date}) async {
    emit(const SessionsState.loading());
    final result = date != null
        ? await _repository.getSessionsByHallAndDate(hallName, date)
        : await _repository.getSessionsByHall(hallName);
    result.fold(
      (error) => emit(SessionsState.error(error)),
      (sessions) => emit(SessionsState.loaded(sessions)),
    );
  }

  void reset() {
    emit(const SessionsState.initial());
  }
}
