import 'package:auth_app/auth/model/auth_failure.dart';
import 'package:auth_app/auth/model/email_address.dart';
import 'package:auth_app/auth/model/password.dart';
import 'package:auth_app/auth/repository/auth_repository.dart';
import 'package:auth_app/auth/view_model/form_bloc/form_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'form_bloc_test.mocks.dart';
import '../../../constants.dart' as constants;

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository _repository;
  late FormBloc _formBloc;

  setUp(() {
    _repository = MockAuthRepository();
    _formBloc = FormBloc(_repository);
  });

  blocTest("should emit expected state when event emailChanged added",
      build: () => _formBloc,
      setUp: () {
        _formBloc.emit(FormState.initial());
      },
      act: (FormBloc bloc) =>
          bloc.add(const FormEvent.emailChanged(constants.rightEmail)),
      expect: () {
        final expected = [
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            authFailureOrSuccess: null,
          )
        ];
        return expected;
      });

  blocTest("should emit expected state when event passwordChanged added",
      build: () => _formBloc,
      setUp: () {
        _formBloc.emit(FormState.initial());
      },
      act: (FormBloc bloc) =>
          bloc.add(const FormEvent.passwordChanged(constants.rightEmail)),
      expect: () {
        final expected = [
          _formBloc.state.copyWith(
            password: Password(constants.rightEmail),
            authFailureOrSuccess: null,
          )
        ];
        return expected;
      });

  blocTest(
      '''should emit expected state when event emailChanged, passwordChanged,
     signInPressed added with invalid email, password''',
      build: () => _formBloc,
      setUp: () {
        _formBloc.emit(FormState.initial());
      },
      act: (FormBloc bloc) {
        bloc.add(const FormEvent.emailChanged(constants.invalidEmail));
        bloc.add(const FormEvent.passwordChanged(constants.invalidPassword));
        bloc.add(const FormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.invalidEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.invalidEmail),
            password: Password(constants.invalidPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
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
      build: () => _formBloc,
      setUp: () {
        when(_repository.signIn(any, any)).thenAnswer((_) async =>
            const Left(AuthFailure.invalidEmailAndPasswordCombination()));
        _formBloc.emit(FormState.initial());
      },
      act: (FormBloc bloc) {
        bloc.add(const FormEvent.emailChanged(constants.wrongEmail));
        bloc.add(const FormEvent.passwordChanged(constants.wrongPassword));
        bloc.add(const FormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.wrongEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.wrongEmail),
            password: Password(constants.wrongPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccess: null,
          ),
          _formBloc.state.copyWith(
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
      build: () => _formBloc,
      setUp: () {
        when(_repository.signIn(any, any)).thenAnswer((_) async =>
            const Right(unit));
        _formBloc.emit(FormState.initial());
      },
      act: (FormBloc bloc) {
        bloc.add(const FormEvent.emailChanged(constants.rightEmail));
        bloc.add(const FormEvent.passwordChanged(constants.rightPassword));
        bloc.add(const FormEvent.signInPressed());
      },
      expect: () {
        final expected = [
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            password: Password(''),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
            emailAddress: EmailAddress(constants.rightEmail),
            password: Password(constants.rightPassword),
            authFailureOrSuccess: null,
            showErrorMessages: false,
          ),
          _formBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccess: null,
          ),
          _formBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccess: right(unit),
          )
        ];
        return expected;
      });
}
