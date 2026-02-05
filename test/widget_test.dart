import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sekaijin_app/app.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';
import 'package:sekaijin_app/services/auth_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) {
            final notifier = _MockAuthNotifier(const AuthUnauthenticated());
            return notifier;
          }),
        ],
        child: const SekaijinApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('login_screen')), findsOneWidget);
  });
}

class _MockAuthNotifier extends AuthNotifier {
  final AuthState _initialState;

  _MockAuthNotifier(this._initialState)
      : super(_MockAuthRepository(), AuthService());

  @override
  AuthState get state => _initialState;
}

class _MockAuthRepository implements AuthRepository {
  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<(Failure?, User?)> login(String email, String password) async =>
      (null, null);

  @override
  Future<(Failure?, void)> logout() async => (null, null);

  @override
  Future<(Failure?, User?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? countryResidence,
    String? interestCountry,
    required bool terms,
  }) async =>
      (null, null);
}
