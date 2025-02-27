import 'package:flutter/material.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricsEnabled = true;
  bool _smsVerification = true;
  bool _emailVerification = false;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: const BrandedAppBar(
      title: 'Security',
      showBackButton: true,
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityStatusSection(context),
            _buildLoginSecuritySection(context),
            _buildTwoFactorAuthSection(context),
            _buildPaymentSecuritySection(context),
            _buildDeviceSecuritySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityStatusSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Security Status: Strong',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2-factor authentication is enabled',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginSecuritySection(BuildContext context) {
    return _buildSection(
      context,
      'Login Security',
      [
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text('Change Password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.changePassword);
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('Biometric Login'),
          subtitle: const Text('Use fingerprint or face ID'),
          value: _biometricsEnabled,
          onChanged: (value) {
            setState(() {
              _biometricsEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTwoFactorAuthSection(BuildContext context) {
    return _buildSection(
      context,
      'Two-Factor Authentication',
      [
        SwitchListTile(
          secondary: const Icon(Icons.message),
          title: const Text('SMS Verification'),
          subtitle: const Text('Verify login with SMS code'),
          value: _smsVerification,
          onChanged: (value) {
            setState(() {
              _smsVerification = value;
            });
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.email),
          title: const Text('Email Verification'),
          subtitle: const Text('Verify login with email code'),
          value: _emailVerification,
          onChanged: (value) {
            setState(() {
              _emailVerification = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentSecuritySection(BuildContext context) {
    return _buildSection(
      context,
      'Payment Security',
      [
        ListTile(
          leading: const Icon(Icons.lock_clock),
          title: const Text('Transaction PIN'),
          subtitle: const Text('Change your 6-digit PIN'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.transactionPin);
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Payment Limits'),
          subtitle: const Text('Set daily transaction limits'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.paymentLimits);
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_balance),
          title: const Text('Bank Accounts'),
          subtitle: const Text('Manage linked bank accounts'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.bankLinkSecurity);
          },
        ),
      ],
    );
  }

  Widget _buildDeviceSecuritySection(BuildContext context) {
    return _buildSection(
      context,
      'Device Security',
      [
        ListTile(
          leading: const Icon(Icons.phone_android),
          title: const Text('Manage Devices'),
          subtitle: const Text('2 devices connected'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.manageDevices);
          },
        ),
        ListTile(
          leading: const Icon(Icons.security_update_warning),
          title: const Text('Login Alerts'),
          subtitle: const Text('Manage suspicious login alerts'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.loginAlerts);
          },
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}