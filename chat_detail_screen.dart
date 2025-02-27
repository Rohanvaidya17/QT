import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String contactName;
  
  const ChatDetailScreen({
    Key? key,
    required this.contactName,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> messages = [
    {
      "id": "1",
      "content": "Hey, can you send me the money for dinner?",
      "isSentByMe": false,
      "timestamp": "2:30 PM",
      "type": "text",
    },
    {
      "id": "2",
      "content": "Request for dinner payment",
      "isSentByMe": false,
      "timestamp": "2:31 PM",
      "type": "request",
      "amount": "25.50",
    },
    {
      "id": "3",
      "content": "Sure, sending it now!",
      "isSentByMe": true,
      "timestamp": "2:32 PM",
      "type": "text",
    },
    {
      "id": "4",
      "content": "Payment sent",
      "isSentByMe": true,
      "timestamp": "2:33 PM",
      "type": "payment",
      "amount": "25.50",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal.shade100,
              child: Text(
                widget.contactName[0],
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.contactName,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return Align(
      alignment: message["isSentByMe"] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message["isSentByMe"] ? Colors.teal[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message["type"] != "text") ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    message["type"] == "payment" 
                        ? Icons.payment 
                        : Icons.request_page,
                    size: 16,
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "\$${message["amount"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(message["content"]),
            const SizedBox(height: 4),
            Text(
              message["timestamp"],
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_money, color: Colors.teal),
              onPressed: () {
                // Show payment/request options
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.teal),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  setState(() {
                    messages.add({
                      "id": DateTime.now().toString(),
                      "content": _messageController.text,
                      "isSentByMe": true,
                      "timestamp": "${DateTime.now().hour}:${DateTime.now().minute}",
                      "type": "text",
                    });
                    _messageController.clear();
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}