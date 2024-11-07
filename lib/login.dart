import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpi_chat/recruiter_pages/home.dart';
import 'package:zpi_chat/providers/user_data_proider.dart';
import 'package:zpi_chat/register.dart';
import 'package:zpi_chat/services/authentication_service.dart';
import 'package:http/http.dart' as http;

import 'applicant_pages/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {

  final AuthenticationService authenticationService = AuthenticationService();

  bool isJobSeeker = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  // Image carousel variables
  final List<String> images = [
    'assets/images/front1.png',
    'assets/images/front2.png',
    'assets/images/front3.png',
  ];
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set up a timer to change the image every few seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userDataProvider = Provider.of<UserDataProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          // Left Half: Image Carousel
          Expanded(
            child: Container(
              color: Colors.black,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Image.asset(
                  images[_currentIndex],
                  key: ValueKey<int>(_currentIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),

          // Right Half: Login Form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),

                  // Custom Toggle between Job Seeker and Recruiter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleOption("Job Seeker", isJobSeeker),
                      SizedBox(width: 20),
                      _buildToggleOption("Recruiter", !isJobSeeker),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 8),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 16),

                  // Login Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isJobSeeker) {
                          userDataProvider.store('role', "APPLICANT");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ApplicantHomePage()),
                          );
                        }else{
                          userDataProvider.store('role', "RECRUITER");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecruiterHomePage()),
                          );
                        }


                        // var response = await http.post(test, body: json.encode({'email': emailController.text, 'color': 'blue'}));

                        // bool result = await authenticationService.login("259905@student.pwr.edu.pl", "securePassword123");
                        // print(result);
                        // var response = await dio.post('http://34.136.165.221:8080/user-service/login',
                        //     data: {'email': , 'password': },
                            // options: Options(headers: {
                            // HttpHeaders.contentTypeHeader: "application/json",
                            // })
                        // );
                        // print('Response status: ${result.statusCode}');
                        // print('Response body: ${result.data}');

                        // print(response);
                        // if (result){

                        // }else {
                        //   emailController.clear();
                        //   passwordController.clear();
                        // }
                      },
                      child: Text('Login'),
                    ),
                  ),

                  // Additional Options: Forgot Password and Signup Link
                  SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to forgot password page
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                      },
                      child: Text(
                        "Don't have an account? Register",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom toggle button for Job Seeker / Recruiter
  Widget _buildToggleOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isJobSeeker = (title == "Job Seeker");
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
