// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/repositories/favorites_repository.dart' as _i803;
import '../../data/repositories/sessions_repository.dart' as _i295;
import '../../presentation/cubits/favorites_cubit.dart' as _i139;
import '../../presentation/cubits/sessions_cubit.dart' as _i402;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i803.FavoritesRepository>(
      () => _i803.FavoritesRepository(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i295.SessionsRepository>(
      () => _i295.SessionsRepository(gh<_i519.Client>()),
    );
    gh.factory<_i402.SessionsCubit>(
      () => _i402.SessionsCubit(gh<_i295.SessionsRepository>()),
    );
    gh.factory<_i139.FavoritesCubit>(
      () => _i139.FavoritesCubit(gh<_i803.FavoritesRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
