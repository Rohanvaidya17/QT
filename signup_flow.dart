// lib/screens/auth/signup_flow.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qt_qt/widgets/otp_input.dart';
import 'package:qt_qt/utils/validators.dart';

class SignupFlow extends StatefulWidget {
  const SignupFlow({Key? key}) : super(key: key);

  @override
  _SignupFlowState createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isLoading = false;

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form Keys
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Verification States
  bool _isPhoneVerified = false;
  bool _isEmailVerified = false;
  bool _isPhoneOTPSent = false;
  bool _isEmailOTPSent = false;
  bool _acceptedTerms = false;

  // Password States
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Weak';
  Color _passwordStrengthColor = Colors.red;

  // User Data Storage
  Map<String, dynamic> userData = {};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    double strength = 0;
    String text = 'Weak';
    Color color = Colors.red;

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    if (strength == 1) {
      text = 'Very Strong';
      color = Colors.green;
    } else if (strength > 0.75) {
      text = 'Strong';
      color = Colors.green[400]!;
    } else if (strength > 0.5) {
      text = 'Good';
      color = Colors.yellow[700]!;
    } else if (strength > 0.25) {
      text = 'Fair';
      color = Colors.orange;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Email Verification';
      case 2:
        return 'Phone Verification';
      case 3:
        return 'Set Password';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          _previousStep();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _previousStep,
          ),
          title: const Text(
            'Create Account',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Progress Indicator
                LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),

                // Step Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Step ${_currentStep + 1} of $_totalSteps: ${_getStepTitle(_currentStep)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),

                // Form Steps
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildBasicInfoStep(),
                      _buildEmailVerificationStep(),
                      _buildPhoneVerificationStep(),
                      _buildPasswordStep(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Step Builders
  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _basicInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide your basic information',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            
            // Full Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validators.validateName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_basicInfoFormKey.currentState!.validate()) {
                    userData['name'] = _nameController.text;
                    _nextStep();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailVerificationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email address to receive a verification code',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            // Email Input
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isEmailVerified,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email address',
                prefixIcon: const Icon(Icons.email_outlined),
                suffixIcon: _isEmailVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 24),

            // Send OTP Button
            if (!_isEmailOTPSent && !_isEmailVerified)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailFormKey.currentState!.validate()) {
                      _sendEmailOTP();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Send Verification Code'),
                ),
              ),

            // OTP Input Section
            if (_isEmailOTPSent && !_isEmailVerified) ...[
              const SizedBox(height: 32),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a code to ${_emailController.text}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              OTPInput(
                onCompleted: _verifyEmailOTP,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _sendEmailOTP,
                  child: const Text('Resend Code'),
                ),
              ),
            ],

            // Continue Button
            if (_isEmailVerified) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    userData['email'] = _emailController.text;
                    _nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneVerificationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _phoneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phone Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your phone number for secure transactions',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            // Phone Input
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_isPhoneVerified,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '(XXX) XXX-XXXX',
                prefixIcon: const Icon(Icons.phone_outlined),
                prefixText: '+1 ',
                suffixIcon: _isPhoneVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 24),

            // Send OTP Button
            if (!_isPhoneOTPSent && !_isPhoneVerified)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_phoneFormKey.currentState!.validate()) {
                      _sendPhoneOTP();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Send Verification Code'),
                ),
              ),

            // OTP Input Section
            if (_isPhoneOTPSent && !_isPhoneVerified) ...[
              const SizedBox(height: 32),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a code to +1 ${_formatPhoneNumber(_phoneController.text)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              OTPInput(
                onCompleted: _verifyPhoneOTP,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _sendPhoneOTP,
                  child: const Text('Resend Code'),
                ),
              ),
            ],
            // Continue Button (part of phone verification step)
            if (_isPhoneVerified) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    userData['phone'] = _phoneController.text;
                    _nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a strong password to secure your account',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _updatePasswordStrength,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: 16),

            // Password Strength Indicator
            LinearProgressIndicator(
              value: _passwordStrength,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: _passwordStrengthColor),
                const SizedBox(width: 8),
                Text(
                  'Password Strength: $_passwordStrengthText',
                  style: TextStyle(
                    color: _passwordStrengthColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 24),

            // Terms and Conditions
            CheckboxListTile(
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
              title: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(color: Colors.grey[700]),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.teal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.teal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _acceptedTerms ? _handleSignup : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _formatPhoneNumber(String value) {
    if (value.length == 10) {
      return '(${value.substring(0, 3)}) ${value.substring(3, 6)}-${value.substring(6)}';
    }
    return value;
  }

  // Verification Methods
  void _sendEmailOTP() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isEmailOTPSent = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyEmailOTP(String otp) async {
    setState(() => _isLoading = true);

    try {
      // Simulate API verification
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isEmailVerified = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendPhoneOTP() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isPhoneOTPSent = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent to your phone'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyPhoneOTP(String otp) async {
    setState(() => _isLoading = true);

    try {
      // Simulate API verification
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isPhoneVerified = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone verified successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSignup() async {
    if (_passwordFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Add password to user data
        userData['password'] = _passwordController.text;

        setState(() => _isLoading = false);

        // Navigate to success screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/signup-success',
          (route) => false,
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}