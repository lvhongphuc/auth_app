import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/auth_form_bloc/auth_form_bloc.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthFormBloc, AuthFormState>(
      listenWhen: (previous, current) =>
          previous.authFailureOrSuccess != current.authFailureOrSuccess,
      listener: (context, state) {
        if (state.authFailureOrSuccess == null) {
          return;
        }
        state.authFailureOrSuccess!.isLeft()
            ? _showDialog(context, 'Sign in failed')
            : _showDialog(context, 'Sign in successful');
      },
      buildWhen: ((previous, current) =>
          previous.showErrorMessages != current.showErrorMessages ||
          previous.isSubmitting != current.isSubmitting),
      builder: (context, state) {
        return Center(
          child: Form(
            autovalidateMode: state.showErrorMessages
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (val) => context
                        .read<AuthFormBloc>()
                        .add(AuthFormEvent.emailChanged(val.trim())),
                    validator: (_) => context
                        .read<AuthFormBloc>()
                        .state
                        .emailAddress
                        .value
                        .fold(
                          (l) => l.maybeMap(
                            orElse: () => null,
                            invalidEmail: (_) => 'Invalid email',
                          ),
                          (r) => null,
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (val) => context
                        .read<AuthFormBloc>()
                        .add(AuthFormEvent.passwordChanged(val.trim())),
                    validator: (_) =>
                        context.read<AuthFormBloc>().state.password.value.fold(
                              (l) => l.maybeMap(
                                orElse: () => null,
                                shortPassword: (_) => 'Invalid Password',
                              ),
                              (r) => null,
                            ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AuthFormBloc>()
                          .add(const AuthFormEvent.signInPressed());
                    },
                    child: const Text('Sign in'),
                  ),
                  if (state.isSubmitting) ...[
                    const SizedBox(
                      height: 50,
                    ),
                    const LinearProgressIndicator(
                      color: Colors.indigo,
                      value: null,
                    )
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Authentication'),
        content: Text(content),
      );
    },
  );
}
