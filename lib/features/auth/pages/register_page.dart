import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:job_search_app/core/components/common_text_form_field.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';
import 'package:job_search_app/core/router/router.dart';
import 'package:job_search_app/features/auth/pages/login_page.dart';

import '../../../core/components/common_button.dart';

enum RegisterType { candidate, employer }

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  static const String route = 'register';

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final selectedRegisterType = useState<RegisterType>(RegisterType.candidate);

    return Scaffold(
      body: Center(
        child: ScaffoldWrapper(
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
                hintText: 'E-mail',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CommonTextFormField(
                hintText: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CommonButton(
                onPressed: () {},
                text: 'Register',
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                child: Text('Already have an account? Sign in'),
                onPressed: () {
                  context.pushNamed(LoginPage.route);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
