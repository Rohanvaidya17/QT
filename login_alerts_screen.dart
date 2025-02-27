import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class LoginAlertsScreen extends StatefulWidget {
  const LoginAlertsScreen({Key? key}) : super(key: key);

  @override
  _LoginAlertsScreenState createState() => _LoginAlertsScreenState();
}

class _LoginAlertsScreenState extends State<LoginAlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _emailAlerts = true;
  bool _pushAlerts = true;
  bool _suspiciousLoginAlerts = true;
  bool _newDeviceAlerts = true;
  bool _locationChangeAlerts = true;

  // Mock login history data
  final List<Map<String, dynamic>> _loginHistory = [
    {
      'id': '1',
      'device': 'iPhone 13 Pro',
      'location': 'Toronto, Canada',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'status': 'success',
      'ip': '192.168.1.1',
      'isCurrent': true,
    },
    {
      'id': '2',
      'device': 'Unknown Device',
      'location': 'Montreal, Canada',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'blocked',
      'ip': '192.168.1.2',
      'isCurrent': false,
    },
    {
      'id': '3',
      'device': 'MacBook Pro',
      'location': 'Toronto, Canada',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'status': 'success',
      'ip': '192.168.1.3',
      'isCurrent': false,
    },
  ];

  // Mock security alerts
  final List<Map<String, dynamic>> _securityAlerts = [
    {
      'id': '1',
      'type': 'suspicious_login',
      'device': 'Unknown Device',
      'location': 'Vancouver, Canada',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'blocked',
      'details': 'Unusual location detected',
      'actionTaken': 'Access blocked automatically',
    },
    {
      'id': '2',
      'type': 'new_device',
      'device': 'Samsung Galaxy S21',
      'location': 'Toronto, Canada',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'approved',
      'details': 'New device added to your account',
      'actionTaken': 'Verified via email',
    },
    {
      'id': '3',
      'type': 'location_change',
      'device': 'iPhone 13 Pro',
      'location': 'Montreal, Canada',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'warning',
      'details': 'Login from new location',
      'actionTaken': 'Verification code sent',
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'blocked':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertTypeIcon(String type) {
    switch (type) {
      case 'suspicious_login':
        return Icons.security;
      case 'new_device':
        return Icons.phone_android;
      case 'location_change':
        return Icons.location_on;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildLoginHistoryItem(Map<String, dynamic> login) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    color: _getStatusColor(login['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    login['status'] == 'success' ? Icons.check_circle : Icons.block,
                    color: _getStatusColor(login['status']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        login['device'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        login['location'],
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
                      DateFormat('HH:mm').format(login['timestamp']),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd').format(login['timestamp']),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.computer,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'IP: ${login['ip']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (login['isCurrent'])
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
                      'Current Session',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
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

  Widget _buildSecurityAlertItem(Map<String, dynamic> alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    color: _getStatusColor(alert['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getAlertTypeIcon(alert['type']),
                    color: _getStatusColor(alert['status']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['details'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${alert['device']} • ${alert['location']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('MMM dd, HH:mm').format(alert['timestamp']),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Action taken: ${alert['actionTaken']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alert Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingSwitch(
            'Email Alerts',
            'Receive alerts via email',
            _emailAlerts,
            (value) => setState(() => _emailAlerts = value),
          ),
          _buildSettingSwitch(
            'Push Notifications',
            'Receive alerts on your device',
            _pushAlerts,
            (value) => setState(() => _pushAlerts = value),
          ),
          const Divider(height: 32),
          const Text(
            'Alert Types',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingSwitch(
            'Suspicious Login Attempts',
            'Alert when unusual login activity is detected',
            _suspiciousLoginAlerts,
            (value) => setState(() => _suspiciousLoginAlerts = value),
          ),
          _buildSettingSwitch(
            'New Device Logins',
            'Alert when a new device accesses your account',
            _newDeviceAlerts,
            (value) => setState(() => _newDeviceAlerts = value),
          ),
          _buildSettingSwitch(
            'Location Changes',
            'Alert when logging in from a new location',
            _locationChangeAlerts,
            (value) => setState(() => _locationChangeAlerts = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: BrandedAppBar(
      title: 'Login Alerts',
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
        tabs: const [
          Tab(text: 'Login History'),
          Tab(text: 'Security Alerts'),
        ],
      ),
    ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Login History Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Recent Login Activity',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ..._loginHistory.map(_buildLoginHistoryItem).toList(),
            ],
          ),

          // Security Alerts Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingsSection(),
              const SizedBox(height: 24),
              Text(
                'Recent Alerts',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ..._securityAlerts.map(_buildSecurityAlertItem).toList(),
            ],
          ),
        ],
      ),
    );
  }
}