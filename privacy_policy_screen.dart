import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String privacyPolicyText = '''
Privacy Policy
Effective Date: December 1, 2024 
Last Updated: December 1, 2024

Welcome to QuikTransfer, a financial transaction application designed for seamless and secure money transfers. Your privacy is important to us. This Privacy Policy outlines how we collect, use, share, and protect your information. By using QuikTransfer, you agree to the practices described in this Privacy Policy.

1. Information We Collect
We collect information to provide you with the best possible experience and comply with applicable regulations.

a. Personal Information
- Full Name
- Email Address 
- Phone Number
- Date of Birth
- Government-issued identification (e.g., passport, driver's license) for KYC purposes

b. Financial Information
- Bank account details
- Payment card information
- Transaction history

c. Device and Technical Information  
- IP address
- Device type and model
- Operating system and version
- App usage data (e.g., login history)

d. Behavioral Data
- User preferences
- Interaction with app features

e. Communication Data
- Messages exchanged via the app (if applicable)

2. How We Use Your Information
We use your information to:
- Facilitate and complete financial transactions.
- Verify your identity for fraud prevention and regulatory compliance.
- Improve app functionality and user experience.
- Communicate updates, promotions, or technical alerts.
- Conduct analytics to enhance our services.

3. How We Share Your Information
Your information is shared only as necessary and under strict conditions.

a. With Third Parties
- Payment processors (e.g., Stripe, PayPal) and banks to complete transactions.
- Identity verification services (e.g., Trulioo, Jumio) to comply with regulatory requirements.
- Law enforcement or regulators, as required by law.

b. With Service Providers 
- Cloud storage providers (e.g., AWS, Google Cloud)
- Data analytics platforms (e.g., Amplitude, Mixpanel)
- Communication services (e.g., Twilio, SendGrid)

c. Legal Disclosures
We may disclose information if required by law or in good faith to:
- Protect our legal rights.
- Prevent fraud or security threats. 
- Comply with subpoenas, court orders, or other legal processes.

4. Children's Privacy
QuikTransfer is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from children. If we become aware that we have collected personal information from a child, we will take steps to delete the information as soon as possible. If you believe we have collected information from a child, please contact us.

5. Data Security
We prioritize the security of your data and use industry-standard measures, including:
- Data encryption (SSL/TLS) for secure communication.  
- Encrypted storage for sensitive information.
- Regular security audits and updates.
- Role-based access to sensitive data.

6. Your Rights
You have the following rights regarding your information:
- Access: Request a copy of your data.
- Correction: Correct inaccuracies in your data. 
- Deletion: Request data deletion, subject to legal retention requirements.
- Portability: Request a transfer of your data to another provider.
- Opt-Out: Decline marketing communications or data tracking.

To exercise any of these rights, please contact us at support@quiktransfer.com. 

7. Data Retention
We retain your information: 
- As long as your account remains active.
- For up to 7 years after account closure, as required by law or for dispute resolution.

8. Cookies and Tracking
We use cookies and similar technologies to:
- Enhance your app experience.
- Monitor app performance and user behavior.

You can manage cookies through your device settings. For instructions, visit:
- iOS: https://support.apple.com/en-us/HT201265  
- Android: https://support.google.com/chrome/answer/95647

9. International Data Transfers
If your data is transferred outside of Canada, we ensure it is protected in compliance with applicable data protection laws. For users in the European Union, QuikTransfer complies with the General Data Protection Regulation (GDPR).

10. Compliance with Laws
We comply with all relevant data protection laws, including:
- PIPEDA (Personal Information Protection and Electronic Documents Act) for Canadian users.
- GDPR for users in the European Union.

11. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. Significant changes will be communicated via: 
- Notifications in the app.
- Email to registered users.

Please review this policy periodically.

12. Contact Us 
For questions, concerns, or data requests, contact us at:
Email: support@quiktransfer.com
Phone: +1-555-123-4567
Address: 123 QuikTransfer Lane, Toronto, ON, M5V 2X9, Canada

By using QuikTransfer, you acknowledge that you have read and understood this Privacy Policy. Your continued use of the app constitutes your acceptance of its terms.
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/QTlogo.png', // Replace with your logo path
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  privacyPolicyText,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back on acknowledgment
              },
              child: const Text('Acknowledge and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}