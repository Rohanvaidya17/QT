// contacts_screen.dart
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> contacts = [
    {
      "name": "Rohan",
      "lastTransaction": "Paid \$50",
      "transactionDate": "Today",
      "profileColor": Colors.blue,
      "phoneNumber": "+1 234 567 8900"
    },
    {
      "name": "Saanvi",
      "lastTransaction": "Received \$30",
      "transactionDate": "Yesterday",
      "profileColor": Colors.green,
      "phoneNumber": "+1 234 567 8901"
    },
    {
      "name": "Shau",
      "lastTransaction": "Owes \$20",
      "transactionDate": "2 days ago",
      "profileColor": Colors.orange,
      "phoneNumber": "+1 234 567 8902"
    },
    {
      "name": "Razzak",
      "lastTransaction": "Sent \$15",
      "transactionDate": "3 days ago",
      "profileColor": Colors.purple,
      "phoneNumber": "+1 234 567 8903"
    }
  ];
  List<Map<String, dynamic>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(contacts);
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
              contact["name"]!.toLowerCase().contains(query.toLowerCase()) ||
              contact["phoneNumber"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Colors.teal[700]),
            onPressed: () {
              // Handle QR code scanning
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar with Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterContacts,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.teal[700]),
                    onPressed: () {
                      // Show filter options
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Quick Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildQuickActionButton(
                    icon: Icons.person_add,
                    label: 'New Contact',
                    onTap: () {
                      // Add new contact
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.group,
                    label: 'Create Group',
                    onTap: () {
                      // Create group
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.phone,
                    label: 'Invite Friends',
                    onTap: () {
                      // Invite friends
                    },
                  ),
                ],
              ),
            ),
          ),

          // Contacts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      _showContactActions(context, contact);
                    },
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: contact["profileColor"],
                      child: Text(
                        contact["name"][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      contact["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          contact["phoneNumber"],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              contact["lastTransaction"],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              contact["transactionDate"],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                      onPressed: () {
                        _showContactActions(context, contact);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact
        },
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.teal[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactActions(BuildContext context, Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: contact["profileColor"],
                child: Text(
                  contact["name"][0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(contact["name"]),
              subtitle: Text(contact["phoneNumber"]),
            ),
            const Divider(),
            _buildActionButton(
              icon: Icons.send,
              label: 'Send Money',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/send_balance');
              },
            ),
            _buildActionButton(
              icon: Icons.request_page,
              label: 'Request Money',
              onTap: () {
                Navigator.pop(context);
                // Navigate to request money screen
              },
            ),
            _buildActionButton(
              icon: Icons.history,
              label: 'View Transaction History',
              onTap: () {
                Navigator.pop(context);
                // Navigate to transaction history screen
              },
            ),
            _buildActionButton(
              icon: Icons.delete,
              label: 'Remove Contact',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                // Show delete confirmation
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.teal[700],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}