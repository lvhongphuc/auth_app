import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/email_address.dart';
import '../../model/password.dart';

part 'form_event.dart';
part 'form_state.dart';
part 'form_bloc.freezed.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final AuthRepository _repository;
  FormBloc(this._repository) : super(FormState.initial()) {
    on<FormEvent>(_onFormEvent);
  }

  Future<void> _onFormEvent(FormEvent event, Emitter<FormState> emit) {
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

          failureOrSuccess = await _repository.signInWithEmailAndPassword(
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
