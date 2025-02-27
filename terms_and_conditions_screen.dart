import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final String termsAndConditionsText = '''
Terms and Conditions
Effective Date: [Insert Date]
Last Updated: [Insert Date]

Welcome to QuikTransfer, a financial transaction app designed for secure and seamless money management. By using QuikTransfer ("the App"), you agree to comply with these Terms and Conditions ("Terms"). Please read them carefully. If you do not agree to these Terms, you may not use the App.

1. Acceptance of Terms
By accessing or using QuikTransfer, you agree to:

Be bound by these Terms and any policies referenced herein (e.g., Privacy Policy).
Comply with all applicable laws and regulations.
If you represent an organization, you confirm you have authority to bind that organization to these Terms.

2. Eligibility
To use QuikTransfer, you must:

Be at least 18 years old or the age of majority in your jurisdiction.
Reside in [Canada] (or other applicable regions, as updated).
Have a valid bank account or payment method linked to the App.
We reserve the right to refuse service or terminate accounts if eligibility criteria are not met.

3. Account Responsibilities
a. Account Creation
You agree to provide accurate and complete information during sign-up, including verifying your identity when required.

b. Account Security
You are responsible for maintaining the confidentiality of your login credentials. Notify us immediately of unauthorized access or suspicious activity.

c. Account Termination
We may suspend or terminate accounts if you:

Violate these Terms.
Engage in fraudulent or unlawful activities.
Fail to comply with identity verification requirements.
4. Services Provided
QuikTransfer allows you to:

Send and receive money.
Split expenses with others.
Manage transactions and linked accounts.
a. Service Availability
While we strive to provide uninterrupted service, we do not guarantee continuous availability. Maintenance, updates, or unforeseen technical issues may cause disruptions.

5. Fees
Certain transactions may incur fees, which will be clearly disclosed before completing the transaction. By proceeding with a transaction, you agree to the applicable fees.

6. User Conduct
You agree not to:

Use the App for illegal, fraudulent, or unauthorized purposes.
Transmit harmful or malicious content, such as viruses.
Interfere with or disrupt the App's functionality.
We reserve the right to report any illegal activities to law enforcement authorities.

7. Intellectual Property
All content, trademarks, and materials on the App, including the logo, design, and software, are owned by or licensed to QuikTransfer.

You may not:

Copy, reproduce, or distribute our intellectual property without prior written consent.
Reverse engineer or tamper with the App.
8. Limitation of Liability
To the fullest extent permitted by law, QuikTransfer is not liable for:

Direct, indirect, or consequential damages arising from your use of the App.
Losses caused by unauthorized access to your account due to your failure to secure login credentials.
Our total liability for any claims is limited to the amount of fees paid by you in the six months preceding the incident.

9. Indemnification
You agree to indemnify and hold harmless QuikTransfer, its affiliates, and its employees from any claims, damages, or expenses arising from:

Your breach of these Terms.
Your misuse of the App.
Your violation of applicable laws.
10. Privacy
Your use of the App is governed by our Privacy Policy. By using the App, you consent to our data collection and handling practices as outlined in the Privacy Policy.

11. Modifications to Terms
We reserve the right to update these Terms at any time. Significant changes will be communicated via:

Notifications in the App.
Email to registered users.
Continued use of the App constitutes acceptance of the revised Terms.

12. Governing Law and Dispute Resolution
a. Governing Law
These Terms are governed by the laws of [Province, Canada], without regard to conflict of law principles.

b. Dispute Resolution
Any disputes arising from these Terms will be resolved through:

Negotiation: Initial attempts to resolve disputes informally.
Mediation/Arbitration: If unresolved, disputes will be settled by arbitration in accordance with [arbitration rules].
13. Termination
We may terminate or suspend access to the App without prior notice for reasons including, but not limited to:

Breach of these Terms.
Fraudulent activity.
Non-compliance with applicable laws.
You may terminate your account at any time by contacting us.

14. Third-Party Services
The App may integrate with third-party services (e.g., payment processors). Your use of these services is subject to their terms, and QuikTransfer is not liable for issues arising from their use.

15. Contact Us
For questions or concerns regarding these Terms, please contact us:
Email: support@quiktransfer.com
Phone: [Insert phone number]
Address: [Insert company address]

By using QuikTransfer, you confirm that you have read and understood these Terms and agree to be legally bound by them. If you do not agree, please discontinue use of the App immediately.
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
              'Terms and Conditions',
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
                  termsAndConditionsText,
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