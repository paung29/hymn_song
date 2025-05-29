import 'package:flutter/material.dart';

class AboutThisApp extends StatelessWidget {
  const AboutThisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      appBar: AppBar(
        title: const Text("From a promise to a purpose"),
        backgroundColor: const Color(0xFF624E5B),
        foregroundColor: Colors.white,
        elevation: 1.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "With a grateful heart,",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Three years ago, when I started studying software engineering, I made a promise to God. I told Him that if I ever became a software engineer and gained the skills I needed, I would create a hymn song app in the Wa language. This app would be my way of serving God and helping the next generation worship Him.",
                      style: _letterStyle,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Now, I’m in my third year of studying software engineering in Thailand. It’s been a tough journey. I don’t know if I’ll have enough money to finish my degree, but I believe God will help me through. I trust that He will provide a way.",
                      style: _letterStyle,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "There are still more challenges ahead—one more year of studying, and after that, internships and finding a job. I’m not sure if I’ll have the financial support I need, but I’m doing my best. I want to use the skills I’ve learned to serve in missions and do something meaningful for God.",
                      style: _letterStyle,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "This app is not just a project. It’s something I promised to God. I’m building it for Him, for my family, and for the Wa community. Life has been hard, especially with the civil war happening in my hometown of Lashio, Myanmar. Sometimes I feel stressed being far from home and studying here, but working on this app reminds me of my purpose.",
                      style: _letterStyle,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "The best part of this journey is knowing that the promise I made to God is starting to come true.",
                      style: _letterStyle,
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "- Ai Pao Bra",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "30 May 2025 6:41 AM",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const TextStyle _letterStyle = TextStyle(
  fontSize: 16,
  height: 1.6,
  color: Colors.black87,
  fontFamily: 'Georgia',
);
