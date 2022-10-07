import 'package:auth_app/auth/view/widgets/auth_form.dart';
import 'package:auth_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/auth_form_bloc/auth_form_bloc.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: BlocProvider(
        create: (context) => getIt<AuthFormBloc>(),
        child: const AuthForm(),
      ),
    );
  }
}


