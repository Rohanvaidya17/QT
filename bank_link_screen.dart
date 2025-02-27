import 'package:flutter/material.dart';
import 'package:qt_qt/widgets/qt_widgets.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class BankLinkScreen extends StatefulWidget {
  const BankLinkScreen({Key? key}) : super(key: key);

  @override
  State<BankLinkScreen> createState() => _BankLinkScreenState();
}

class _BankLinkScreenState extends State<BankLinkScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  String? _selectedBankId;

  // Sample bank data - In production, this would come from an API
  final List<Map<String, dynamic>> _banks = [
    {
      'id': '1',
      'name': 'Royal Bank of Canada',
      'shortName': 'RBC',
      'logoUrl': 'assets/banks/rbc.png',
      'backgroundColor': Colors.blue[900],
      'popularityRank': 1,
    },
    {
      'id': '2',
      'name': 'TD Bank',
      'shortName': 'TD',
      'logoUrl': 'assets/banks/td.png',
      'backgroundColor': Colors.green[900],
      'popularityRank': 2,
    },
    {
      'id': '3',
      'name': 'Scotiabank',
      'shortName': 'Scotia',
      'logoUrl': 'assets/banks/scotia.png',
      'backgroundColor': Colors.red[900],
      'popularityRank': 3,
    },
    {
      'id': '4',
      'name': 'BMO Bank of Montreal',
      'shortName': 'BMO',
      'logoUrl': 'assets/banks/bmo.png',
      'backgroundColor': Colors.blue[800],
      'popularityRank': 4,
    },
  ];

  List<Map<String, dynamic>> get filteredBanks {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _banks;
    
    return _banks.where((bank) {
      return bank['name'].toLowerCase().contains(query) ||
             bank['shortName'].toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _handleBankSelection(Map<String, dynamic> bank) async {
    setState(() => _selectedBankId = bank['id']);
    
    // Show login modal
    final result = await _showBankLoginModal(bank);
    
    if (result == true) {
      // Show account selection modal
      final accountSelected = await _showAccountSelectionModal(bank);
      
      if (accountSelected == true && mounted) {
        // Show success modal and navigate back
        await _showSuccessModal();
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<bool?> _showBankLoginModal(Map<String, dynamic> bank) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;
    bool isLoading = false;

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bank['backgroundColor'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Login to ${bank['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username/ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                // Simulate API call
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                if (mounted) {
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showAccountSelectionModal(Map<String, dynamic> bank) {
    // Sample accounts - In production, these would come from the bank's API
    final accounts = [
      {
        'id': '1',
        'type': 'Checking',
        'number': '****1234',
        'balance': 5000.00,
      },
      {
        'id': '2',
        'type': 'Savings',
        'number': '****5678',
        'balance': 10000.00,
      },
    ];

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...accounts.map((account) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () => Navigator.pop(context, true),
                title: Text(account['type'] as String),
                subtitle: Text(account['number'] as String),
                trailing: Text(
                  '\$${(account['balance'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuccessModal() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account Linked!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your bank account has been successfully linked.',
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
                onPressed: () => Navigator.pop(context),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const BrandedAppBar(
        title: 'Link Bank Account'
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for your bank',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Bank List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBanks.length + 1, // +1 for the info card
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.teal[700],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Your bank credentials are securely encrypted and never stored on our servers.',
                            style: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final bank = filteredBanks[index - 1];
                final isSelected = bank['id'] == _selectedBankId;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.teal : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => _handleBankSelection(bank),
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bank['backgroundColor'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      bank['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(bank['shortName']),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
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