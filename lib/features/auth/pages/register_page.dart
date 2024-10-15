import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:job_search_app/core/components/common_text_form_field.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';
import 'package:job_search_app/core/router/router.dart';
import 'package:job_search_app/features/auth/pages/forgot_password_page.dart';
import 'package:job_search_app/features/auth/pages/login_page.dart';

import '../../../core/components/common_button.dart';

enum RegisterType { candidate, employer }

class RegisterPage extends HookWidget {
  RegisterPage({super.key});

  static const String route = 'register';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final selectedRegisterType = useState<RegisterType>(RegisterType.candidate);

    return Scaffold(
      body: Center(
        child: ScaffoldWrapper(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CupertinoSegmentedControl(
                  children: const {
                    RegisterType.candidate: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Candidate'),
                    ),
                    RegisterType.employer: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Employer'),
                    ),
                  },
                  onValueChanged: (value) {
                    selectedRegisterType.value = value as RegisterType;
                  },
                  groupValue: selectedRegisterType.value,
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'First name',
                  controller: firstNameController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'Last name',
                  controller: lastNameController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'E-mail',
                  controller: emailController,
                  validator: (value) {
                    if (EmailValidator.validate(value!) == false) {
                      return 'Correct E-mail is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonTextFormField(
                  hintText: 'Repeat password',
                  controller: repeatPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                  },
                  text: 'Register',
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: const Text('Already have an account? Sign in'),
                  onPressed: () {
                    context.pushNamed(LoginPage.route);
                  },
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: const Text('Forgot password?'),
                  onPressed: () {
                    context.pushNamed(ForgotPasswordPage.route);
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
