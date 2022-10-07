import 'package:dartz/dartz.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import '../core/value_validators.dart';

class EmailAddress extends ValueObject<String>{
  @override
  final Either<ValueFailure<String>, String> value;

  const EmailAddress._(this.value);

  factory EmailAddress(String input) {
    return EmailAddress._(validateEmailAddress(input));
  }

  factory EmailAddress.empty() => EmailAddress('');
}