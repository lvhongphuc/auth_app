import 'package:auth_app/auth/model/password.dart';
import 'package:auth_app/auth/model/email_address.dart';
import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:auth_app/auth/repository/auth_validator.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<AuthFailure, Unit>> signIn(
    EmailAddress email,
    Password password,
  ) async {
    final validAuth = await validateAuth(
      email.getOrCrash(),
      password.getOrCrash(),
    );

    return validAuth
        ? right(unit)
        : left(const AuthFailure.invalidEmailAndPasswordCombination());
  }
}
