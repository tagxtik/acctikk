import 'package:acctik/global/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:acctik/view/LoginPage/log.dart';
import 'package:acctik/view/StagePage/StagePage.dart';

GoRouter goRouter() {
  final authChangeNotifier = AuthChangeNotifier();

  return GoRouter(
    initialLocation: "/login",
    routes: <RouteBase>[
      GoRoute(
        path: "/login",
        name: "Login",
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: "/Home",
        name: "Home",
        builder: (context, state) => const StagePage(),
      ),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      // Check if user is going to /Home
      final isGoingToHome = state.matchedLocation == '/Home';
      if (user == null && isGoingToHome) {
        return '/login';
      }

      // Check if user is going to /login
      final isGoingToLogin = state.matchedLocation == '/login';
      if (user != null && isGoingToLogin) {
        return '/Home';
      }

      return null; // No redirection needed
    },
    refreshListenable: authChangeNotifier, // Now using AuthChangeNotifier
  );
}
