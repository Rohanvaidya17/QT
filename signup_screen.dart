import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/theme/app_theme.dart';
import 'package:qt_qt/utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isLoading = false;
  bool _isSocialLoading = false;

  // Form Keys
  final _stepOneFormKey = GlobalKey<FormState>();
  final _stepTwoFormKey = GlobalKey<FormState>();
  final _stepThreeFormKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Nodes
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Weak';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _setupFocusNodeListeners();
  }

  void _setupFocusNodeListeners() {
    _firstNameFocus.addListener(() {
      setState(() {}); // Rebuild to update focus styling
    });
    _lastNameFocus.addListener(() {
      setState(() {});
    });
    _emailFocus.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });
    _confirmPasswordFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose focus nodes
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

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
      color = Colors.green.shade400;
    } else if (strength > 0.5) {
      text = 'Good';
      color = Colors.yellow.shade700;
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
    bool isValid = false;
    
    switch (_currentStep) {
      case 1:
        isValid = _stepOneFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = _stepTwoFormKey.currentState?.validate() ?? false;
        break;
      case 3:
        isValid = _stepThreeFormKey.currentState?.validate() ?? false;
        break;
    }

    if (isValid && _currentStep < _totalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSocialSignup(String provider) async {
    if (_isSocialLoading) return;

    setState(() => _isSocialLoading = true);
    
    try {
      // TODO: Implement actual social sign up logic
      await Future.delayed(const Duration(seconds: 2));
      
      // For demonstration, show success and navigate
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to sign up with $provider. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSocialLoading = false);
      }
    }
  }

  Future<void> _handleSignup() async {
    if (_isLoading) return;

    if (_stepThreeFormKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        // TODO: Implement actual signup logic
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Failed to create account. Please try again.');
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isSocialLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: backgroundColor == Colors.white
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide.none,
          ),
        ),
        icon: _isSocialLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration({
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              minHeight: 2,
            ),

            // Back Button and Step Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previousStep,
                    )
                  else
                    const SizedBox(width: 40),
                  Text(
                    'Step $_currentStep of $_totalSteps',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Form Steps
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalInfoStep(),
                  _buildContactInfoStep(),
                  _buildPasswordStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _stepOneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create your account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your details to get started',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _firstNameController,
              focusNode: _firstNameFocus,
              decoration: _getInputDecoration(
                label: 'First Name',
                prefixIcon: Icons.person_outline,
              ),
              textInputAction: TextInputAction.next,
              validator: (value) => Validators.validateName(value),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _lastNameController,
              focusNode: _lastNameFocus,
              decoration: _getInputDecoration(
                label: 'Last Name',
                prefixIcon: Icons.person_outline,
              ),
              textInputAction: TextInputAction.done,
              validator: (value) => Validators.validateName(value),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),

            _buildSocialButton(
              'Continue with Google',
              Icons.g_mobiledata,
              () => _handleSocialSignup('google'),
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              'Continue with Apple',
              Icons.apple,
              () => _handleSocialSignup('apple'),
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
            const SizedBox(height: 24),

            const Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
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

  Widget _buildContactInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _stepTwoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'How can we reach you?',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              decoration: _getInputDecoration(
                label: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              textInputAction: TextInputAction.next,
              validator: (value) => Validators.validateEmail(value),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              decoration: _getInputDecoration(
                label: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
              ),
              textInputAction: TextInputAction.done,
              validator: (value) => Validators.validatePhone(value),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
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

  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _stepThreeFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Secure your account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a strong password',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: _obscurePassword,
              decoration: _getInputDecoration(
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
              onChanged: _updatePasswordStrength,
              validator: (value) => Validators.validatePassword(value),
            ),
            const SizedBox(height: 8),

            // Password Strength Indicator
            LinearProgressIndicator(
              value: _passwordStrength,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Password Strength: $_passwordStrengthText',
              style: TextStyle(
                color: _passwordStrengthColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              obscureText: _obscureConfirmPassword,
              decoration: _getInputDecoration(
                label: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

            // Terms and Privacy
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text.rich(
                TextSpan(
                  text: 'By creating an account, you agree to our ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.teal[700],
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RouteNames.privacyPolicy);
                        },
                    ),
                    const TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.teal[700],
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RouteNames.privacyPolicy);
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, RouteNames.login);
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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