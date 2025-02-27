import 'package:flutter/material.dart';

class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountType;
  final bool isPrimary;
  final bool isVerified;
  final double balance;
  final String? logoUrl;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
    this.isPrimary = false,
    this.isVerified = false,
    this.balance = 0.0,
    this.logoUrl,
  });
}

class BankAccountScreen extends StatefulWidget {
  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  List<BankAccount> _bankAccounts = [
    BankAccount(
      id: '1',
      bankName: 'RBC Bank',
      accountNumber: '****1234',
      accountType: 'Savings',
      isPrimary: true,
      isVerified: true,
      balance: 5000.00,
    ),
    BankAccount(
      id: '2',
      bankName: 'TD Bank',
      accountNumber: '****5678',
      accountType: 'Checking',
      isPrimary: false,
      isVerified: true,
      balance: 3000.00,
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  String _selectedAccountType = 'Savings';

  final List<String> _accountTypes = [
    'Savings',
    'Checking',
    'Credit Card',
    'Investment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        title: const Text(
          'Bank Accounts',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: _showAccountLimitsInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAccountSummary(),
          Expanded(
            child: _bankAccounts.isEmpty
                ? _buildEmptyState()
                : _buildAccountsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountModal(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountSummary() {
    double totalBalance = _bankAccounts.fold(
      0,
      (sum, account) => sum + account.balance,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.teal[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_bankAccounts.length} Linked Account${_bankAccounts.length != 1 ? 's' : ''}',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Bank Accounts Added',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your bank account to start transactions',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddAccountModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text('Add Bank Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _bankAccounts.length,
      itemBuilder: (context, index) {
        final account = _bankAccounts[index];
        return _buildAccountCard(account);
      },
    );
  }

  Widget _buildAccountCard(BankAccount account) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            account.bankName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (account.isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Primary',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${account.accountType} - ${account.accountNumber}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${account.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAccountAction(
                  icon: Icons.sync,
                  label: 'Refresh',
                  onTap: () => _refreshAccount(account),
                ),
                _buildAccountAction(
                  icon: Icons.edit,
                  label: 'Edit',
                  onTap: () => _editAccount(account),
                ),
                _buildAccountAction(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () => _showAccountHistory(account),
                ),
                _buildAccountAction(
                  icon: Icons.delete_outline,
                  label: 'Remove',
                  onTap: () => _removeAccount(account),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, color: color ?? Colors.grey[700]),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAccountModal(BuildContext context) {
    _bankNameController.clear();
    _accountNumberController.clear();
    _selectedAccountType = 'Savings';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Bank Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bank name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                decoration: const InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                ),
                items: _accountTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.length < 8) {
                    return 'Account number must be at least 8 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Account'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _addAccount() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _bankAccounts.add(
          BankAccount(
            id: DateTime.now().toString(),
            bankName: _bankNameController.text,
            accountNumber: '****${_accountNumberController.text.substring(_accountNumberController.text.length - 4)}',
            accountType: _selectedAccountType,
            isPrimary: _bankAccounts.isEmpty,
            isVerified: false,
          ),
        );
      });
      Navigator.pop(context);
      _showVerificationPendingDialog();
    }
  }

  void _showVerificationPendingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Pending'),
        content: const Text(
          'Your bank account has been added. Verification may take 1-2 business days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _refreshAccount(BankAccount account) {
    // Implement account refresh logic
  }

  void _editAccount(BankAccount account) {
    // Implement account edit logic
  }

  void _showAccountHistory(BankAccount account) {
    // Implement account history view
  }

  void _removeAccount(BankAccount account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Account'),
        content: Text(
          'Are you sure you want to remove ${account.bankName} account ending in ${account.accountNumber.substring(4)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bankAccounts.removeWhere((a) => a.id == account.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAccountLimitsInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Limits'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Transfer Limits:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Daily: \$10,000'),
            Text('• Weekly: \$50,000'),
            Text('• Monthly: \$100,000'),
            SizedBox(height: 16),
            Text(
              'Processing Times:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Internal: Instant'),
            Text('• External: 1-3 business days'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

 @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }
}