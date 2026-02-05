import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sekaijin_app/app.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<(Failure?, User?)> login(String email, String password) async {
    return (const AuthFailure(message: 'Identifiants invalides'), null);
  }

  @override
  Future<(Failure?, User?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? countryResidence,
    String? interestCountry,
    required bool terms,
  }) async {
    return (const ValidationFailure(message: 'Inscription désactivée en test'), null);
  }

  @override
  Future<(Failure?, void)> logout() async {
    return (null, null);
  }

  @override
  Future<bool> isAuthenticated() async {
    return false;
  }

  @override
  Future<User?> getCurrentUser() async {
    return null;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Lance l’app et affiche l’écran de connexion', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const SekaijinApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_screen')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });

  testWidgets('Navigation vers l’inscription depuis login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const SekaijinApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('register_link')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('register_button')), findsOneWidget);
  });
}
