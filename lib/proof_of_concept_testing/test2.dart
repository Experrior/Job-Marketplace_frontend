import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graphs and Descriptions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphPage(),
    );
  }
}

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics with Graphs'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row with two graphs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGraphWithDescription('assets/graph1.png', 'Description for Graph 1',500),
                  _buildGraphWithDescription('assets/graph2.png', 'Description for Graph 2',500),
                ],
              ),
              SizedBox(height: 20),

              // Full-width graph with description
              _buildGraphWithDescription('assets/graph3.png', 'Description for Graph 3',800),
              SizedBox(height: 20),

              // Second row with two graphs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGraphWithDescription('assets/graph4.png', 'Description for Graph 4', 500),
                  _buildGraphWithDescription('assets/graph5.png', 'Description for Graph 5', 500),
                ],
              ),
              SizedBox(height: 20),

              // Full-width graph with description
              _buildGraphWithDescription('assets/graph6.png', 'Description for Graph 6',800),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphWithDescription(String imagePath, String description, double width1) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image widget for the graph
            Image.asset(imagePath, height: 400, width: width1, fit: BoxFit.cover),
            SizedBox(height: 8),
            // Text description below the graph
            Text(
              description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
