import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class TransactionPinScreen extends StatefulWidget {
  final bool isChangingPin;

  const TransactionPinScreen({
    Key? key,
    this.isChangingPin = false,
  }) : super(key: key);

  @override
  _TransactionPinScreenState createState() => _TransactionPinScreenState();
}

class _TransactionPinScreenState extends State<TransactionPinScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for PIN input
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _isLoading = false;
  bool _showCurrentPin = false;
  bool _showNewPin = false;
  bool _showConfirmPin = false;

  // Focus nodes for managing input flow
  late List<FocusNode> _currentPinFocusNodes;
  late List<FocusNode> _newPinFocusNodes;
  late List<FocusNode> _confirmPinFocusNodes;

  @override
  void initState() {
    super.initState();
    _currentPinFocusNodes = List.generate(6, (_) => FocusNode());
    _newPinFocusNodes = List.generate(6, (_) => FocusNode());
    _confirmPinFocusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    
    for (var node in [..._currentPinFocusNodes, ..._newPinFocusNodes, ..._confirmPinFocusNodes]) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual PIN change/set logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (!mounted) return;

      // Show success dialog
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
              Text(
                widget.isChangingPin ? 'PIN Changed!' : 'PIN Set!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isChangingPin
                    ? 'Your transaction PIN has been updated successfully.'
                    : 'Your transaction PIN has been set successfully.',
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
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPinRow(
    TextEditingController controller,
    List<FocusNode> focusNodes,
    bool showPin,
    String label,
    {bool isLast = false}
  ) {
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
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 50,
              child: TextFormField(
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                obscureText: !showPin,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 5) {
                      focusNodes[index + 1].requestFocus();
                    } else if (!isLast) {
                      // Move to first field of next PIN row
                      _newPinFocusNodes[0].requestFocus();
                    }
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandedAppBar(
        title: widget.isChangingPin ? 'Change Transaction PIN' : 'Set Transaction PIN',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isChangingPin
                      ? 'Enter your current PIN and set a new 6-digit PIN for transactions.'
                      : 'Set a 6-digit PIN to secure your transactions.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                if (widget.isChangingPin) ...[
                  _buildPinRow(
                    _currentPinController,
                    _currentPinFocusNodes,
                    _showCurrentPin,
                    'Current PIN'
                  ),
                  const SizedBox(height: 24),
                ],

                _buildPinRow(
                  _newPinController,
                  _newPinFocusNodes,
                  _showNewPin,
                  widget.isChangingPin ? 'New PIN' : 'Enter PIN'
                ),
                const SizedBox(height: 24),

                _buildPinRow(
                  _confirmPinController,
                  _confirmPinFocusNodes,
                  _showConfirmPin,
                  'Confirm PIN',
                  isLast: true
                ),
                const SizedBox(height: 24),

                // PIN Requirements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PIN Requirements:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('• Must be 6 digits'),
                      Text('• Cannot contain sequential numbers (e.g., 123456)'),
                      Text('• Cannot contain repeated numbers (e.g., 111111)'),
                      Text('• Cannot be your birth year'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
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
                        : Text(widget.isChangingPin ? 'Change PIN' : 'Set PIN'),
                  ),
                ),

                // Warning Text
                if (!widget.isChangingPin) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Important: Remember this PIN as it will be required for all transactions. Do not share it with anyone.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}