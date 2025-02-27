import 'package:flutter/material.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // FAQ Categories
  final List<String> _categories = [
    'All',
    'Account',
    'Payments',
    'Security',
    'Limits',
    'Technical',
  ];

  // FAQ Data structure
  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Account',
      'question': 'How do I change my email address?',
      'answer': 'To change your email address:\n\n'
          '1. Go to Profile Settings\n'
          '2. Select "Personal Information"\n'
          '3. Tap on "Email Address"\n'
          '4. Enter and verify your new email',
    },
    {
      'category': 'Payments',
      'question': 'What are the transfer limits?',
      'answer': 'Default transfer limits are:\n\n'
          '• Daily: \$1,000\n'
          '• Weekly: \$5,000\n'
          '• Monthly: \$20,000\n\n'
          'You can adjust these limits in Payment Settings.',
    },
    {
      'category': 'Security',
      'question': 'How do I enable two-factor authentication?',
      'answer': 'To enable 2FA:\n\n'
          '1. Go to Security Settings\n'
          '2. Select "Two-Factor Authentication"\n'
          '3. Choose your preferred method\n'
          '4. Follow the verification steps',
    },
  ];

  // Support request types
  final List<Map<String, dynamic>> _supportOptions = [
    {
      'title': 'Email Support',
      'icon': Icons.email_outlined,
      'description': 'Get help via email. Response within 24 hours.',
      'action': 'Send Email',
    },
    {
      'title': 'Live Chat',
      'icon': Icons.chat_outlined,
      'description': 'Chat with our support team. Available 24/7.',
      'action': 'Start Chat',
    },
    {
      'title': 'Phone Support',
      'icon': Icons.phone_outlined,
      'description': 'Call us directly. Available Mon-Fri, 9AM-5PM EST.',
      'action': 'Call Now',
    },
  ];

  List<Map<String, dynamic>> get filteredFaqs {
    if (_selectedCategory == 'All') {
      return _faqs.where((faq) {
        final searchTerm = _searchController.text.toLowerCase();
        return faq['question'].toLowerCase().contains(searchTerm) ||
            faq['answer'].toLowerCase().contains(searchTerm);
      }).toList();
    }
    return _faqs.where((faq) {
      final searchTerm = _searchController.text.toLowerCase();
      return faq['category'] == _selectedCategory &&
          (faq['question'].toLowerCase().contains(searchTerm) ||
              faq['answer'].toLowerCase().contains(searchTerm));
    }).toList();
  }

  void _handleSupportOption(Map<String, dynamic> option) {
    // TODO: Implement support actions
    switch (option['title']) {
      case 'Email Support':
        _showEmailForm();
        break;
      case 'Live Chat':
        _showChatWindow();
        break;
      case 'Phone Support':
        _showPhoneDialog();
        break;
    }
  }

  void _showEmailForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support request sent successfully!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Send Request'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showChatWindow() {
    // TODO: Implement chat window
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat support coming soon!'),
      ),
    );
  }

  void _showPhoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Support'),
        content: const Text('Support line: +1 (555) 123-4567\n\n'
            'Hours: Monday-Friday, 9AM-5PM EST'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement phone call
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            faq['answer'],
            style: TextStyle(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportOption(Map<String, dynamic> option) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _handleSupportOption(option),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  option['icon'],
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option['description'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => _handleSupportOption(option),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(option['action']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: const BrandedAppBar(
  title: 'Help & Support',
  backgroundColor: Colors.white,
),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for help',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = category);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Support Options Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._supportOptions.map(_buildSupportOption).toList(),
                    ],
                  ),
                ),
                // FAQ Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: filteredFaqs.map(_buildFaqItem).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}