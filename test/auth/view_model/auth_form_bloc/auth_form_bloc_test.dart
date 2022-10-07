import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/model/email_address.dart';
import 'package:auth_app/auth/model/password.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:auth_app/auth/view_model/auth_form_bloc/auth_form_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_form_bloc_test.mocks.dart';
import '../../../constants.dart' as constants;

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository _repository;
  late AuthFormBloc _authFormBloc;

  setUp(() {
    _repository = MockAuthRepository();
    _authFormBloc = AuthFormBloc(_repository);
  });

  blocTest("should emit expected state when event emailChanged added",
      build: () => _authFormBloc,
      setUp: () {
        _authFormBloc.emit(AuthFormState.initial());
      },
      act: (AuthFormBloc bloc) =>
          bloc.add(const AuthFormEvent.emailChanged(constants.rightEmail)),
      expect: () {
        final expected = [
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            authFailureOrSuccess: null,
          )
        ];
        return expected;
      });

  blocTest("should emit expected state when event passwordChanged added",
      build: () => _authFormBloc,
      setUp: () {
        _authFormBloc.emit(AuthFormState.initial());
      },
      act: (AuthFormBloc bloc) =>
          bloc.add(const AuthFormEvent.passwordChanged(constants.rightEmail)),
      expect: () {
        final expected = [
          _authFormBloc.state.copyWith(
            password: Password(constants.rightEmail),
            authFailureOrSuccess: null,
          )
        ];
        return expected;
      });

  blocTest(
      '''should emit expected state when event emailChanged, passwordChanged,
     signInPressed added with invalid email, password''',
      build: () => _authFormBloc,
      setUp: () {
        _authFormBloc.emit(AuthFormState.initial());
      },
      act: (AuthFormBloc bloc) {
        bloc.add(const AuthFormEvent.emailChanged(constants.invalidEmail));
        bloc.add(const AuthFormEvent.passwordChanged(constants.invalidPassword));
        bloc.add(const AuthFormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.invalidEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.invalidEmail),
            password: Password(constants.invalidPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccess: null,
          )
        ];
        return expected;
      });

  blocTest(
      '''should emit expected state when event emailChanged, passwordChanged,
     signInPressed added with wrong email, password''',
      build: () => _authFormBloc,
      setUp: () {
        when(_repository.signIn(any, any)).thenAnswer((_) async =>
            const Left(AuthFailure.invalidEmailAndPasswordCombination()));
        _authFormBloc.emit(AuthFormState.initial());
      },
      act: (AuthFormBloc bloc) {
        bloc.add(const AuthFormEvent.emailChanged(constants.wrongEmail));
        bloc.add(const AuthFormEvent.passwordChanged(constants.wrongPassword));
        bloc.add(const AuthFormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.wrongEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.wrongEmail),
            password: Password(constants.wrongPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccess: null,
          ),
          _authFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccess:
                left(const AuthFailure.invalidEmailAndPasswordCombination()),
          )
        ];
        return expected;
      });

  blocTest(
      '''should emit expected state when event emailChanged, passwordChanged,
     signInPressed added with right email, password''',
      build: () => _authFormBloc,
      setUp: () {
        when(_repository.signIn(any, any)).thenAnswer((_) async =>
            const Right(unit));
        _authFormBloc.emit(AuthFormState.initial());
      },
      act: (AuthFormBloc bloc) {
        bloc.add(const AuthFormEvent.emailChanged(constants.rightEmail));
        bloc.add(const AuthFormEvent.passwordChanged(constants.rightPassword));
        bloc.add(const AuthFormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            password: Password(constants.rightPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _authFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccess: null,
          ),
          _authFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccess: right(unit),
          )
        ];
        return expected;
      });
}
