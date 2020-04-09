import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/common/platform_exception_alert_dialog.dart';
import 'package:hotelcovid19_app/login/bloc/login_bloc.dart';
import 'package:flutter/services.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController..text = '',
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
    );
  }

  TextField _buildLoginTextField() {
    return TextField(
      controller: _loginController..text = '',
      decoration: InputDecoration(
        labelText: 'Login',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _loginController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: '${state.error}',
          ).show(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildLoginTextField(),
                SizedBox(height: 8.0),
                _buildPasswordTextField(),
                SizedBox(height: 8.0),
                RaisedButton(
                  onPressed:
                      state is! LoginLoading ? _onLoginButtonPressed : null,
                  child: Text('Acceder'),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
