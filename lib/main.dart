import 'package:acctik/services/clear_cache.dart';
import 'package:acctik/view/LoginPage/log.dart';
import 'package:acctik/view/StagePage/StagePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acctik/controller/landing/landing_cubit.dart';
import 'package:acctik/controller/lang/language_cubit.dart';
import 'package:acctik/controller/theme/theme_cubit_cubit.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/routing/router.dart'; // Your go_router setup file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:acctik/generated/l10n.dart'; // Localization setup
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final initialLocaleCode = prefs.getString('locale') ?? 'en';
  final initialLocale = Locale(initialLocaleCode);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit()..initializeTheme()),
        BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(initialLocale)),
        BlocProvider<LandingPageCubit>(create: (context) => LandingPageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, theme) {
          return ChangeNotifierProvider(
            create: (context) => JornalChangemod(),
            child: BlocBuilder<LanguageCubit, Locale>(
              builder: (context, language) {
                final router = goRouter(); // Your GoRouter setup

                return MaterialApp.router(
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {PointerDeviceKind.mouse},
                  ),
                  routerConfig: router, // Configured routes

                  // Set up theming
                  themeMode:
                      theme, // Use the current theme mode from ThemeCubit
                  theme: ThemeData.light(), // Light theme
                  darkTheme: ThemeData.dark(), // Dark theme

                  // Language and localization settings
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  locale: language,
                  debugShowCheckedModeBanner: false,

                  // Home is replaced by the AuthWrapper to handle login checks
                  // home: const AuthWrapper(),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for Firebase to load, show a loading indicator
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is logged in, navigate to home page
          return const StagePage();
        } else {
          // User is not logged in, navigate to login page
          return const Login();
        }
      },
    );
  }
}
