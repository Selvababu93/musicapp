import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final response = await AuthRemoteRepository().signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print(response);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup successful')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // it will validate TextFormField
    _formKey.currentState!.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up.', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CustomField(hintText: 'Name', controller: _nameController),
              const SizedBox(height: 15),
              CustomField(hintText: 'Email', controller: _emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: _passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(buttonText: 'Sign Up', onTap: _signUpUser),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleMedium,
                  text: 'Already have an account? ',
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: Pallete.gradient2, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
