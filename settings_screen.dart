// lib/screens/profile/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/providers/user_provider.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Account',
            children: [
              _buildSettingTile(
                icon: Icons.person,
                title: 'Profile',
                onTap: () => Navigator.pushNamed(context, RouteNames.profile),
              ),
              _buildSettingTile(
                icon: Icons.security,
                title: 'Security',
                onTap: () => Navigator.pushNamed(context, RouteNames.security),
              ),
              _buildSettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
              ),
            ],
          ),
          _buildSection(
            title: 'Preferences',
            children: [
              _buildSettingTile(
                icon: Icons.language,
                title: 'Language',
                onTap: () => _showLanguageSelector(context),
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) => SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Support',
            children: [
              _buildSettingTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () => Navigator.pushNamed(context, RouteNames.help),
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () => Navigator.pushNamed(context, RouteNames.privacyPolicy),
              ),
              _buildSettingTile(
                icon: Icons.info,
                title: 'About',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          _buildSection(
            title: 'Account Actions',
            children: [
              _buildSettingTile(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () => _showLogoutConfirmation(context),
                textColor: Colors.red,
              ),
              _buildSettingTile(
                icon: Icons.delete,
                title: 'Delete Account',
                onTap: () => _showDeleteAccountConfirmation(context),
                textColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: const Icon(Icons.check),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Spanish'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('French'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About QuikTransfer'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QuikTransfer'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('A secure and easy way to transfer money between friends and family.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement logout logic
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.login,
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            Text('All your data will be permanently deleted.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement account deletion logic
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.welcome,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}