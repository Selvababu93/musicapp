import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up.',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomField(hinttext: 'Name'),
            const SizedBox(height: 15),
            CustomField(hinttext: 'Email'),
            const SizedBox(height: 15),
            CustomField(hinttext: 'Password'),
            const SizedBox(height: 20),
            AuthGradientButton(),
            const SizedBox(height: 25),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                text: 'Already have an account? ',
                children: [TextSpan(text: 'Sign In')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
