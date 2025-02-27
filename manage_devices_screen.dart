import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({Key? key}) : super(key: key);

  @override
  _ManageDevicesScreenState createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  bool _isLoading = false;
  
  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  final List<Map<String, dynamic>> _devices = [
    {
      'id': '1',
      'name': 'iPhone 13 Pro',
      'type': 'Mobile',
      'lastActive': DateTime.now(),
      'location': 'Toronto, Canada',
      'isCurrentDevice': true,
      'loginDate': DateTime.now().subtract(const Duration(days: 30)),
      'deviceInfo': 'iOS 15.4',
    },
    {
      'id': '2',
      'name': 'MacBook Pro', 
      'type': 'Desktop',
      'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
      'location': 'Toronto, Canada',
      'isCurrentDevice': false,
      'loginDate': DateTime.now().subtract(const Duration(days: 15)),
      'deviceInfo': 'macOS Monterey',
    },
    {
      'id': '3',
      'name': 'Samsung Galaxy S21',
      'type': 'Mobile', 
      'lastActive': DateTime.now().subtract(const Duration(days: 1)),
      'location': 'Montreal, Canada',
      'isCurrentDevice': false,
      'loginDate': DateTime.now().subtract(const Duration(days: 5)),
      'deviceInfo': 'Android 12',
    },
  ];

  Future<void> _handleLogoutDevice(Map<String, dynamic> device) async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        if (!device['isCurrentDevice']) {
          _devices.removeWhere((d) => d['id'] == device['id']);
        }
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device logged out successfully'),
          backgroundColor: Colors.green,
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

  Future<void> _handleLogoutAllDevices() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout All Devices'),
        content: const Text('This will log out all devices except your current one. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout All'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _devices.removeWhere((device) => !device['isCurrentDevice']);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All devices have been logged out'),
          backgroundColor: Colors.green,
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

  void _showDeviceDetails(Map<String, dynamic> device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Device Type', device['type']),
            _buildDetailRow('Location', device['location']),
            _buildDetailRow(
              'Last Active',
              DateFormat('MMM dd, yyyy HH:mm').format(device['lastActive']),
            ),
            _buildDetailRow(
              'First Login',
              DateFormat('MMM dd, yyyy').format(device['loginDate']),
            ),
            _buildDetailRow('Device Info', device['deviceInfo']),
            const SizedBox(height: 24),
            if (!device['isCurrentDevice'])
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleLogoutDevice(device);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout Device'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showDeviceDetails(device),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  device['type'] == 'Mobile' ? Icons.phone_android : Icons.laptop,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          device['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (device['isCurrentDevice']) ...[
                          const SizedBox(width: 8),
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
                              'Current',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device['location'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last active: ${_getTimeAgo(device['lastActive'])}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showDeviceDetails(device),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: BrandedAppBar(
      title: 'Manage Devices',
      actions: [
        if (_devices.length > 1)
          TextButton.icon(
            onPressed: _isLoading ? null : _handleLogoutAllDevices,
            icon: const Icon(Icons.logout),
            label: const Text('Logout All'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
      ],
    ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Currently Active Devices',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ..._devices.map(_buildDeviceCard).toList(),
              const SizedBox(height: 16),
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
                        'If you notice any suspicious device activity, log out the device immediately and change your password.',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}