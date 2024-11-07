// job_application_page.dart
import 'package:flutter/material.dart';

class JobApplicationPage extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String jobDescription;
  final String imageUrl;
  final int applicantsCount;
  final String salary;
  final List<String> benefits;
  final String employmentType;
  final String experienceLevel;

  JobApplicationPage({
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobDescription,
    required this.imageUrl,
    required this.applicantsCount,
    required this.salary,
    required this.benefits,
    required this.employmentType,
    required this.experienceLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Job Title and Company
              Text(
                jobTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "$companyName • $location",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),

              // Job Details
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Employment Type and Experience Level
                      Row(
                        children: [
                          Icon(Icons.work_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            "Employment Type: $employmentType",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.school_outlined, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            "Experience Level: $experienceLevel",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Salary Information
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            "Salary: $salary",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Job Description
              Text(
                "Job Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                jobDescription,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),

              // Additional Information (e.g., Applicants)
              Row(
                children: [
                  Icon(Icons.people_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "$applicantsCount people have applied",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Benefits Section
              Text(
                "Benefits",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: benefits
                    .map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        benefit,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
              SizedBox(height: 32),

              // Apply Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement application logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Apply Now',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
