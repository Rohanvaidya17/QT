class TransactionModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;    
  final String receiverName;  
  final double amount;
  final DateTime timestamp;
  final String type;         // 'sent' or 'received'
  final String status;       // 'completed', 'pending', 'failed'
  final String? note;

  TransactionModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.timestamp,
    required this.type,
    this.status = 'completed',
    this.note,
  });

  // Create a Transaction from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      amount: json['amount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      status: json['status'] as String? ?? 'completed',
      note: json['note'] as String?,
    );
  }

  // Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'status': status,
      'note': note,
    };
  }

  // Helper method to format transaction text
  String getDisplayText(String currentUserId) {
    if (senderId == currentUserId) {
      return 'Sent \$$amount to $receiverName';
    } else {
      return 'Received \$$amount from $senderName';
    }
  }

  // Helper method to format transaction amount with sign
  String getFormattedAmount(String currentUserId) {
    final sign = senderId == currentUserId ? '-' : '+';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  // Helper method to check if transaction is pending
  bool get isPending => status == 'pending';

  // Helper method to check if transaction is failed
  bool get isFailed => status == 'failed';

  // Helper method to check if transaction is completed
  bool get isCompleted => status == 'completed';

  // Create a copy of this transaction with modified fields
  TransactionModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    double? amount,
    DateTime? timestamp,
    String? type,
    String? status,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, senderId: $senderId, receiverId: $receiverId, '
           'senderName: $senderName, receiverName: $receiverName, amount: $amount, '
           'timestamp: $timestamp, type: $type, status: $status, note: $note)';
  }
}