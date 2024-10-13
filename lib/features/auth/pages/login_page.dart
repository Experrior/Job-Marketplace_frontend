import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:job_search_app/core/components/common_button.dart';
import 'package:job_search_app/core/components/common_text_form_field.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = 'login';

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ScaffoldWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextFormField(
                  hintText: 'Email', controller: emailController),
              const SizedBox(height: 16),
              CommonTextFormField(
                  hintText: 'Password', controller: emailController),
              const SizedBox(height: 16),
              CommonButton(text: 'Login', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
