import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Pallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
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

              AuthGradientButton(buttonText: 'Sign In', onTap: () {}),
              const SizedBox(height: 20),

              RichText(
                text: TextSpan(
                  text: "Don't have an Account? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Sign Up.",
                      style: TextStyle(color: Pallete.gradient2, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
