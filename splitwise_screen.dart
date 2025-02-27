import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class SplitwiseScreen extends StatefulWidget {
  const SplitwiseScreen({Key? key}) : super(key: key);

  @override
  State<SplitwiseScreen> createState() => _SplitwiseScreenState();
}

class _SplitwiseScreenState extends State<SplitwiseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGroup = "Diwali Party";
  String _selectedCategory = "all";

  // Mock data
  final Map<String, List<String>> groups = {
    "Diwali Party": ["Razzak", "Shau", "Saanvi", "Rohan"],
    "House Expenses": ["Rohan", "Shau", "Saanvi"],
    "Road Trip": ["Razzak", "Rohan", "Shau"],
  };

  final List<Map<String, dynamic>> categories = [
    {"id": "all", "name": "All", "icon": Icons.all_inclusive, "color": Colors.grey},
    {"id": "food", "name": "Food", "icon": Icons.restaurant, "color": Colors.orange},
    {"id": "transport", "name": "Transport", "icon": Icons.directions_car, "color": Colors.blue},
    {"id": "shopping", "name": "Shopping", "icon": Icons.shopping_bag, "color": Colors.purple},
    {"id": "entertainment", "name": "Entertainment", "icon": Icons.movie, "color": Colors.pink},
    {"id": "utilities", "name": "Utilities", "icon": Icons.power, "color": Colors.green},
  ];

  final List<Map<String, dynamic>> expenses = [
    {
      "id": "1",
      "name": "Dinner",
      "amount": 150.0,
      "paidBy": "Rohan",
      "category": "food",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "participants": ["Razzak", "Shau", "Saanvi", "Rohan"],
      "shares": {
        "Razzak": 37.50,
        "Shau": 37.50,
        "Saanvi": 37.50,
        "Rohan": 37.50,
      }
    },
    {
      "id": "2",
      "name": "Groceries",
      "amount": 200.0,
      "paidBy": "Saanvi",
      "category": "shopping",
      "date": DateTime.now(),
      "participants": ["Razzak", "Shau", "Saanvi", "Rohan"],
      "shares": {
        "Razzak": 50.0,
        "Shau": 50.0,
        "Saanvi": 50.0,
        "Rohan": 50.0,
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: BrandedAppBar(
      title: 'Split Expenses',
      showBackButton: true,
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'EXPENSES'),
          Tab(text: 'SUMMARY'),
        ],
      ),
    ),
      body: Column(
        children: [
          // Group Selection & Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGroup,
                  decoration: InputDecoration(
                    labelText: 'Select Group',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  items: groups.keys.map((group) {
                    return DropdownMenuItem(
                      value: group,
                      child: Text(group),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGroup = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Category Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category['icon'] as IconData,
                                size: 16,
                                color: _selectedCategory == category['id']
                                    ? Colors.white
                                    : category['color'] as Color,
                              ),
                              const SizedBox(width: 4),
                              Text(category['name'] as String),
                            ],
                          ),
                          selected: _selectedCategory == category['id'],
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category['id'] : 'all';
                            });
                          },
                          backgroundColor: (category['color'] as Color).withOpacity(0.1),
                          selectedColor: category['color'] as Color,
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Expenses Tab
                _buildExpensesTab(),
                // Summary Tab
                _buildSummaryTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseModal(context),
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildExpensesTab() {
    final filteredExpenses = expenses.where((expense) =>
        _selectedCategory == 'all' || expense['category'] == _selectedCategory).toList();

    return filteredExpenses.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No expenses yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first expense',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: filteredExpenses.length,
            itemBuilder: (context, index) {
              final expense = filteredExpenses[index];
              final category = categories.firstWhere(
                (c) => c['id'] == expense['category'],
                orElse: () => categories.last,
              );

              return Card(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: InkWell(
                  onTap: () => _showExpenseDetails(expense),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (category['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: category['color'] as Color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy').format(expense['date']),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${expense['amount'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Paid by ${expense['paidBy']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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

  Widget _buildSummaryTab() {
    final totalExpenses = expenses.fold<double>(
      0,
      (sum, expense) => sum + (expense['amount'] as double),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Total Stats Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Expenses',
                '\$${totalExpenses.toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                Colors.teal,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Per Person',
                '\$${(totalExpenses / groups[_selectedGroup]!.length).toStringAsFixed(2)}',
                Icons.people,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Category Breakdown
        const Text(
          'Category Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._buildCategoryBreakdown(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryBreakdown() {
    final categoryTotals = <String, double>{};
    final totalAmount = expenses.fold<double>(
      0,
      (sum, expense) => sum + (expense['amount'] as double),
    );

    // Calculate totals per category
    for (var expense in expenses) {
      final category = expense['category'] as String;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + (expense['amount'] as double);
    }

    return categories.where((c) => c['id'] != 'all').map((category) {
      final amount = categoryTotals[category['id']] ?? 0;
      final percentage = totalAmount > 0 ? (amount / totalAmount * 100) : 0;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: (category['color'] as Color).withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(category['color'] as Color),
            ),
          ],
        ),
      );
    }).toList();
  }
  void _showAddExpenseModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    double amount = 0;
    String paidBy = groups[_selectedGroup]!.first;
    String category = categories[1]['id'];
    Map<String, bool> participants = {
      for (var member in groups[_selectedGroup]!) member: true
    };

    showModalBottomSheet(
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
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Expense',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expense Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.label_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expense name';
                      }
                      return null;
                    },
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 16),

                  // Amount Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Paid By Dropdown
                  DropdownButtonFormField<String>(
                    value: paidBy,
                    decoration: InputDecoration(
                      labelText: 'Paid By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    items: groups[_selectedGroup]!.map((member) {
                      return DropdownMenuItem(
                        value: member,
                        child: Text(member),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => paidBy = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: categories.where((c) => c['id'] != 'all').map((c) {
                      return DropdownMenuItem(
                        value: c['id'] as String,
                        child: Row(
                          children: [
                            Icon(c['icon'] as IconData, color: c['color'] as Color, size: 20),
                            const SizedBox(width: 8),
                            Text(c['name'] as String),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => category = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Split Between Section
                  const Text(
                    'Split Between',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...participants.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => participants[entry.key] = value);
                        }
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 24),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final selectedParticipants = participants.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key)
                              .toList();

                          if (selectedParticipants.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one participant'),
                              ),
                            );
                            return;
                          }

                          final shareAmount = amount / selectedParticipants.length;
                          final Map<String, double> shares = {
                            for (var participant in selectedParticipants)
                              participant: shareAmount
                          };

                          setState(() {
                            expenses.add({
                              "id": DateTime.now().toString(),
                              "name": name,
                              "amount": amount,
                              "paidBy": paidBy,
                              "category": category,
                              "date": DateTime.now(),
                              "participants": selectedParticipants,
                              "shares": shares,
                            });
                          });

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Expense'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExpenseDetails(Map<String, dynamic> expense) {
    final category = categories.firstWhere(
      (c) => c['id'] == expense['category'],
      orElse: () => categories.last,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense['name'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMMM d, yyyy').format(expense['date']),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${(expense['amount'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Paid by'),
                      Text(
                        expense['paidBy'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Splits Section
            const Text(
              'Split Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(expense['shares'] as Map<String, dynamic>).entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      '\$${(entry.value as double).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        expenses.removeWhere((e) => e['id'] == expense['id']);
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}