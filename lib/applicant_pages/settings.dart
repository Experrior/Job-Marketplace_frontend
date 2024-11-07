import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zpi_chat/widgets/chat.dart';
import '../job.dart';
import '../login.dart';
import 'analytics.dart';
import 'home.dart';


void main() {
  runApp(ApplicantSettingsPage());
}

class ApplicantSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ApplicantSettingsScreen(),
      ),
    );
  }
}

class ApplicantSettingsScreen extends StatefulWidget {
  @override
  _ApplicantSettingsScreenState createState() => _ApplicantSettingsScreenState();
}

class _ApplicantSettingsScreenState extends State<ApplicantSettingsScreen> {
  int _selectedIndex = 0;
  bool isExpanded =false;
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  final List<String> menuOptions = [
    'Personal Data',
    'Your Applications',
    'Saved Offers',
    'Account Settings'
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Personal Data Example
  Widget _buildPersonalData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(
            'assets/avatar.png'
          ),
        ),
        SizedBox(height: 16),
        Text("Name: John Doe", style: TextStyle(fontSize: 16)),
        Text("Email: john.doe@example.com", style: TextStyle(fontSize: 16)),
        Text("Address: 123 Main St, Springfield", style: TextStyle(fontSize: 16)),
        Text("Phone: +1 123-456-7890", style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // JobItem for Applications and Saved Offers
  Widget _buildJobItem(String title, String company, String location, double salary, String desc) {
    return JobItem(job:  Job(
      logoUrl: 'https://via.placeholder.com/50',
      title: title,
      description: desc,
      tags: ['Full-time', 'Onsite'],
      salary:  salary,
      location: location,
      company: company,
    ));
  }

  // List of Applications or Saved Offers
  Widget _buildApplicationsList() {
    return Column(
      children: [
        _buildJobItem("Software Engineer", "Tech Corp", "San Francisco", 12300, "Develop and maintain web applications, working with both front-end and back-end technologies, collaborating with designers and other developers, troubleshooting and fixing bugs, and staying up-to-date with the latest web development trends."),
        _buildJobItem("Product Manager", "Innovate Inc.", "New York", 75400, "Collect, clean, and analyze large datasets, build predictive models and machine learning algorithms, visualize data to uncover insights, collaborate with business stakeholders to solve complex problems, and use statistical and mathematical techniques to draw conclusions."),
        _buildJobItem("Data Scientist", "Analytics Ltd.", "Boston", 122310, "Automate infrastructure provisioning and deployment processes, monitor system performance and troubleshoot issues, collaborate with development teams to improve deployment pipelines, implement security best practices, and use tools like Ansible, Puppet, Chef, and Kubernetes."),
      ],
    );
  }

  Widget _buildSavedOffersList() {
    return Column(
      children: [
        _buildJobItem("UX Designer", "Design Studio", "Los Angeles", 23310, "Design, develop, and test mobile applications for iOS and Android, work with platform-specific tools and frameworks, optimize app performance and user experience, collaborate with designers and backend developers, and stay up-to-date with the latest mobile development trends."),
        _buildJobItem("Backend Developer", "Web Solutions", "Seattle", 742310, "Identify, assess, and mitigate security risks, monitor network traffic and detect security threats, respond to security incidents and breaches, conduct security audits and vulnerability assessments, and stay informed about the latest cybersecurity threats and best practices."),
        _buildJobItem("Marketing Specialist", "Ad Agency", "Chicago", 44310, "Design and execute test cases to ensure software quality, identify and report bugs and defects, collaborate with developers to fix issues, use testing tools and frameworks to automate testing processes, and understand software development methodologies and testing best practices."),
      ],
    );
  }

  // // Account Settings with Switch Buttons
  // Widget _buildAccountSettings() {
  //   return Column(
  //     children: [
  //       _buildSwitchSetting("Enable Notifications", true),
  //       _buildSwitchSetting("Dark Mode", false),
  //       _buildSwitchSetting("Location Tracking", false),
  //       _buildSwitchSetting("Auto-Save Data", true),
  //     ],
  //   );
  // }

  // Method to build switch buttons from settings
  Widget _buildAccountSettings() {
    return Column(
      children: _settings.map((setting) {
        return _buildSwitchSetting(setting['name'], setting['enabled']);
      }).toList(),
    );
  }

  Widget _buildSwitchSetting(String title, bool currentValue) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      onChanged: (bool value) {
        setState(() {
          // Here you would typically update the setting's value
          currentValue = value;
          // Optionally update the _settings list if you want to keep track
          final index = _settings.indexWhere((element) => element['name'] == title);
          if (index != -1) {
            _settings[index]['enabled'] = value;
          }
        });
      },
    );
  }


  // Widget _buildSwitchSetting(String title, bool value) {
  //   return SwitchListTile(
  //     title: Text(title),
  //     value: value,
  //     onChanged: (bool newValue) {
  //       setState(() {
  //         value = !value;
  //         //todo add logic
  //       });
  //     },
  //   );
  // }
  List<Map<String, dynamic>> _settings = [];
  String settingsJson = '''
[
  {
    "name": "Enable Notifications",
    "enabled": true
  },
  {
    "name": "Dark Mode",
    "enabled": false
  },
  {
    "name": "Location Tracking",
    "enabled": false
  },
  {
    "name": "Auto-Save Data",
    "enabled": true
  }
]
''';
  void _loadSettings() {
    // Decode the JSON string to a List of Maps
    final List<dynamic> jsonList = json.decode(settingsJson);
    setState(() {
      _settings = jsonList.cast<Map<String, dynamic>>();
    });
  }
  @override
  Widget build(BuildContext context) {

    // Sample JSON data



    // Content for each section
    final List<Widget> contentOptions = [
      _buildPersonalData(),
      _buildApplicationsList(),
      _buildSavedOffersList(),
      _buildAccountSettings(),
    ];



    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                // Navigate to Analytics Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicantAnalyticsPage()),
                );
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
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: menuOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      menuOptions[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _selectedIndex == index
                            ? Colors.blueAccent
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedIndex == index,
                    onTap: () => _onMenuItemSelected(index),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    selectedTileColor: Colors.blue[50],
                  );
                },
              ),
            ),
            Divider(), // Add a divider to separate the Log Out option
            ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              onTap:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              selectedTileColor: Colors.red[50],
            ),
          ],
        ),
      ),
          // Left Sidebar with Menu Options
          // Container(
          //   width: 200,
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(15.0),
          //   ),
          //   child: ListView.builder(
          //     itemCount: menuOptions.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(
          //           menuOptions[index],
          //           style: TextStyle(
          //             fontWeight: FontWeight.w600,
          //             color: _selectedIndex == index
          //                 ? Colors.blueAccent
          //                 : Colors.black,
          //           ),
          //         ),
          //         selected: _selectedIndex == index,
          //         onTap: () => _onMenuItemSelected(index),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         selectedTileColor: Colors.blue[50],
          //       );
          //     },
          //   ),
          //
          // ),
          SizedBox(width: 20),
          // Right Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: contentOptions[_selectedIndex],
            ),
          ),
        ],
      ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: isExpanded ?
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
