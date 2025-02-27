// lib/models/reminder_model.dart
class ReminderModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;
  final double amount;
  final DateTime dueDate;
  final String status; // 'pending', 'completed', 'cancelled'
  final String? note;
  final bool isPaid;

  ReminderModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.dueDate,
    this.status = 'pending',
    this.note,
    this.isPaid = false,
  });

  // Create a Reminder from JSON
  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String? ?? 'pending',
      note: json['note'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
    );
  }

  // Convert Reminder to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'note': note,
      'isPaid': isPaid,
    };
  }

  // Helper method to format reminder text
  String getDisplayText(String currentUserId) {
    if (senderId == currentUserId) {
      return 'You requested \$$amount from $receiverName';
    } else {
      return '$senderName requested \$$amount from you';
    }
  }

  // Helper method to check if reminder is overdue
  bool isOverdue() {
    return !isPaid && dueDate.isBefore(DateTime.now());
  }

  // Create a copy of this reminder with modified fields
  ReminderModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    double? amount,
    DateTime? dueDate,
    String? status,
    String? note,
    bool? isPaid,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      note: note ?? this.note,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}