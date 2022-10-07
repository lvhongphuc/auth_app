import 'package:auth_app/auth/core/failures.dart';
import 'package:dartz/dartz.dart';

import '../core/value_objects.dart';
import '../core/value_validators.dart';

class Password extends ValueObject<String>{
  @override
  final Either<ValueFailure<String>, String> value;

  const Password._(this.value);

  factory Password(String input) {
    return Password._(validatePassword(input));
  }

  factory Password.empty() => Password('');
}