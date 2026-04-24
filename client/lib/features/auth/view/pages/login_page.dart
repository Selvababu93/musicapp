import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/view/pages/upload_song_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // this is old func in testing phase
  // Future<void> _loginUser() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   final response = await AuthRemoteRepository().login(
  //     email: _emailController.text.trim(),
  //     password: _passwordController.text.trim(),
  //   );
  //   if (!mounted) return;
  //   switch (response) {
  //     case Left(value: final failure):
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
  //       break;

  //     case Right(value: final user):
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
  //       break;
  //   }
  // }

  @override
  Widget build(context) {
    // check is loading
    final isLoading = ref.watch(authViewModelProvider.select((val) => val?.isLoading == true));
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const UploadSongPage()),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackbar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Pallete.backgroundColor,
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sign In.', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    CustomField(hintText: 'Email', controller: _emailController),
                    const SizedBox(height: 15),
                    CustomField(
                      hintText: 'Password',
                      controller: _passwordController,
                      isObscureText: true,
                    ),
                    const SizedBox(height: 20),

                    AuthGradientButton(
                      buttonText: 'Sign In',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(authViewModelProvider.notifier)
                              .loginUser(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Don't have an Account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const SignupPage()));
                      },
                      child: const Text(
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
