import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String placeDetails = '/place/:id';
  static const String search = '/search';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Home - Coming Soon')),
      ),
    ),
  ],
);
