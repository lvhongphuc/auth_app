import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../model/email_address.dart';
import '../../model/password.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';
part 'auth_form_bloc.freezed.dart';

@injectable
class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  final AuthRepository _repository;
  AuthFormBloc(this._repository) : super(AuthFormState.initial()) {
    on<AuthFormEvent>(_onAuthFormEvent);
  }

  Future<void> _onAuthFormEvent(AuthFormEvent event, Emitter<AuthFormState> emit) {
    return event.map(
      emailChanged: (e) async {
        emit(state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccess: null,
        ));
      },
      passwordChanged: (e) async {
        emit(state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccess: null,
        ));
      },
      signInPressed: (e) async {
        Either<AuthFailure, Unit>? failureOrSuccess;

        final isEmailValid = state.emailAddress.isValid();
        final isPasswordValid = state.password.isValid();

        if (isEmailValid && isPasswordValid) {
          emit(state.copyWith(
            isSubmitting: true,
            authFailureOrSuccess: null,
          ));

          failureOrSuccess = await _repository.signIn(
            state.emailAddress,
            state.password,
          );
        }
        emit(state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccess: failureOrSuccess,
        ));
      },
    );
  }
}
