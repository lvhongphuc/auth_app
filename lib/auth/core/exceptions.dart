import 'package:auth_app/auth/core/failures.dart';

class UnexpectedException implements Exception {
  final ValueFailure valueFailure;

  UnexpectedException(this.valueFailure);
  @override
  String toString() {
    return 'Encountered Unexpected Exception. Failure was: $valueFailure';
        
  }
}