import 'package:flutter/material.dart';
import 'package:qt_qt/Screens/chat_detail_screen.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> chats = [
    {
      "id": "1",
      "name": "Razzak",
      "lastMessage": "Thanks for the payment!",
      "timestamp": "10:30 AM",
      "profileColor": Colors.blue,
      "unreadCount": 2,
      "isOnline": true,
      "type": "payment",
      "amount": "\$50.00"
    },
    {
      "id": "2",
      "name": "Saanvi",
      "lastMessage": "Sent you \$20",
      "timestamp": "Yesterday",
      "profileColor": Colors.green,
      "unreadCount": 0,
      "isOnline": false,
      "type": "payment",
      "amount": "\$20.00"
    },
    {
      "id": "3",
      "name": "Shau",
      "lastMessage": "When can you pay me back?",
      "timestamp": "2 days ago",
      "profileColor": Colors.orange,
      "unreadCount": 1,
      "isOnline": true,
      "type": "request",
      "amount": "\$35.00"
    },
  ];

  List<Map<String, dynamic>> get filteredChats {
    if (_selectedFilter == 'all') return chats;
    return chats.where((chat) => chat['type'] == _selectedFilter).toList();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: BrandedAppBar(
      title: 'Messages',
      showBackButton: false, // Since this is a main tab screen
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: _showOptionsMenu,
        ),
      ],
    ),
    body: Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: filteredChats.isEmpty
              ? _buildEmptyState()
              : _buildChatList(),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/contacts');
      },
      backgroundColor: Colors.teal,
      child: const Icon(Icons.message),
    ),
  );
}

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search messages...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                _buildFilterChip('Payments', 'payment'),
                _buildFilterChip('Requests', 'request'),
              ],
            ),
          ),
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
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.teal[100],
        checkmarkColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _selectedFilter == value ? Colors.teal : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatTile(chat);
      },
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
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
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(contactName: chat["name"]),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: chat["profileColor"].withOpacity(0.2),
              child: Text(
                chat["name"][0],
                style: TextStyle(
                  color: chat["profileColor"],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (chat["isOnline"])
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(
              chat["name"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (chat["type"] == "payment" || chat["type"] == "request")
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: chat["type"] == "payment" ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  chat["amount"],
                  style: TextStyle(
                    color: chat["type"] == "payment" ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat["lastMessage"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: chat["unreadCount"] > 0 ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chat["timestamp"],
              style: TextStyle(
                color: chat["unreadCount"] > 0 ? Colors.teal : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (chat["unreadCount"] > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat["unreadCount"].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mark_chat_read),
              title: const Text('Mark all as read'),
              onTap: () {
                Navigator.pop(context);
                // Implement mark all as read functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('Archived chats'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to archived chats
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}