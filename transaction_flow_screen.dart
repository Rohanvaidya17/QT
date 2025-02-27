import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionFlowScreen extends StatefulWidget {
  const TransactionFlowScreen({Key? key}) : super(key: key);

  @override
  _TransactionFlowScreenState createState() => _TransactionFlowScreenState();
}

class _TransactionFlowScreenState extends State<TransactionFlowScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Form data
  String? selectedAccountId;
  double? amount;
  String? recipientId;
  String? note;

  // Sample bank accounts data
  final List<Map<String, dynamic>> bankAccounts = [
    {
      'id': '1',
      'bankName': 'RBC Bank',
      'accountType': 'Savings',
      'accountNumber': '****1234',
      'balance': 5000.00,
      'isDefault': true,
    },
    {
      'id': '2',
      'bankName': 'TD Bank',
      'accountType': 'Checking',
      'accountNumber': '****5678',
      'balance': 3000.00,
      'isDefault': false,
    },
  ];

  // Sample quick amounts
  final List<double> quickAmounts = [10, 20, 50, 100, 500, 1000];

  // Sample recent recipients
  final List<Map<String, dynamic>> recentRecipients = [
    {
      'id': '1',
      'name': 'Razzak',
      'email': 'razzak@example.com',
      'recentAmount': 50.00,
      'lastTransaction': '2 days ago',
    },
    {
      'id': '2',
      'name': 'Saanvi',
      'email': 'saanvi@example.com',
      'recentAmount': 30.00,
      'lastTransaction': '1 week ago',
    },
    {
      'id': '3',
      'name': 'Shau',
      'email': 'shau@example.com',
      'recentAmount': 25.00,
      'lastTransaction': '3 days ago',
    },
  ];

  String getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Select Account';
      case 1: return 'Enter Amount';
      case 2: return 'Choose Recipient';
      case 3: return 'Confirm Transfer';
      default: return 'Send Money';
    }
  }

  void nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _processTransaction();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool canProceed() {
    switch (_currentStep) {
      case 0: return selectedAccountId != null;
      case 1: return amount != null && amount! > 0;
      case 2: return recipientId != null;
      case 3: return true;
      default: return false;
    }
  }

  void _processTransaction() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.teal.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Transfer Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You sent \$${amount?.toStringAsFixed(2)} to ${recentRecipients.firstWhere((r) => r['id'] == recipientId)['name']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Individual step widgets
  Widget _buildAccountSelectionStep() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bankAccounts.length + 1,
      itemBuilder: (context, index) {
        if (index == bankAccounts.length) {
          return _buildAddAccountCard();
        }
        
        final account = bankAccounts[index];
        final isSelected = account['id'] == selectedAccountId;
        
        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.teal : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() => selectedAccountId = account['id']);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              account['bankName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (account['isDefault']) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Default',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${account['accountType']} - ${account['accountNumber']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Balance: \$${account['balance'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.teal.shade700,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountEntryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Enter Amount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    border: InputBorder.none,
                    hintText: '0.00',
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value);
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Available Balance: \$${bankAccounts.firstWhere((a) => a['id'] == selectedAccountId)['balance'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Amounts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickAmounts.map((quickAmount) {
              return ActionChip(
                label: Text('\$$quickAmount'),
                backgroundColor: Colors.teal.shade50,
                onPressed: () {
                  setState(() {
                    amount = quickAmount;
                    _amountController.text = quickAmount.toString();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Add a note',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.note),
            ),
            onChanged: (value) {
              setState(() {
                note = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientSelectionStep() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search recipients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentRecipients.length,
            itemBuilder: (context, index) {
              final recipient = recentRecipients[index];
              final isSelected = recipient['id'] == recipientId;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.teal : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      recipientId = recipient['id'];
                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: Text(
                      recipient['name'][0],
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(recipient['name']),
                  subtitle: Text(recipient['email']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last: \$${recipient['recentAmount']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        recipient['lastTransaction'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    final selectedAccount = bankAccounts.firstWhere((a) => a['id'] == selectedAccountId);
    final selectedRecipient = recentRecipients.firstWhere((r) => r['id'] == recipientId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Transfer Amount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${amount?.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailSection(
            'Transfer Details',
            [
              _buildDetailRow('From Account', '${selectedAccount['bankName']} (${selectedAccount['accountNumber']})', Icons.account_balance),
              _buildDetailRow('To', selectedRecipient['name'], Icons.person),
              if (note?.isNotEmpty ?? false)
                _buildDetailRow('Note', note!, Icons.note),
              _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(DateTime.now()), Icons.calendar_today),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailSection(
            'Fee Breakdown',
            [
              _buildAmountRow('Transfer Amount', amount?.toStringAsFixed(2) ?? '0.00'),
              _buildAmountRow('Processing Fee', '0.00'),
              const Divider(height: 24),
              _buildAmountRow('Total', amount?.toStringAsFixed(2) ?? '0.00', isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.teal.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$$amount',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= _currentStep;
          bool isLast = index == 3;
          
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.teal : Colors.grey[300],
                  ),
                  child: Center(
                    child: Icon(
                      _getStepIcon(index),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive ? Colors.teal : Colors.grey[300],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0: return Icons.account_balance;
      case 1: return Icons.attach_money;
      case 2: return Icons.person;
      case 3: return Icons.check_circle;
      default: return Icons.circle;
    }
  }

  Widget _buildAddAccountCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/bank_accounts');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Add New Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: previousStep,
        ),
        title: Text(
          getStepTitle(),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildAccountSelectionStep(),
                _buildAmountEntryStep(),
                _buildRecipientSelectionStep(),
                _buildConfirmationStep(),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentStep > 0)
              const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed() ? nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_currentStep == 3 ? 'Confirm' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}