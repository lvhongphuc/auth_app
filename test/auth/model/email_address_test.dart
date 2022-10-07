import 'package:auth_app/auth/core/exceptions.dart';
import 'package:auth_app/auth/model/email_address.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../constants.dart' as constants;

void main() {
  

  group('getOrCrash EmailAddress', () {
    final validEmail = EmailAddress(constants.wrongEmail);
    const validEmailString = constants.wrongEmail;

    final invalidEmail = EmailAddress('test');
    test(
      "should crash when execute with invalid email",
      () async {
        // act
        final call = invalidEmail.getOrCrash;
        // assert
        expect(call, throwsA(isA<UnexpectedException>()));
      }
    );
    test(
      "should return a string of valid email",
      () async {
        // act
        final result = validEmail.getOrCrash();
        // assert
        expect(result, validEmailString);
      }
    );
  });

}