import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // old auth func in testing and devloping phase
  // Future<void> _signUpUser() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   final response = await AuthRemoteRepository().signup(
  //     name: _nameController.text.trim(),
  //     email: _emailController.text.trim(),
  //     password: _passwordController.text.trim(),
  //   );

  //   if (!mounted) return;

  //   switch (response) {
  //     case Left(value: final failure):
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(failure.toString())),
  //       );
  //       break;

  //     case Right(value: final user):
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Signup successful')),
  //       );

  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (ctx) => const LoginPage()),
  //       );
  //       break;
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // showing loader when loading
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
    // to show the error message if there is an error
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackbar(context, 'Account created successfully!, Please Login');
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LoginPage()));
        },
        error: (error, st) {
          showSnackbar(context, error.toString());
        },
        loading: () {},
      );
    });
    // print(isLoading);
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: Loader())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sign Up.', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
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
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onTap: () async {
                        // before calling API checking input
                        if (_formKey.currentState!.validate()) {
                          // if input's email, password calling post
                          await ref
                              .read(authViewModelProvider.notifier)
                              .signUpUser(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginPage()));
                      },
                      child: const Text(
                        'Sign In',
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
