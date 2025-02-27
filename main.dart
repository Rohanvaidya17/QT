import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/Screens/security/transaction_pin_screen.dart';
import 'package:qt_qt/screens/security/manage_devices_screen.dart';
import 'package:qt_qt/screens/security/login_alerts_screen.dart';
import 'package:qt_qt/screens/security/payment_limits_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qt_qt/utils/app_transitions.dart';

// Import providers
import 'package:qt_qt/providers/transaction_provider.dart';
import 'package:qt_qt/providers/user_provider.dart';
import 'package:qt_qt/theme/app_theme.dart';
import 'package:qt_qt/theme/theme_provider.dart';

// Import all screens
import 'package:qt_qt/main_navigation.dart';
import 'package:qt_qt/route_names.dart';
import 'package:qt_qt/Screens/splash_screen.dart';
import 'package:qt_qt/Screens/welcome_screen.dart';
import 'package:qt_qt/Screens/login_screen.dart';
import 'package:qt_qt/Screens/signup_screen.dart';
import 'package:qt_qt/Screens/bank_account_screen.dart';
import 'package:qt_qt/Screens/contacts_screen.dart';
import 'package:qt_qt/Screens/messages_screen.dart';
import 'package:qt_qt/Screens/privacy_policy_screen.dart';
import 'package:qt_qt/Screens/profile_screen.dart';
import 'package:qt_qt/Screens/send_request_screen.dart';
import 'package:qt_qt/Screens/splitwise_screen.dart';
import 'package:qt_qt/Screens/support_screen.dart';
import 'package:qt_qt/Screens/transactions_screen.dart';
import 'package:qt_qt/Screens/send_balance_screen.dart';
import 'package:qt_qt/Screens/information_screen.dart';
import 'package:qt_qt/Screens/notifications_screen.dart';
import 'package:qt_qt/Screens/help/help_screen.dart';
import 'package:qt_qt/Screens/qr_code_screen.dart';
import 'package:qt_qt/screens/security_screen.dart';
import 'package:qt_qt/screens/campus_offers.dart';
import 'package:qt_qt/screens/forgot_password/forgot_password_screen.dart';
import 'package:qt_qt/screens/forgot_password/verify_reset_code_screen.dart';
import 'package:qt_qt/screens/forgot_password/reset_password_screen.dart';
import 'package:qt_qt/Screens/transaction_flow_screen.dart';
import 'package:qt_qt/screens/settings_screen.dart';
import 'package:qt_qt/screens/edit_profile_screen.dart';
import 'package:qt_qt/screens/security/change_password_screen.dart';
import 'package:qt_qt/screens/security/bank_link_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QuikTransfer',
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: themeProvider.themeMode,
            initialRoute: RouteNames.splash,
            // Custom page transition builder
            onGenerateRoute: (settings) {
              final routes = {
                RouteNames.splash: (context) => SplashScreen(),
                RouteNames.welcome: (context) => WelcomeScreen(),
                RouteNames.login: (context) => LoginScreen(),
                RouteNames.signup: (context) => SignupScreen(),
                RouteNames.home: (context) =>
                    MainNavigation(key: mainNavigationKey),
                RouteNames.transactionFlow: (context) =>
                    TransactionFlowScreen(),
                RouteNames.splitwise: (context) => SplitwiseScreen(),
                RouteNames.messages: (context) => MessagesScreen(),
                RouteNames.profile: (context) => ProfileScreen(),
                RouteNames.sendRequest: (context) => SendRequestScreen(),
                RouteNames.contacts: (context) => ContactsScreen(),
                RouteNames.transactions: (context) => TransactionsScreen(),
                RouteNames.sendBalance: (context) => SendBalanceScreen(),
                RouteNames.qrCode: (context) => QRCodeScreen(),
                RouteNames.privacyPolicy: (context) => PrivacyPolicyScreen(),
                RouteNames.bankAccount: (context) => BankAccountScreen(),
                RouteNames.support: (context) => SupportScreen(),
                RouteNames.information: (context) => InformationScreen(),
                RouteNames.notifications: (context) => NotificationsScreen(),
                RouteNames.help: (context) => HelpScreen(),
                RouteNames.security: (context) => SecurityScreen(),
                RouteNames.campusOffers: (context) => CampusOffersScreen(),
                RouteNames.forgotPassword: (context) => ForgotPasswordScreen(),
                RouteNames.verifyResetCode: (context) =>
                    VerifyResetCodeScreen(email: ''),
                RouteNames.resetPassword: (context) => ResetPasswordScreen(),
                RouteNames.settings: (context) => SettingsScreen(),
                RouteNames.editProfile: (context) => EditProfileScreen(),
                RouteNames.transactionPin: (context) => TransactionPinScreen(),
                RouteNames.manageDevices: (context) => ManageDevicesScreen(),
                RouteNames.loginAlerts: (context) => LoginAlertsScreen(),
                RouteNames.paymentLimits: (context) => PaymentLimitsScreen(),
                RouteNames.changePassword: (context) => ChangePasswordScreen(),
                RouteNames.bankLinkSecurity: (context) =>const BankLinkScreen(),
              };

              final builder = routes[settings.name];
              if (builder != null) {
                // Use slide transition for most routes
                return AppTransitions.slideTransition(
                  page: builder(context),
                  settings: settings,
                );
              }

              return null;
            },
            builder: (context, child) {
              return MediaQuery(
                // Prevent text scaling to maintain consistent UI
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
