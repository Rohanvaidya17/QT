    // main_navigation.dart
    import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import 'package:qt_qt/providers/user_provider.dart';
    import 'package:qt_qt/providers/transaction_provider.dart';
    import 'package:qt_qt/route_names.dart';
    import 'package:qt_qt/Screens/home_screen.dart';
    import 'package:qt_qt/Screens/messages_screen.dart';
    import 'package:qt_qt/Screens/contacts_screen.dart';
    import 'package:qt_qt/Screens/transactions_screen.dart';
    import 'package:qt_qt/Screens/send_request_screen.dart';

    final GlobalKey<_MainNavigationState> mainNavigationKey = GlobalKey<_MainNavigationState>();

    class MainNavigation extends StatefulWidget {
      const MainNavigation({Key? key}) : super(key: key);

      @override
      _MainNavigationState createState() => _MainNavigationState();
    }

    class _MainNavigationState extends State<MainNavigation> {
      int _currentIndex = 0;

      final List<Widget> _pages = [
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return HomeScreen();
          },
        ),
        Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            return TransactionsScreen();
          },
        ),
        SendRequestScreen(),
        ContactsScreen(isInBottomNav: true),
      ];

      void _onTabTapped(int index) {
        setState(() {
          _currentIndex = index;
        });
      }

      void switchToHome() {
        setState(() {
          _currentIndex = 0;
        });
      }

      @override
      Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (_currentIndex != 0) {
              setState(() {
                _currentIndex = 0;
              });
              return false;
            }
            return true;
          },
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.send),
                  label: 'Ask/Send',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  label: 'Contacts',
                ),
              ],
            ),
          ),
        );
      }
    }