import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:job_search_app/core/components/common_button.dart';
import 'package:job_search_app/core/components/common_text_form_field.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/login_controller.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});

  static const String route = 'login';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ScaffoldWrapper(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loginState.when(
                  data: (data) => data.toString(),
                  loading: () => 'Loading...',
                  error: (error, _) => error.toString(),
                )),
                CommonTextFormField(
                  hintText: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (EmailValidator.validate(value!) == false) {
                      return 'Provide correct email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'Password',
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonButton(
                    text: 'Login',
                    onPressed: () async{
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await ref.read(loginControllerProvider.notifier).login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
