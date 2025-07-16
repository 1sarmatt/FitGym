import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email);

bool passwordsMatch(String pass1, String pass2) => pass1 == pass2;

void main() {
  group('Email validation', () {
    test('Valid email returns true', () {
      expect(isValidEmail('test@example.com'), true);
    });

    test('Invalid email returns false', () {
      expect(isValidEmail('invalid-email'), false);
      expect(isValidEmail('abc@'), false);
    });
  });

  group('Password confirmation', () {
    test('Matching passwords return true', () {
      expect(passwordsMatch('abc123', 'abc123'), true);
    });

    test('Mismatching passwords return false', () {
      expect(passwordsMatch('abc123', 'xyz456'), false);
    });
  });
}