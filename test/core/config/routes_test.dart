import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/config/routes.dart';

void main() {
  group('AppRoutes', () {
    test('splash route is root path', () {
      expect(AppRoutes.splash, '/');
    });

    test('login route is /login', () {
      expect(AppRoutes.login, '/login');
    });

    test('register route is /register', () {
      expect(AppRoutes.register, '/register');
    });

    test('home route is /home', () {
      expect(AppRoutes.home, '/home');
    });

    test('explore route is /explore', () {
      expect(AppRoutes.explore, '/explore');
    });

    test('add route is /add', () {
      expect(AppRoutes.add, '/add');
    });

    test('news route is /news', () {
      expect(AppRoutes.news, '/news');
    });

    test('profile route is /profile', () {
      expect(AppRoutes.profile, '/profile');
    });

    test('placeDetails route has id parameter', () {
      expect(AppRoutes.placeDetails, '/place/:id');
    });
  });
}
