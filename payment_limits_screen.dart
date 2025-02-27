import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class PaymentLimitsScreen extends StatefulWidget {
  const PaymentLimitsScreen({Key? key}) : super(key: key);

  @override
  _PaymentLimitsScreenState createState() => _PaymentLimitsScreenState();
}

class _PaymentLimitsScreenState extends State<PaymentLimitsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for limit inputs
  final _dailyInternalController = TextEditingController(text: '1000');
  final _weeklyInternalController = TextEditingController(text: '5000');
  final _monthlyInternalController = TextEditingController(text: '20000');
  
  final _dailyExternalController = TextEditingController(text: '500');
  final _weeklyExternalController = TextEditingController(text: '2500');
  final _monthlyExternalController = TextEditingController(text: '10000');

  // Current spending tracking
  final Map<String, double> _currentSpending = {
    'dailyInternal': 200.0,
    'weeklyInternal': 800.0,
    'monthlyInternal': 3000.0,
    'dailyExternal': 100.0,
    'weeklyExternal': 400.0,
    'monthlyExternal': 1500.0,
  };

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual limit update logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment limits updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildLimitInput({
    required String label,
    required TextEditingController controller,
    required double currentSpending,
    double? maxLimit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            prefixText: '\$ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a limit';
            }
            final limit = double.tryParse(value);
            if (limit == null) {
              return 'Please enter a valid amount';
            }
            if (limit < currentSpending) {
              return 'Limit cannot be less than current spending';
            }
            if (maxLimit != null && limit > maxLimit) {
              return 'Cannot exceed maximum limit of \$${maxLimit.toStringAsFixed(2)}';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        // Progress indicator for current spending
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Spending',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '\$${currentSpending.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: currentSpending / double.parse(controller.text),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                currentSpending / double.parse(controller.text) > 0.8
                    ? Colors.orange
                    : Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const BrandedAppBar(
        title: 'Payment Limits',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLimitSection(
                  title: 'Internal Transfer Limits',
                  description: 'Set limits for transfers between QuikTransfer users',
                  children: [
                    _buildLimitInput(
                      label: 'Daily Limit',
                      controller: _dailyInternalController,
                      currentSpending: _currentSpending['dailyInternal']!,
                    ),
                    const SizedBox(height: 16),
                    _buildLimitInput(
                      label: 'Weekly Limit',
                      controller: _weeklyInternalController,
                      currentSpending: _currentSpending['weeklyInternal']!,
                      maxLimit: double.parse(_monthlyInternalController.text) / 4,
                    ),
                    const SizedBox(height: 16),
                    _buildLimitInput(
                      label: 'Monthly Limit',
                      controller: _monthlyInternalController,
                      currentSpending: _currentSpending['monthlyInternal']!,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildLimitSection(
                  title: 'External Transfer Limits',
                  description: 'Set limits for transfers to external bank accounts',
                  children: [
                    _buildLimitInput(
                      label: 'Daily Limit',
                      controller: _dailyExternalController,
                      currentSpending: _currentSpending['dailyExternal']!,
                    ),
                    const SizedBox(height: 16),
                    _buildLimitInput(
                      label: 'Weekly Limit',
                      controller: _weeklyExternalController,
                      currentSpending: _currentSpending['weeklyExternal']!,
                      maxLimit: double.parse(_monthlyExternalController.text) / 4,
                    ),
                    const SizedBox(height: 16),
                    _buildLimitInput(
                      label: 'Monthly Limit',
                      controller: _monthlyExternalController,
                      currentSpending: _currentSpending['monthlyExternal']!,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Warning text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[800]),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Changes to payment limits may take up to 24 hours to take effect. Lower limits are processed immediately.',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}