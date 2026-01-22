import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/news/news_screen.dart';
import '../../presentation/screens/places/place_create_screen.dart';
import '../../presentation/screens/places/place_detail_screen.dart';
import '../../presentation/screens/places/places_list_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String add = '/add';
  static const String news = '/news';
  static const String profile = '/profile';
  static const String placeDetails = '/places/:slug';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _RouterRefreshNotifier(ref),
    redirect: (context, state) {
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Don't redirect if on splash screen (it handles its own navigation)
      if (isOnSplash) return null;

      final isAuthenticated = authState is AuthAuthenticated;

      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isOnAuthRoute) {
        return AppRoutes.login;
      }

      // If authenticated and on auth route, redirect to home
      if (isAuthenticated && isOnAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(
          onRegisterTap: () => context.go(AppRoutes.register),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => RegisterScreen(
          onLoginTap: () => context.go(AppRoutes.login),
        ),
      ),

      // Place detail route
      GoRoute(
        path: AppRoutes.placeDetails,
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return PlaceDetailScreen(slug: slug);
        },
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Explore branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const PlacesListScreen(),
              ),
            ],
          ),

          // Add branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.add,
                builder: (context, state) => const PlaceCreateScreen(),
              ),
            ],
          ),

          // News branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.news,
                builder: (context, state) => const NewsScreen(),
              ),
            ],
          ),

          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}
