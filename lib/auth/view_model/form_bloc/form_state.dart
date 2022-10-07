part of 'form_bloc.dart';

@freezed
class FormState with _$FormState {
  const factory FormState({
    required EmailAddress emailAddress,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    Either<AuthFailure, Unit>? authFailureOrSuccess,
  }) = _FormState;

  factory FormState.initial() => FormState(
        emailAddress: EmailAddress.empty(),
        password: Password.empty(),
        showErrorMessages: false,
        isSubmitting: false,
      );
}
