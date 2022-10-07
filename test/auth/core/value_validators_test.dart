import 'package:auth_app/auth/core/failures.dart';
import 'package:auth_app/auth/core/value_validators.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../constants.dart' as constants;
void main() {
  
  group('validateEmailAddress', () {
    const validEmail = constants.wrongEmail;
    const invalidEmail = constants.invalidEmail;
    test(
        "should return left(ValueFailure) when execute with invalid email",
        () async { 
          // act
          final result = validateEmailAddress(invalidEmail);
          // assert
          expect(result, left(const ValueFailure.invalidEmail(failedValue: invalidEmail)));
        }
      );

    test(
        "should return right(email) when execute with valid email",
        () async { 
          // act
          final result = validateEmailAddress(validEmail);
          // assert
          expect(result, right(validEmail));
        }
      );
  });
  
  group('validatePassword', () {
    const validPassword = constants.wrongPassword;
    const invalidPassword = constants.invalidPassword;
    test(
        "should return left(ValueFailure) when execute with invalid password",
        () async { 
          // act
          final result = validatePassword(invalidPassword);
          // assert
          expect(result, left(const ValueFailure.shortPassword(failedValue: invalidPassword)));
        }
      );

    test(
        "should return right(password) when execute with valid password",
        () async { 
          // act
          final result = validatePassword(validPassword);
          // assert
          expect(result, right(validPassword));
        }
      );
  });
}