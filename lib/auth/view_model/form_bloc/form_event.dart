part of 'form_bloc.dart';

@freezed
class FormEvent with _$FormEvent {
  const factory FormEvent.emailChanged(String emailStr) = _EmailChanged;
  const factory FormEvent.passwordChanged(String passwordStr) = _PasswordChanged;
  const factory FormEvent.signInPressed() = _SignInPressed;
}