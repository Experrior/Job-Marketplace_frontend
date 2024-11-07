import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zpi_chat/services/authentication_service.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Track whether the user is a job seeker or recruiter
  bool isApplicant = true;
  final AuthenticationService authenticationService = AuthenticationService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  // Sample list of suggested companies for recruiters
  final List<String> companySuggestions = [
    "Google",
    "Microsoft",
    "Apple",
    "Amazon",
    "Custom"
  ];

  String selectedCompany = "Custom";
  bool isCustomCompany = false;

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
    // Set up a timer to change the image every 10 minutes
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
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

          // Right Half: Registration Form
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
                      _buildToggleOption("Applicant", isApplicant),
                      const SizedBox(width: 20),
                      _buildToggleOption("Recruiter", !isApplicant),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 8),

                  // Name Field
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 8),

                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 8),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 8),

                  // Confirm Password Field
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                  SizedBox(height: 16),

                  // Additional Fields for Recruiters
                  if (!isApplicant)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        // Dropdown for company selection
                        DropdownButton<String>(
                          value: selectedCompany,
                          items: companySuggestions.map((company) {
                            return DropdownMenuItem<String>(
                              value: company,
                              child: Text(company),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCompany = value!;
                              isCustomCompany = value == "Custom";
                              companyController.clear(); // Reset custom company field
                            });
                          },
                        ),
                        if (isCustomCompany)
                          TextField(
                            controller: companyController,
                            decoration: InputDecoration(labelText: 'Enter Company Name'),
                          ),
                      ],
                    ),

                  SizedBox(height: 24),

                  // Register Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isApplicant) {
                          // Object result = await authenticationService.register(
                          //     emailController.text,
                          //     firstNameController.text,
                          //     lastNameController.text,
                          //     passwordController.text,
                          //     confirmPasswordController.text
                          // );
                          // print(result);
                        }else{
                          // Object result = await authenticationService.registerRecruiter(
                          //     emailController.text,
                          //     firstNameController.text,
                          //     lastNameController.text,
                          //     passwordController.text,
                          //     confirmPasswordController.text,
                          //     companyController.text
                          // );
                          // print(result);
                        }

                      },
                      child: Text('Register'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Already have an account? Log in",
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

  // Custom toggle button for Applicant / Recruiter
  Widget _buildToggleOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isApplicant = (title == "Applicant");
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
