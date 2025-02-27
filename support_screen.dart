import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Contact Us'),
              subtitle: const Text('support@qtapp.com'),
              onTap: () {
                // Email functionality can be added here
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('FAQs'),
              subtitle: const Text('Find answers to common questions'),
              onTap: () {
                // Navigate to FAQ screen or display FAQ content
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Report a Bug'),
              subtitle: const Text('Let us know about any issues'),
              onTap: () {
                // Navigate to a bug report form or display a dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
