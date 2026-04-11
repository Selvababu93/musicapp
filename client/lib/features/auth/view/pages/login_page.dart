import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await AuthRemoteRepository().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (!mounted) return;
    switch (response) {
      case Left(value: final failure):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
        break;

      case Right(value: final user):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
        break;
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Pallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign In.', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CustomField(hintText: 'Email', controller: _emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: _passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),

              AuthGradientButton(buttonText: 'Sign In', onTap: _loginUser),
              const SizedBox(height: 20),

              Text(
                "Don't have an Account? ",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => SignupPage()));
                },
                child: Text(
                  "Sign Up.",
                  style: TextStyle(color: Pallete.gradient2, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
