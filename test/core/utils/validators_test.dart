import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/utils/validators.dart';

void main() {
  group('Validators.pseudo', () {
    test('returns error when empty', () {
      expect(Validators.pseudo(null), 'Le pseudo est requis');
      expect(Validators.pseudo(''), 'Le pseudo est requis');
    });

    test('returns error when too short', () {
      expect(Validators.pseudo('ab'), contains('entre 3 et 255'));
    });

    test('returns error when too long', () {
      final longPseudo = 'a' * 256;
      expect(Validators.pseudo(longPseudo), contains('entre 3 et 255'));
    });

    test('returns error for invalid characters at start', () {
      expect(Validators.pseudo('.test'), contains('Caractères autorisés'));
      expect(Validators.pseudo('_test'), contains('Caractères autorisés'));
      expect(Validators.pseudo('-test'), contains('Caractères autorisés'));
    });

    test('returns error for invalid characters at end', () {
      expect(Validators.pseudo('test.'), contains('Caractères autorisés'));
      expect(Validators.pseudo('test_'), contains('Caractères autorisés'));
      expect(Validators.pseudo('test-'), contains('Caractères autorisés'));
    });

    test('returns null for valid pseudo', () {
      expect(Validators.pseudo('abc'), isNull);
      expect(Validators.pseudo('testuser'), isNull);
      expect(Validators.pseudo('test_user'), isNull);
      expect(Validators.pseudo('test.user'), isNull);
      expect(Validators.pseudo('test-user'), isNull);
      expect(Validators.pseudo('Test123'), isNull);
    });
  });

  group('Validators.registerPassword', () {
    test('returns error when empty', () {
      expect(Validators.registerPassword(null), 'Le mot de passe est requis');
      expect(Validators.registerPassword(''), 'Le mot de passe est requis');
    });

    test('returns error when less than 12 characters', () {
      expect(
        Validators.registerPassword('Short1A'),
        contains('au moins 12 caractères'),
      );
    });

    test('returns error when no uppercase', () {
      expect(
        Validators.registerPassword('lowercase12345'),
        contains('au moins une majuscule'),
      );
    });

    test('returns error when no lowercase', () {
      expect(
        Validators.registerPassword('UPPERCASE12345'),
        contains('au moins une minuscule'),
      );
    });

    test('returns error when no digit', () {
      expect(
        Validators.registerPassword('NoDigitsHere!'),
        contains('au moins un chiffre'),
      );
    });

    test('returns null for valid password', () {
      expect(Validators.registerPassword('ValidPass123'), isNull);
      expect(Validators.registerPassword('MySecurePassword1'), isNull);
      expect(Validators.registerPassword('Test12345678'), isNull);
    });
  });

  group('Validators.confirmRegisterPassword', () {
    test('returns error when empty', () {
      expect(
        Validators.confirmRegisterPassword(null, 'password'),
        'Veuillez confirmer votre mot de passe',
      );
      expect(
        Validators.confirmRegisterPassword('', 'password'),
        'Veuillez confirmer votre mot de passe',
      );
    });

    test('returns error when passwords do not match', () {
      expect(
        Validators.confirmRegisterPassword('password1', 'password2'),
        'Les mots de passe ne correspondent pas',
      );
    });

    test('returns null when passwords match', () {
      expect(
        Validators.confirmRegisterPassword('ValidPass123', 'ValidPass123'),
        isNull,
      );
    });
  });

  group('Validators.email', () {
    test('returns error when empty', () {
      expect(Validators.email(null), contains('requis'));
      expect(Validators.email(''), contains('requis'));
    });

    test('returns error for invalid email', () {
      expect(Validators.email('invalid'), contains('valide'));
      expect(Validators.email('invalid@'), contains('valide'));
      expect(Validators.email('@invalid.com'), contains('valide'));
    });

    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('user.name@domain.co.uk'), isNull);
    });
  });
}
