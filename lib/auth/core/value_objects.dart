import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'errors.dart';

import 'failures.dart';

abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedError] containing the [ValueFailure]
  T getOrCrash() {
    // return value.fold((l) => throw UnexpectedError(l), (r) => r);
    return value.fold((l) => throw UnexpectedException(l), id);
  }

  // Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
  //   return value.fold(
  //     (l) => left(l),
  //     (r) => right(unit),
  //   );
  // }
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

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const UniqueId._(this.value);

  factory UniqueId() {
    return UniqueId._(right(const Uuid().v1()));
  }
  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(right(uniqueId));
  }
}
