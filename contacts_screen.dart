import 'package:flutter/material.dart';
import 'package:qt_qt/main_navigation.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class ContactsScreen extends StatefulWidget {
  final bool isInBottomNav;

  const ContactsScreen({
    Key? key,
    this.isInBottomNav = false,
  }) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> contacts = [
    {
      "name": "Rohan",
      "status": "Paid \$50",
      "email": "rohan@email.com",
      "recent": true,
      "color": Colors.blue
    },
    {
      "name": "Saanvi",
      "status": "Received \$30",
      "email": "saanvi@email.com",
      "recent": true,
      "color": Colors.purple
    },
    {
      "name": "Shau",
      "status": "Owes \$20",
      "email": "shau@email.com",
      "recent": false,
      "color": Colors.orange
    },
    {
      "name": "Razzak",
      "status": "Paid \$100",
      "email": "razzak@email.com",
      "recent": false,
      "color": Colors.green
    }
  ];

  List<Map<String, dynamic>> filteredContacts = [];
  bool showRecent = true;

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(contacts);
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
              contact["name"].toLowerCase().contains(query.toLowerCase()) ||
              contact["email"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _handleBackPress(BuildContext context) {
    if (widget.isInBottomNav) {
      mainNavigationKey.currentState?.switchToHome();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _navigateToQRScreen() async {
    try {
      await Navigator.pushNamed(context, RouteNames.qrCode);
    } catch (e) {
      print('Error navigating to QR screen: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open QR scanner')),
      );
    }
  }

  Widget _buildContactList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = filteredContacts[index];
        if (showRecent && !contact["recent"]) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showContactOptions(contact),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: contact["color"].withOpacity(0.2),
                    child: Text(
                      contact["name"][0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: contact["color"],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact["email"],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact["status"],
                          style: TextStyle(
                            color: contact["status"].contains("Owes") 
                                ? Colors.orange 
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.teal,
                        onPressed: () {
                          Navigator.pushNamed(context, '/send_balance');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _showContactOptions(contact),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isInBottomNav) {
          _handleBackPress(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: BrandedAppBar(
          title: 'Contacts',
          showBackButton: !widget.isInBottomNav,
          onBackPressed: () => _handleBackPress(context),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
              onPressed: _navigateToQRScreen,
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterContacts,
                  decoration: const InputDecoration(
                    hintText: 'Search contacts',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            // Filter Toggles
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildToggleButton('Recent', showRecent, () => setState(() => showRecent = true)),
                  const SizedBox(width: 16),
                  _buildToggleButton('All', !showRecent, () => setState(() => showRecent = false)),
                ],
              ),
            ),
            // Contact List
            Expanded(child: _buildContactList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContactDialog(),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showContactOptions(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Send Money'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/send_balance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Request Money'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Transaction History'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}