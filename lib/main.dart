import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/theme/theme_cubit.dart';
import 'utils/app_route.dart';
import 'utils/app_theme.dart';
import 'utils/enums.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientations and system UI overlay style
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            // App configuration
            title: "Palani Stores",
            debugShowCheckedModeBanner: false,
            // Theme configuration
            theme: AppTheme().lightTheme,
            darkTheme: AppTheme().darkTheme,
            themeMode:
                themeState == AppThemeState.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
            // Routing configuration
            routerConfig: router,
            // Scrolling behavior
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  physics: const BouncingScrollPhysics(),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeInOut);
  }
}
