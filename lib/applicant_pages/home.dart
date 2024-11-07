import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpi_chat/applicant_pages/settings.dart';
import 'package:zpi_chat/widgets/chat.dart';
import '../recruiter_pages/settings.dart'; // Import the settings page
import '../job.dart';
import 'analytics.dart';




class ApplicantHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ApplicantHomePage> {
  List<Job> jobs = [
    Job(
      logoUrl: 'assets/job_logos/logo1.png',
      title: 'Software Engineer',
      description: 'Develop and maintain software applications.',
      tags: ['Remote'],
      salary: 95000,
      location: 'New York, NY',
      company: 'Tech Corp',
    ),
    Job(
      logoUrl: 'assets/job_logos/logo2.png',
      title: 'Product Manager',
      description: 'Lead product development and strategy.',
      tags: ['Full-time', 'Onsite'],
      salary: 110000,
      location: 'San Francisco, CA',
      company: 'InnovateX',
    ),
    Job(
      logoUrl: 'assets/job_logos/logo3.png',
      title: 'Product Manager',
      description: 'Lead product development and strategy.',
      tags: ['Full-time', 'Onsite'],
      salary: 110000,
      location: 'San Francisco, CA',
      company: 'InnovateX',
    ),
    Job(
      logoUrl: 'assets/job_logos/logo4.png',
      title: 'Content Writer',
      description: 'Craft engaging and informative content for marketing materials, websites, and social media.',
      tags: [ 'Remote'],
      salary: 65000,
      location: 'Remote (Flexible)',
      company: 'Wordsmith & Co.',
    ),
    Job(
      logoUrl: 'https://via.placeholder.com/50',
      title: 'Marketing Manager',
      description: 'Develop and execute marketing strategies to drive brand awareness and lead generation.',
      tags: ['Full-time', 'Remote'],
      salary: 85000,
      location: 'Remote (EU-based)',
      company: 'GrowGlobal',
    ),
    Job(
      logoUrl: 'https://via.placeholder.com/50',
      title: 'Data Scientist',
      description: 'Analyze large datasets to extract meaningful insights and build predictive models.',
      tags: ['Full-time', 'Hybrid (Office/Remote)'],
      salary: 150000,
      location: 'New York, NY',
      company: 'Insights Labs',
    ),
    Job(
      logoUrl: 'https://via.placeholder.com/50',
      title: 'Front-End Developer',
      description: 'Build and maintain the user interface of web applications using cutting-edge technologies.',
      tags: ['Hybrid (Office/Remote)'],
      salary: 95000,
      location: 'Austin, TX',
      company: 'TechFrontiers',
    ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Software Engineer',
  description: 'Develop and maintain high-performance, scalable software applications.',
  tags: ['Full-time', 'Remote'],
  salary: 130000,
  location: 'Remote (US-based)',
  company: 'CodeCraft',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Data Scientist',
  description: 'Analyze large datasets to extract meaningful insights and build predictive models.',
  tags: ['Hybrid (Office/Remote)'],
  salary: 150000,
  location: 'New York, NY',
  company: 'Insights Labs',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'UX/UI Designer',
  description: 'Design intuitive and user-friendly interfaces for web and mobile applications.',
  tags: ['Full-time', 'Onsite'],
  salary: 100000,
  location: 'Seattle, WA',
  company: 'Designify',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Marketing Manager',
  description: 'Develop and execute marketing strategies to drive brand awareness and lead generation.',
  tags: ['Full-time', 'Remote'],
  salary: 85000,
  location: 'Remote (EU-based)',
  company: 'GrowGlobal',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Front-End Developer',
  description: 'Build and maintain the user interface of web applications using cutting-edge technologies.',
  tags: ['Full-time', 'Hybrid (Office/Remote)'],
  salary: 95000,
  location: 'Austin, TX',
  company: 'TechFrontiers',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Content Writer',
  description: 'Craft engaging and informative content for marketing materials, websites, and social media.',
  tags: ['Full-time', 'Remote'],
  salary: 65000,
  location: 'Remote (Flexible)',
  company: 'Wordsmith & Co.',
  ),
  Job(
  logoUrl: 'https://via.placeholder.com/50',
  title: 'Sales Representative',
  description: 'Build relationships with potential clients and generate leads to drive sales growth.',
  tags: ['Full-time', 'Onsite'],
  salary: 75000 ,
  location: 'Los Angeles, CA',
  company: 'SkyRocket Sales',
  )

    // Add more job items as needed
  ];

  List<Job> filteredJobs = [];
  String searchQuery = "";
  String? selectedCompany;
  double minSalary = 0;
  double maxSalary = 200000;
  List<String> includeTags = [];
  List<String> excludeTags = [];
  bool isExpanded =false;

  @override
  void initState() {
    super.initState();
    filteredJobs = jobs;
  }

  // Method to filter jobs based on search query, company, tags, and salary range
  void filterJobs() {
    setState(() {
      filteredJobs = jobs.where((job) {
        final matchesQuery = job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            job.description.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCompany = selectedCompany == null || job.company.toLowerCase() == selectedCompany!.toLowerCase();
        final matchesIncludeTags = includeTags.isEmpty || includeTags.every((tag) => job.tags.contains(tag));
        final matchesExcludeTags = excludeTags.isEmpty || excludeTags.every((tag) => !job.tags.contains(tag));
        final matchesSalary = job.salary >= minSalary && job.salary <= maxSalary;
        return matchesQuery && matchesCompany && matchesIncludeTags && matchesExcludeTags && matchesSalary;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: () {
            //     // Navigate to Main Page
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => HomePage()),
            //     );
            //   },
            //   child:
              Text("Job Market"),
            // ),
            Container(width: 20,),
            GestureDetector(
              onTap: () {
                // Navigate to Analytics Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicantAnalyticsPage()),
                );
              },
              child: Text("Analytics"),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Navigate to settings page on user icon click
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicantSettingsPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        centerTitle: false,
      ),
      body: Row(
        children: [
          // Left section: Search bar and job list
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      filterJobs();
                    },
                  ),
                ),

                // List of job items
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return JobItem(job: job);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right section: Filter panel
          Container(
            width: 250,
            padding: EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Company Filter
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCompany = value;
                    });
                    filterJobs();
                  },
                ),
                SizedBox(height: 16),

                // Include Tags Filter
                Text(
                  "Include Tags",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 6,
                  children: ['Full-time', 'Remote', 'Onsite'].map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: includeTags.contains(tag),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            includeTags.add(tag);
                          } else {
                            includeTags.remove(tag);
                          }
                        });
                        filterJobs();
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Exclude Tags Filter
                Text(
                  "Exclude Tags",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 6,
                  children: ['Full-time', 'Remote', 'Onsite'].map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: excludeTags.contains(tag),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            excludeTags.add(tag);
                          } else {
                            excludeTags.remove(tag);
                          }
                        });
                        filterJobs();
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Salary Range Filter
                Text(
                  "Salary Range",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Min',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            minSalary = double.tryParse(value) ?? 0;
                          });
                          filterJobs();
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Max',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            maxSalary = double.tryParse(value) ?? 200000;
                          });
                          filterJobs();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isExpanded
        // When expanded, show a rectangular widget with a text input and chat list
            ?
        Container(
            key: ValueKey<bool>(isExpanded),
            padding: EdgeInsets.all(10),
            width: 300,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ChatScreen()
        )
        // When collapsed, show the chat button
            : FloatingActionButton(
          key: ValueKey<bool>(isExpanded),
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.chat),
        ),
      ),
    );
  }
}
