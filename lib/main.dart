import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc_providers.dart';
import 'di/di_module.dart';
import 'features/presentation/ui/app_theme.dart';
import 'features/presentation/ui/bloc/theme/theme_cubit.dart';
import 'features/presentation/ui/enums.dart';
import 'utils/app_route.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientations and system UI overlay style
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await DiModule().init();
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            // App configuration
            title: "S.Palani Store",
            debugShowCheckedModeBanner: false,
            // Theme configuration
            theme: AppTheme().lightTheme,
            //darkTheme: AppTheme().darkTheme,
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
