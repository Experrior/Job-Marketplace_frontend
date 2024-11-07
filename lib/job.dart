// job_item.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'job_detail.dart'; // Import the JobApplicationPage

// Data model for a Job item
class Job {
  final String logoUrl;
  final String title;
  final String description;
  final List<String> tags;
  final double salary;
  final String location;
  final String company;

  Job({
    required this.logoUrl,
    required this.title,
    required this.description,
    required this.tags,
    required this.salary,
    required this.location,
    required this.company,
  });
}

// Widget for each job item in the list
class JobItem extends StatelessWidget {
  final Job job;
  const JobItem({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the JobApplicationPage, passing the job details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobApplicationPage(
              jobTitle: job.title,
              companyName: job.company,
              location: job.location,
              jobDescription: job.description,
              imageUrl: job.logoUrl,
              applicantsCount: 124, // Example count; replace with actual data if available
              salary: '\$${job.salary.toStringAsFixed(2)}',
              benefits: ["Health Insurance", "401(k)", "Paid Time Off", "Remote Work Options"], // Example benefits
              employmentType: "Full-time", // Example employment type
              experienceLevel: "Mid-level", // Example experience level
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Logo image
              Image.asset(
                'assets/job_logos/logo'+(1+Random().nextInt(5)).toString()+'.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 12),

              // Center: Job title, description, tags, salary
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      job.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: job.tags
                          .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(color: Colors.blue),
                      ))
                          .toList(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${job.salary.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14, color: Colors.green[700]),
                    ),
                  ],
                ),
              ),

              // Right side: Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  Text(
                    job.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
