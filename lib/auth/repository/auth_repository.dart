import 'package:dartz/dartz.dart';

import '../model/auth_failure.dart';
import '../model/email_address.dart';
import '../model/password.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, Unit>> signIn(
    EmailAddress email,
    Password password,
  );
}