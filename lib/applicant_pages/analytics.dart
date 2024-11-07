// analytics_page_with_app_bar.dart
import 'package:flutter/material.dart';
import 'package:zpi_chat/applicant_pages/settings.dart';
import 'analytics.dart';
import 'home.dart';

class ApplicantAnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to Main Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicantHomePage()),
                );
              },
              child: Text("Job Market"),
            ),
            Container(width: 20,),
            GestureDetector(
              onTap: () {
                // Stay on the current Analytics page, or refresh if needed
              },
              child: Text("Salaries"),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline),
              onPressed: () {
                // Chat icon action
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicantSettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text('Analytics'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // First Image
            Image.asset(
              'assets/images/analytics.png',
            ),

            SizedBox(height: 24), // Space between images

            // Second Image
            Image.asset(
              'assets/images/analytics2.png',
            ),

            // Additional padding at the bottom, if needed
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
