// lib/providers/reminder_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/reminder_model.dart';

class ReminderProvider with ChangeNotifier {
  List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _error;

  List<ReminderModel> get reminders => [..._reminders];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get pending reminders
  List<ReminderModel> get pendingReminders {
    return _reminders.where((reminder) => 
      reminder.status == 'pending' && !reminder.isPaid).toList();
  }

  // Get completed reminders
  List<ReminderModel> get completedReminders {
    return _reminders.where((reminder) => 
      reminder.status == 'completed' || reminder.isPaid).toList();
  }

  // Get overdue reminders
  List<ReminderModel> get overdueReminders {
    return _reminders.where((reminder) => 
      !reminder.isPaid && reminder.dueDate.isBefore(DateTime.now())).toList();
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      _reminders.insert(0, reminder);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add reminder: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserReminders(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for the demo
      _reminders = [
        ReminderModel(
          id: '1',
          senderId: 'user2',
          receiverId: userId,
          senderName: 'Rohan',
          receiverName: 'You',
          amount: 50.0,
          dueDate: DateTime.now().add(const Duration(days: 1)),
          note: 'Dinner split'
        ),
        ReminderModel(
          id: '2',
          senderId: userId,
          receiverId: 'user3',
          senderName: 'You',
          receiverName: 'Saanvi',
          amount: 30.0,
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
          note: 'Movie tickets'
        ),
        ReminderModel(
          id: '3',
          senderId: 'user4',
          receiverId: userId,
          senderName: 'Shau',
          receiverName: 'You',
          amount: 20.0,
          dueDate: DateTime.now().add(const Duration(days: 3)),
          note: 'Groceries'
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load reminders: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markAsPaid(String reminderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      final index = _reminders.indexWhere((r) => r.id == reminderId);
      if (index >= 0) {
        _reminders[index] = _reminders[index].copyWith(
          isPaid: true,
          status: 'completed'
        );
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to mark reminder as paid: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      _reminders.removeWhere((r) => r.id == reminderId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete reminder: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

    void clearReminders() {
      _reminders = [];
      _error = null;
      notifyListeners();
    }
  }