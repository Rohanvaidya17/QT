// lib/screens/create_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/providers/reminder_provider.dart';
import 'package:qt_qt/models/reminder_model.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';
import 'package:intl/intl.dart';

class CreateReminderScreen extends StatefulWidget {
  const CreateReminderScreen({Key? key}) : super(key: key);

  @override
  _CreateReminderScreenState createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _searchQuery = '';
  List<String> selectedContacts = [];
  bool _isLoading = false;

  // Mock data for the demo
  final List<Map<String, dynamic>> contacts = [
    {
      'id': '1',
      'name': 'Rohan Vaidya',
      'amount': 50.00,
      'date': '2024-01-15'
    },
    {
      'id': '2',
      'name': 'Saanvi',
      'amount': 25.50,
      'date': '2024-01-28'
    },
    {
      'id': '3',
      'name': 'Razzak',
      'amount': 75.00,
      'date': '2024-01-20'
    }
  ];

  final List<Map<String, dynamic>> templates = [
    {
      'id': '1',
      'title': 'Payment Reminder',
      'text': 'Hi! Just a friendly reminder about the payment of \$[amount].'
    },
    {
      'id': '2',
      'title': 'Follow-up',
      'text': 'Hey, checking about the \$[amount] payment when you get a chance.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _dueDateController.text = DateFormat('MMM d, yyyy').format(_dueDate);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _handleContactSelection(String id) {
    setState(() {
      if (selectedContacts.contains(id)) {
        selectedContacts.remove(id);
      } else {
        selectedContacts.add(id);
      }
    });
  }

  void _handleTemplateSelection(String text) {
    final amount = _amountController.text.isEmpty 
        ? '[amount]' 
        : _amountController.text;
    
    setState(() {
      _messageController.text = text.replaceAll('[amount]', amount);
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('MMM d, yyyy').format(_dueDate);
      });
    }
  }

  Future<void> _handleSendReminder() async {
    if (!_formKey.currentState!.validate() || selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields and select at least one contact')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reminderProvider = Provider.of<ReminderProvider>(context, listen: false);
      final amount = double.parse(_amountController.text);
      
      // Create a reminder for each selected contact
      for (final contactId in selectedContacts) {
        final contact = contacts.firstWhere((c) => c['id'] == contactId);
        
        await reminderProvider.addReminder(
          ReminderModel(
            id: DateTime.now().millisecondsSinceEpoch.toString() + contactId,
            senderId: '1', // Current user id
            receiverId: contactId,
            senderName: 'You',
            receiverName: contact['name'],
            amount: amount,
            dueDate: _dueDate,
            note: _messageController.text,
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder sent successfully')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Reminder',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSendReminder,
            child: Text(
              'Send',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Recipients Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.grey[400]),
                            const SizedBox(width: 8),
                            const Text(
                              'Select Recipients',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search contacts...',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) => setState(() => _searchQuery = value),
                        ),
                        const SizedBox(height: 16),
                        
                        // Contacts List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contacts
                              .where((contact) => contact['name']
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                              .length,
                          itemBuilder: (context, index) {
                            final filteredContacts = contacts
                                .where((contact) => contact['name']
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()))
                                .toList();
                            final contact = filteredContacts[index];
                            final isSelected = selectedContacts.contains(contact['id']);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.teal[50] : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.teal : Colors.transparent,
                                ),
                              ),
                              child: ListTile(
                                onTap: () => _handleContactSelection(contact['id']),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal[100],
                                  child: Text(
                                    contact['name'][0],
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contact['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Owes \$${contact['amount'].toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.teal)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              

// Amount Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.attach_money),
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Due Date Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Due Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _dueDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.edit_calendar),
                              onPressed: () => _selectDueDate(context),
                            ),
                          ),
                          onTap: () => _selectDueDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Quick Messages Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Messages',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Template List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            final template = templates[index];
                            return ListTile(
                              onTap: () => _handleTemplateSelection(template['text']),
                              title: Text(
                                template['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(template['text']),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: Colors.grey[50],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Message Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Write your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _isLoading
          ? const LinearProgressIndicator()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _handleSendReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Reminder',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
    );
  }
} lib/screens/create_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/providers/reminder_provider.dart';
import 'package:qt_qt/models/reminder_model.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';
import 'package:intl/intl.dart';

class CreateReminderScreen extends StatefulWidget {
  const CreateReminderScreen({Key? key}) : super(key: key);

  @override
  _CreateReminderScreenState createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _searchQuery = '';
  List<String> selectedContacts = [];
  bool _isLoading = false;

  // Mock data for the demo
  final List<Map<String, dynamic>> contacts = [
    {
      'id': '1',
      'name': 'Rohan Vaidya',
      'amount': 50.00,
      'date': '2024-01-15'
    },
    {
      'id': '2',
      'name': 'Saanvi',
      'amount': 25.50,
      'date': '2024-01-28'
    },
    {
      'id': '3',
      'name': 'Razzak',
      'amount': 75.00,
      'date': '2024-01-20'
    }
  ];

  final List<Map<String, dynamic>> templates = [
    {
      'id': '1',
      'title': 'Payment Reminder',
      'text': 'Hi! Just a friendly reminder about the payment of \$[amount].'
    },
    {
      'id': '2',
      'title': 'Follow-up',
      'text': 'Hey, checking about the \$[amount] payment when you get a chance.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _dueDateController.text = DateFormat('MMM d, yyyy').format(_dueDate);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _handleContactSelection(String id) {
    setState(() {
      if (selectedContacts.contains(id)) {
        selectedContacts.remove(id);
      } else {
        selectedContacts.add(id);
      }
    });
  }

  void _handleTemplateSelection(String text) {
    final amount = _amountController.text.isEmpty 
        ? '[amount]' 
        : _amountController.text;
    
    setState(() {
      _messageController.text = text.replaceAll('[amount]', amount);
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('MMM d, yyyy').format(_dueDate);
      });
    }
  }

  Future<void> _handleSendReminder() async {
    if (!_formKey.currentState!.validate() || selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields and select at least one contact')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reminderProvider = Provider.of<ReminderProvider>(context, listen: false);
      final amount = double.parse(_amountController.text);
      
      // Create a reminder for each selected contact
      for (final contactId in selectedContacts) {
        final contact = contacts.firstWhere((c) => c['id'] == contactId);
        
        await reminderProvider.addReminder(
          ReminderModel(
            id: DateTime.now().millisecondsSinceEpoch.toString() + contactId,
            senderId: '1', // Current user id
            receiverId: contactId,
            senderName: 'You',
            receiverName: contact['name'],
            amount: amount,
            dueDate: _dueDate,
            note: _messageController.text,
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder sent successfully')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Reminder',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSendReminder,
            child: Text(
              'Send',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Recipients Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.grey[400]),
                            const SizedBox(width: 8),
                            const Text(
                              'Select Recipients',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search contacts...',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) => setState(() => _searchQuery = value),
                        ),
                        const SizedBox(height: 16),
                        
                        // Contacts List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contacts
                              .where((contact) => contact['name']
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                              .length,
                          itemBuilder: (context, index) {
                            final filteredContacts = contacts
                                .where((contact) => contact['name']
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()))
                                .toList();
                            final contact = filteredContacts[index];
                            final isSelected = selectedContacts.contains(contact['id']);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.teal[50] : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.teal : Colors.transparent,
                                ),
                              ),
                              child: ListTile(
                                onTap: () => _handleContactSelection(contact['id']),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal[100],
                                  child: Text(
                                    contact['name'][0],
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contact['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Owes \$${contact['amount'].toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.teal)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
              