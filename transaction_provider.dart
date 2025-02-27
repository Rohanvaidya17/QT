import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => [..._transactions];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      _transactions.insert(0, transaction); // Add to start of list
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add transaction: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserTransactions(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      
      _transactions = [
        TransactionModel(
          id: '1',
          senderId: userId,
          receiverId: 'user2',
          senderName: 'You',
          receiverName: 'Razzak',
          amount: 50,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: 'sent',
        ),
        TransactionModel(
          id: '2',
          senderId: 'user3',
          receiverId: userId,
          senderName: 'Saanvi',
          receiverName: 'You',
          amount: 20,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: 'received',
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load transactions: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  double getUserBalance(String userId) {
    double totalReceived = _transactions
        .where((t) => t.receiverId == userId)
        .fold(0, (sum, t) => sum + t.amount);
    
    double totalSent = _transactions
        .where((t) => t.senderId == userId)
        .fold(0, (sum, t) => sum + t.amount);

    return totalReceived - totalSent;
  }

  void clearTransactions() {
    _transactions = [];
    _error = null;
    notifyListeners();
  }
}