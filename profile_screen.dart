import 'package:flutter/material.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BrandedAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, RouteNames.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Student Profile Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal[100],
                    child: const Text(
                      'RV',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Rohan Vaidya',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'York University',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () => Navigator.pushNamed(context, RouteNames.qrCode),
                  ),
                ],
              ),
            ),

            // Account & Security Section
            _buildSection([
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Account Info',
                onTap: () => Navigator.pushNamed(context, RouteNames.information),
              ),
              _buildMenuItem(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () => Navigator.pushNamed(context, RouteNames.security),
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Data and Privacy',
                onTap: () => Navigator.pushNamed(context, RouteNames.privacyPolicy),
              ),
              _buildMenuItem(
                icon: Icons.notifications_none_outlined,
                title: 'Notification Preferences',
                onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
              ),
            ]),

            // Features Section
            _buildSection([
              _buildMenuItem(
                icon: Icons.school_outlined,
                title: 'Campus Offers',
                onTap: () => Navigator.pushNamed(context, RouteNames.campusOffers),
              ),
              _buildMenuItem(
                icon: Icons.message_outlined,
                title: 'Message Center',
                onTap: () => Navigator.pushNamed(context, RouteNames.messages),
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () => Navigator.pushNamed(context, RouteNames.help),
              ),
            ]),

            // Account Management Section
            _buildSection([
              _buildMenuItem(
                icon: Icons.delete_outline,
                title: 'Close Account',
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Close Account'),
                      content: const Text(
                        'Are you sure you want to close your account? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.welcome,
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Close Account',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.welcome,
                    (route) => false,
                  );
                },
              ),
            ]),

            // Legal Agreement and Version
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.privacyPolicy,
                    ),
                    child: const Text(
                      'Legal Agreements',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
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

  Widget _buildSection(List<Widget> children) {
    return Container(
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
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}