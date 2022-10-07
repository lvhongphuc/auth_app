import 'package:auth_app/auth/core/exceptions.dart';
import 'package:auth_app/auth/model/password.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../constants.dart' as constants;

void main() {
  

  group('getOrCrash Password', () {
    final validPassword = Password(constants.wrongPassword);
    const validPasswordString = constants.wrongPassword;

    final invalidPassword = Password(constants.invalidPassword);
    test(
      "should crash when execute with invalid password",
      () async {
        // act
        final call = invalidPassword.getOrCrash;
        // assert
        expect(call, throwsA(isA<UnexpectedException>()));
      }
    );
    test(
      "should return a string of valid password",
      () async {
        // act
        final result = validPassword.getOrCrash();
        // assert
        expect(result, validPasswordString);
      }
    );
  });

}