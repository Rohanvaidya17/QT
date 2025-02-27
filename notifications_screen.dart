import 'package:flutter/material.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

enum NotificationType {
  transaction,
  payment,
  security,
  account,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Money Received',
      message: 'Received \$50.00 from Razzak',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.transaction,
      data: {'transactionId': '123', 'amount': 50.00},
    ),
    NotificationItem(
      id: '2',
      title: 'Security Alert',
      message: 'New device logged into your account',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.security,
    ),
    NotificationItem(
      id: '3',
      title: 'Payment Request',
      message: 'Saanvi requested \$30.00',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.payment,
      data: {'requestId': '456', 'amount': 30.00},
    ),
  ];

  String _selectedFilter = 'all';

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: BrandedAppBar(
      title: 'Notifications',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: _showNotificationSettings,
        ),
        if (_notifications.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.black),
            onPressed: _markAllAsRead,
          ),
      ],
    ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Transactions', 'transaction'),
          _buildFilterChip('Payments', 'payment'),
          _buildFilterChip('Security', 'security'),
          _buildFilterChip('Account', 'account'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = selected ? value : 'all';
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.teal[100],
        checkmarkColor: Colors.teal,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final filteredNotifications = _notifications.where((notification) {
      if (_selectedFilter == 'all') return true;
      return notification.type.toString().split('.').last == _selectedFilter;
    }).toList();

    return ListView.builder(
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((item) => item.id == notification.id);
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: _getNotificationColor(notification.type),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification.type),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight:
                              notification.isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.transaction:
        icon = Icons.payment;
        color = Colors.green;
        break;
      case NotificationType.payment:
        icon = Icons.attach_money;
        color = Colors.blue;
        break;
      case NotificationType.security:
        icon = Icons.security;
        color = Colors.red;
        break;
      case NotificationType.account:
        icon = Icons.account_circle;
        color = Colors.orange;
        break;
      case NotificationType.system:
        icon = Icons.info;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.transaction:
        return Colors.green;
      case NotificationType.payment:
        return Colors.blue;
      case NotificationType.security:
        return Colors.red;
      case NotificationType.account:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Mark as read
    setState(() {
      final index = _notifications.indexOf(notification);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          type: notification.type,
          isRead: true,
          data: notification.data,
        );
      }
    });

    // Handle notification action based on type
    switch (notification.type) {
      case NotificationType.transaction:
        if (notification.data != null) {
          // Navigate to transaction details
          Navigator.pushNamed(
            context,
            '/transactions',
            arguments: notification.data!['transactionId'],
          );
        }
        break;
      case NotificationType.payment:
        if (notification.data != null) {
          // Navigate to payment request
          Navigator.pushNamed(
            context,
            '/payment_request',
            arguments: notification.data!['requestId'],
          );
        }
        break;
      case NotificationType.security:
        // Navigate to security settings
        Navigator.pushNamed(context, '/security');
        break;
      default:
        break;
    }
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsSwitch(
              'Transaction Alerts',
              'Get notified about all transactions',
              true,
            ),
            _buildSettingsSwitch(
              'Payment Requests',
              'Receive payment request notifications',
              true,
            ),
            _buildSettingsSwitch(
              'Security Alerts',
              'Important security notifications',
              true,
            ),
            _buildSettingsSwitch(
              'Account Updates',
              'Updates about your account',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSwitch(String title, String subtitle, bool value) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (bool value) {
        // Implement settings change
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((notification) {
        return NotificationItem(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          type: notification.type,
          isRead: true,
          data: notification.data,
        );
      }).toList();
    });
  }
}