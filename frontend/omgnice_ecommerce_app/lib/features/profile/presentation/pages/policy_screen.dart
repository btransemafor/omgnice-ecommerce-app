import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:url_launcher/url_launcher.dart';

 final Color backgroundLightColor = const Color(0xFFF1F8E9); // Light Green Background
class PolicyScreen extends StatelessWidget {
  const PolicyScreen({Key? key}) : super(key: key);
     void _sendSms(BuildContext context, String phoneNumber) async {
    final message =
        Uri.encodeComponent('Hello, shop ');
    final uri = Uri.parse('sms:$phoneNumber?body=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open SMS app.'.tr(),
              style: GoogleFonts.inter(fontSize: 13)),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: BeautifulAppBar(title: 'Policies', gradient: true ,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.policy,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'OMGNICE Policies',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Committed to providing the best service',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Policy Items
              _buildPolicyCard(
                context: context,
                icon: Icons.local_shipping,
                title: 'Shipping Policy',
                summary: 'Fast and safe delivery',
                color: const Color(0xFF2196F3),
                content: const ShippingPolicy(),
              ),
              
              _buildPolicyCard(
                context: context,
                icon: Icons.autorenew,
                title: 'Cancel Policy',
                summary: 'Easy cancel within 1 hours ',
                color: const Color(0xFFFF9800),
                content: const ReturnPolicy(),
              ),
              
              _buildPolicyCard(
                context: context,
                icon: Icons.payment,
                title: 'Payment Policy',
                summary: 'Multiple payment methods',
                color: const Color(0xFF4CAF50),
                content: const PaymentPolicy(),
              ),
              
              _buildPolicyCard(
                context: context,
                icon: Icons.security,
                title: 'Privacy & Security',
                summary: 'Committed to protecting customer information',
                color: const Color(0xFF9C27B0),
                content: const SecurityPolicy(),
              ),
              
              _buildPolicyCard(
                context: context,
                icon: Icons.stars,
                title: 'Loyalty Program',
                summary: 'Earn points for attractive rewards',
                color: const Color(0xFFF44336),
                content: const LoyaltyPolicy(),
              ),
              
              const SizedBox(height: 20),
              
              // Support Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.support_agent,
                      size: 48,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Need more help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Contact us to get answers to all your questions',
                      style: TextStyle(
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                             _sendSms(context, '0338498306'); 
                            },
                            icon: const Icon(Icons.chat, size: 18, color: Colors.white,),
                            label: const Text('Send SMS now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                                 launchUrl(Uri.parse('tel:+84338498406'));

                    /*  launchUrl(Uri.parse(
                                        'mailto:omgnicesupport@gmail.com')); */

                          ///Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.phone, size: 18, color: Color(0xFF2E7D32),),
                            label: const Text('Call hotline'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2E7D32),
                              side: const BorderSide(color: Color(0xFF2E7D32)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String summary,
    required Color color,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            summary,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF999999),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PolicyDetailScreen(
                title: title,
                content: content,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Policy Detail Screen
class PolicyDetailScreen extends StatelessWidget {
  final String title;
  final Widget content;
  final Color color;

  const PolicyDetailScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: BeautifulAppBar(title: title, gradient: true ,), 
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      ),
    );
  }
}

// Shipping Policy Content
class ShippingPolicy extends StatelessWidget {
  const ShippingPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicySection(
          title: '🚚 Delivery Time',
          content: '''• HCMC & Hanoi inner city: 1-2 hours
• Other provinces: 2-5 business days
• Orders placed before 3pm will be delivered same day''',
        ),
        _buildPolicySection(
          title: '💰 Shipping Fees',
          content: '''• Free shipping for orders over \$8.50
• Inner city shipping: \$1.00
• Inter-province shipping: \$1.50
• COD fee: \$0.40''',
        ),
        _buildPolicySection(
          title: '📍 Delivery Areas',
          content: '''• Nationwide delivery
• Priority for HCMC, Hanoi inner city
• Some remote areas may incur additional fees
• No delivery on Sundays''',
        ),
        _buildPolicySection(
          title: '📱 Order Tracking',
          content: '''• Receive tracking code after order confirmation
• Real-time updates in the app
• SMS notifications for order status
• Call 15-30 minutes before delivery''',
        ),
      ],
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Return Policy Content
class ReturnPolicy extends StatelessWidget {
  const ReturnPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         _buildPolicySection(
            title: '🚫 Cancellation Policy',
            content: '''
      • You can cancel your order **within 10 minutes** after placing it, regardless of the order status.
      • If your order is still **not approved after 30 minutes**, you are allowed to cancel it.
      • After that time, the order will be processed and can no longer be canceled.''',
          ),
          _buildPolicySection(
            title: '🎯 When Are Returns/Support Accepted?',
            content: '''
      • Wrong item delivered.
      • Severely damaged packaging or spilled products upon delivery.
      • Product is expired at the time of receipt.
      • Product was broken or leaked during shipping.''',
          ),
          _buildPolicySection(
            title: '❌ Not Eligible for Return/Exchange If:',
            content: '''
      • The product has been opened or used.
      • You changed your mind after receiving the product.
      • No valid evidence of manufacturer or shipping defect.''',
          ),
          _buildPolicySection(
            title: '📞 How to Request Support',
            content: '''
      • Contact our hotline within 24 hours of receiving your order.
      • Send photos of the issue along with your order ID.
      • Our team will verify and respond within 1–3 business days.''',
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Policy Content
class PaymentPolicy extends StatelessWidget {
  const PaymentPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicySection(
          title: '💳 Payment Methods',
          content: '''• COD (Cash on Delivery)
• E-wallets: ZaloPay, MoMo - Đang thử nghiệm
• PayOS - Online payment''',
        ),
        _buildPolicySection(
          title: '🔐 Payment Security',
          content: '''• 256-bit SSL encryption
• No card information storage
• OTP verification for all transactions
• Bank 3D-Secure support''',
        ),
        _buildPolicySection(
          title: '💰 Payment Fees',
          content: '''• COD: \$0.40 per order
• E-wallets: Free
• Payment fees may vary depending on order value''',
        ),
        _buildPolicySection(
          title: '🏦 Partner Banks',
          content: '''• Vietcombank, BIDV, VietinBank
• Techcombank, ACB, Sacombank
• Agribank, MB Bank, VP Bank
• And most other banks''',
        ),
      ],
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Security Policy Content
class SecurityPolicy extends StatelessWidget {
  const SecurityPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicySection(
            title: '🔒 Security Commitment',
            content: '''
      • No sharing information with third parties
      • Encrypt all personal data
      • Two-factor authentication for accounts
      • Comply with GDPR and VN data protection laws''',
          ),
          _buildPolicySection(
            title: '👤 Information Collected',
            content: '''
      • Name, phone number, email
      • Delivery address
      • Purchase history
      • Payment information (encrypted)''',
          ),
          _buildPolicySection(
            title: '🎯 Usage Purpose',
            content: '''
      • Process orders and delivery
      • Customer support
      • Send order notifications
      • Service improvement (with consent)''',
          ),
          _buildPolicySection(
            title: '🛡️ Protection Measures',
            content: '''
      • Advanced firewall and antivirus
      • Regular data backup
      • Periodic security audits
      • Staff security training''',
          ),
          _buildPolicySection(
        title: '🗑️ Account Deletion',
        content: '''
      • You can delete your account anytime directly in the Settings section.
      • Once deleted, all personal data will be permanently removed from our system.
      • For additional assistance, contact us via hotline or email.
      • Requests are processed within 5 working days.''',
      ),
      
        ],
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Loyalty Policy Content
class LoyaltyPolicy extends StatelessWidget {
  const LoyaltyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicySection(
          title: '🌟 How to Earn Points',
          content: '''• 1 point for every \$1 spent
• 2x points on first order
• Bonus points on special occasions
• Points for product reviews and referrals''',
        ),
        _buildPolicySection(
          title: '🎁 Redeem Rewards',
          content: '''• 100 points = \$1 discount
• Free shipping coupons
• Exclusive products
• Birthday special offers''',
        ),
        _buildPolicySection(
          title: '📅 Point Validity',
          content: '''• Points valid for 12 months
• Automatic extension with new orders
• Email reminder before expiration
• VIP members get extended validity''',
        ),
        _buildPolicySection(
          title: '👑 VIP Levels',
          content: '''• Bronze: 0-999 points
• Silver: 1000-2999 points
• Gold: 3000-4999 points
• Platinum: 5000+ points''',
        ),
      ],
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

 
}