import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpi_chat/providers/jwt_provider.dart';
import 'package:zpi_chat/providers/user_data_proider.dart';

import 'login.dart';
import 'main_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => JwtProvider()),
      ChangeNotifierProvider(create: (context) => UserDataProvider())
    ],
    child: MaterialApp(
      // theme: MainTheme(), //todo if enough time
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  ));
}
