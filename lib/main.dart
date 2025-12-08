import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';
import 'package:jprimemobile/presentation/cubits/favorites_cubit.dart';
import 'package:jprimemobile/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FavoritesCubit>(),
      child: MaterialApp(
        title: 'jPrime Conference',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
