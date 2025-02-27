import 'package:flutter/material.dart';
import 'package:qt_qt/widgets/common/branded_app_bar.dart';

class CampusOffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const BrandedAppBar(
      title: 'Campus Offers',
      backgroundColor: Colors.white,
),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Cashback Offer
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade600, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'York U Student Special',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '5% Cashback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'on all campus purchases',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Campus Vendors Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Campus Vendors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildVendorSection([
              _buildVendorItem(
                'York Lanes Dining',
                '3% cashback on all purchases',
                Icons.restaurant,
              ),
              _buildVendorItem(
                'Campus Bookstore',
                '4% cashback on textbooks',
                Icons.book,
              ),
              _buildVendorItem(
                'YU Coffee Shops',
                '2% cashback on beverages',
                Icons.coffee,
              ),
            ]),

            // Special Offers Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Special Offers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildOfferSection([
              _buildSpecialOffer(
                'First Transfer Bonus',
                'Get \$5 on your first transfer above \$50',
                'Valid till Dec 31, 2024',
                Colors.blue,
              ),
              _buildSpecialOffer(
                'Refer a Friend',
                'Get \$10 when your friend joins',
                'No expiry',
                Colors.purple,
              ),
              _buildSpecialOffer(
                'Bill Split Reward',
                'Get \$2 on group expenses above \$100',
                'Valid for students only',
                Colors.orange,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(children: children),
    );
  }

  Widget _buildVendorItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.teal),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to vendor details
      },
    );
  }

  Widget _buildOfferSection(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSpecialOffer(
    String title,
    String description,
    String validity,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: color),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            validity,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}