import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/auth/profile_page.dart';
import 'features/workouts/workout_log_page.dart';
import 'features/progress/progress_page.dart';
import 'features/schedule/schedule_page.dart';
import 'features/social/social_page.dart';
import 'features/workouts/workout_model.dart';
import 'common/theme.dart';
import 'welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitgym/l10n/app_localizations.dart';

class ThemeLocaleNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class FitGymApp extends StatelessWidget {
  const FitGymApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const WelcomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfilePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/workout-log',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const WorkoutLogPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProgressPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/schedule',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SchedulePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: '/social',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SocialPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutModel()),
        ChangeNotifierProvider(create: (_) => ThemeLocaleNotifier()),
      ],
      child: Consumer<ThemeLocaleNotifier>(
        builder: (context, themeLocale, _) {
          return MaterialApp.router(
            title: 'FitGym',
            theme: appLightTheme,
            darkTheme: appDarkTheme,
            themeMode: themeLocale.themeMode,
            locale: themeLocale.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
          );
        },
      ),
    );
  }
} 