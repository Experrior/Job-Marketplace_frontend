import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:job_search_app/core/components/common_button.dart';
import 'package:job_search_app/core/components/common_text_form_field.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';

class ForgotPasswordPage extends HookWidget {
   ForgotPasswordPage({Key? key}) : super(key: key);

  static const String route = 'forgot_password';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: ScaffoldWrapper(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                CommonButton(
                  text: 'Reset password',
                  onPressed: () {
                    if(!formKey.currentState!.validate()) {
                      return;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
