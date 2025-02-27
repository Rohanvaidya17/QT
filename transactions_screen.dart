// transactions_screen.dart
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'all';
  String _selectedTimeRange = 'all';
  final TextEditingController _searchController = TextEditingController();
  
  // Mock transaction data - In real app, this would come from a provider
  final List<Map<String, dynamic>> transactions = [
    {
      "id": "1",
      "type": "sent",
      "amount": 50.0,
      "to": "Razzak",
      "date": "2024-03-01",
      "category": "friends",
      "note": "Dinner split"
    },
    {
      "id": "2",
      "type": "received",
      "amount": 20.0,
      "from": "Saanvi",
      "date": "2024-03-01",
      "category": "payment",
      "note": "Project payment"
    },
    {
      "id": "3",
      "type": "sent",
      "amount": 20.0,
      "to": "Razzak",
      "date": "2024-02-28",
      "category": "shopping",
      "note": "Shopping split"
    },
    {
      "id": "4",
      "type": "received",
      "amount": 100.0,
      "from": "Shau",
      "date": "2024-02-27",
      "category": "salary",
      "note": "Monthly rent"
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    return transactions.where((transaction) {
      // Apply type filter
      if (_selectedFilter != 'all' && transaction['type'] != _selectedFilter) {
        return false;
      }
      
      // Apply search
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        final personName = (transaction['to'] ?? transaction['from']).toString().toLowerCase();
        final note = transaction['note'].toString().toLowerCase();
        if (!personName.contains(searchTerm) && !note.contains(searchTerm)) {
          return false;
        }
      }

      // Apply time range filter
      if (_selectedTimeRange != 'all') {
        final transactionDate = DateTime.parse(transaction['date']);
        final now = DateTime.now();
        switch (_selectedTimeRange) {
          case 'today':
            return transactionDate.year == now.year &&
                transactionDate.month == now.month &&
                transactionDate.day == now.day;
          case 'week':
            final weekAgo = now.subtract(const Duration(days: 7));
            return transactionDate.isAfter(weekAgo);
          case 'month':
            return transactionDate.year == now.year &&
                transactionDate.month == now.month;
        }
      }
      
      return true;
    }).toList();
  }

  double get totalBalance {
    return transactions.fold(0, (sum, transaction) {
      if (transaction['type'] == 'received') {
        return sum + transaction['amount'];
      } else {
        return sum - transaction['amount'];
      }
    });
  }

  Widget _buildTransactionFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedFilter == 'all',
            onSelected: (selected) {
              setState(() => _selectedFilter = 'all');
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Sent'),
            selected: _selectedFilter == 'sent',
            onSelected: (selected) {
              setState(() => _selectedFilter = 'sent');
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Received'),
            selected: _selectedFilter == 'received',
            onSelected: (selected) {
              setState(() => _selectedFilter = 'received');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All Time'),
            selected: _selectedTimeRange == 'all',
            onSelected: (selected) {
              setState(() => _selectedTimeRange = 'all');
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Today'),
            selected: _selectedTimeRange == 'today',
            onSelected: (selected) {
              setState(() => _selectedTimeRange = 'today');
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('This Week'),
            selected: _selectedTimeRange == 'week',
            onSelected: (selected) {
              setState(() => _selectedTimeRange = 'week');
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('This Month'),
            selected: _selectedTimeRange == 'month',
            onSelected: (selected) {
              setState(() => _selectedTimeRange = 'month');
            },
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey[300],
                ),
              ),
            ),
            Text(
              'Transaction Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount'),
                Text(
                  '\$${transaction['amount'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction['type'] == 'received'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date'),
                Text(transaction['date']),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Category'),
                Text(transaction['category'].toString().toUpperCase()),
              ],
            ),
            if (transaction['note'] != null) ...[
              const Divider(),
              const Text('Note'),
              const SizedBox(height: 4),
              Text(
                transaction['note'],
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle repeat transaction
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/send_balance',
                    arguments: {
                      'recipient': transaction['to'] ?? transaction['from'],
                      'amount': transaction['amount'].toString(),
                    },
                  );
                },
                child: const Text('Repeat Transaction'),
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
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/QTlogo.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Transactions',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.teal[50],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/send_balance');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Send Money'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search transactions',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTransactionFilters(),
                const SizedBox(height: 8),
                _buildTimeRangeFilter(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                final isReceived = transaction['type'] == 'received';
                
                return ListTile(
                  onTap: () => _showTransactionDetails(transaction),
                  leading: CircleAvatar(
                    backgroundColor: isReceived ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isReceived ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    isReceived
                        ? 'Received from ${transaction['from']}'
                        : 'Sent to ${transaction['to']}',
                  ),
                  subtitle: Text(
                    '${transaction['date']} • ${transaction['category']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    '${isReceived ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isReceived ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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