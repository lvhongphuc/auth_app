import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/model/email_address.dart';
import 'package:auth_app/auth/model/password.dart';
import 'package:auth_app/auth/repository/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../constants.dart' as constants;
void main() {
  late AuthRepositoryImpl _repository;

  group('signIn', () {
    final email = EmailAddress(constants.rightEmail);
    final wrongEmail = EmailAddress(constants.wrongEmail);
    final password = Password(constants.rightPassword);
    final wrongPassword = Password(constants.wrongPassword);

    setUp(() {
      _repository = AuthRepositoryImpl();
    });
    

    test(
      "should return left(AuthFailure) when execute with wrong password",
      () async {
        // act
        final result = await _repository.signIn(email, wrongPassword);
        // assert
        expect(result, left(const AuthFailure.invalidEmailAndPasswordCombination()));
      }
    );

    test(
      "should return right(unit) when execute successfully",
      () async {
        // act
        final result = await _repository.signIn(email, password);
        // assert
        expect(result, right(unit));
      }
    );
  });
}