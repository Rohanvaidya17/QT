// lib/screens/profile/profile_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/models/user_model.dart';
import 'package:qt_qt/providers/user_provider.dart';
import 'package:qt_qt/route_names.dart';

class ProfileManagementScreen extends StatelessWidget {
  const ProfileManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.user;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 24),
                _buildVerificationStatus(context, user),
                const SizedBox(height: 24),
                _buildProfileActions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _handleProfilePictureTap(context),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: user.profilePicture == null
                      ? Text(
                          user.firstName[0] + user.lastName[0],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.editProfile,
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Account Verification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildVerificationItem(
            icon: Icons.email,
            title: 'Email',
            subtitle: user.email,
            isVerified: user.isEmailVerified,
            onVerify: () => _handleEmailVerification(context),
          ),
          const Divider(height: 24),
          _buildVerificationItem(
            icon: Icons.phone,
            title: 'Phone',
            subtitle: user.phoneNumber,
            isVerified: user.isPhoneVerified,
            onVerify: () => _handlePhoneVerification(context),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isVerified,
    required VoidCallback onVerify,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.teal),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
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
        if (isVerified)
          Icon(
            Icons.verified,
            color: Colors.green,
          )
        else
          TextButton(
            onPressed: onVerify,
            child: const Text('Verify'),
          ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.security,
            title: 'Security',
            subtitle: 'Password, 2FA, and security settings',
            onTap: () => Navigator.pushNamed(context, RouteNames.security),
          ),
          const Divider(height: 24),
          _buildActionTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Configure notification preferences',
            onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
          ),
          const Divider(height: 24),
          _buildActionTile(
            icon: Icons.privacy_tip,
            title: 'Privacy',
            subtitle: 'Manage your privacy settings',
            onTap: () => Navigator.pushNamed(context, RouteNames.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.teal),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _handleProfilePictureTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                // TODO: Implement gallery picker
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                // TODO: Implement camera picker
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleEmailVerification(BuildContext context) {
    // TODO: Implement email verification
  }

  void _handlePhoneVerification(BuildContext context) {
    // TODO: Implement phone verification
  }
}