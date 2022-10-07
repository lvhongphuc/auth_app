import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  // Unfold the value of ValueObject
  // We only use this function when the value's valid
  // otherwise the app will be crashed
  T getOrCrash() {
    return value.fold((l) => throw UnexpectedException(l), id);
  }

  ValueFailure<dynamic>? get failure {
    return value.fold(
      (l) => l,
      (r) => null,
    );
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value(value: $value)';
}