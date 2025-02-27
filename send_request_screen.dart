import 'package:flutter/material.dart';
import 'package:qt_qt/models/user_model.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';
import 'package:qt_qt/main_navigation.dart';

class SendRequestScreen extends StatefulWidget {
  final bool showBackButton;

  const SendRequestScreen({
    Key? key, 
    this.showBackButton = false,
  }) : super(key: key);

  @override
  _SendRequestScreenState createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedType = 'send';
  UserModel? _selectedContact;
  
  final List<double> _quickAmounts = [10, 20, 50, 100, 500, 1000];
  
  final List<UserModel> _recentContacts = [
    UserModel(
      id: '1',
      firstName: 'Razzak',
      lastName: 'Min',
      email: 'razzak@example.com',
      phoneNumber: '+1234567890',
      walletBalance: 1000,
      profilePicture: null,
    ),
    UserModel(
      id: '2',
      firstName: 'Saanvi',
      lastName: 'Bhattacharya',
      email: 'saanvi@example.com',
      phoneNumber: '+1234567891',
      walletBalance: 1500,
      profilePicture: null,
    ),
  ];

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      if (!widget.showBackButton) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home,
          (route) => false,
        );
        return false;
      }
      return true;
    },
    child: Scaffold(
      appBar: BrandedAppBar(
        title: _selectedType == 'send' ? 'Send Money' : 'Request Money',
        showBackButton: true,  // Always show back button
        onBackPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.home,
            (route) => false,
          );
        },
      ),
      body: Column(
        children: [
          _buildTypeSelector(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildContactSelection(),
                    const SizedBox(height: 24),
                    _buildAmountInput(),
                    const SizedBox(height: 16),
                    _buildQuickAmounts(),
                    const SizedBox(height: 24),
                    _buildNoteInput(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    ),
  );
}
  Widget _buildTypeSelector() {
    return Container(
      color: Colors.teal[50],
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeSelectorButton('send', 'Send'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTypeSelectorButton('request', 'Request'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelectorButton(String type, String label) {
    final isSelected = _selectedType == type;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedType = type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildContactSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Contacts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentContacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSearchContact();
              }
              final contact = _recentContacts[index - 1];
              return _buildContactItem(contact);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContact() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal[100],
            child: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.teal,
              onPressed: () {
                // Implement contact search
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text('Search'),
        ],
      ),
    );
  }

  Widget _buildContactItem(UserModel contact) {
    final isSelected = _selectedContact?.id == contact.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedContact = contact),
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: isSelected ? Colors.teal : Colors.grey[200],
                  child: Text(
                    '${contact.firstName[0]}${contact.lastName[0]}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.teal,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.firstName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 24),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: const TextStyle(fontSize: 24),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmounts() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _quickAmounts.map((amount) {
        return ActionChip(
          label: Text('\$$amount'),
          backgroundColor: Colors.teal[50],
          onPressed: () {
            setState(() {
              _amountController.text = amount.toString();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNoteInput() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Add a note',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'What\'s this for?',
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _selectedContact == null ? null : _handleTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          _selectedType == 'send' ? 'Send Money' : 'Request Money',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _handleTransaction() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedType == 'send' ? 'Confirm Send' : 'Confirm Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To: ${_selectedContact!.firstName} ${_selectedContact!.lastName}'),
            Text('Amount: \$${_amountController.text}'),
            if (_noteController.text.isNotEmpty)
              Text('Note: ${_noteController.text}'),
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
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedType == 'send' 
                ? 'Money sent successfully!'
                : 'Request sent successfully!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.showBackButton) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Stay Here'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}