import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});
  static const String route = 'register';


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Register Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
