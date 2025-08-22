import 'package:flutter/material.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/pages/map.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  final Color backgroundLightColor =
      const Color(0xFFF1F8E9); // Light Green Background
  @override
  Widget build(BuildContext context) {
    final String address =
        "Khu pho 6, Phuong Linh Trung, TP. Thu Duc"; // Địa chỉ bạn muốn mở trên Google Maps
    final double latitude = 10.869987816615083;
    final double longitude = 106.8034081469767;
// 10.869987816615083, 106.80303263773075

    // Hàm mở Google Maps
    Future<void> _openGoogleMaps() async {
      final String googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";
    
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    } 

    }

    Future<void> _launchZaloPay() async {
  const String zaloPayUrl = 'zalopay://'; // Custom URL scheme for ZaloPay
  const String playStoreUrl = 'https://play.google.com/store/apps/details?id=vn.com.vng.zalopay'; // Google Play link
  const String appStoreUrl = 'https://apps.apple.com/vn/app/zalopay-thanh-to%C3%A1n-t%C3%ADch-th%C6%B0%E1%BB%9Fng/id1059368722'; // App Store link

  final Uri uri = Uri.parse(zaloPayUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri); // Open ZaloPay app if installed
  } else {
    // Fallback to app store based on platform
    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
      await launchUrl(Uri.parse(playStoreUrl), mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Không thể mở ZaloPay hoặc tải ứng dụng.';
    }
  }
}

    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: AppBar(
        title: const Text(
          'About OMGNICE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Logo placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.store,
                        size: 60,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'OMGNICE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Convenient & Trustworthy Beverage Store',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Content Sections
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Who We Are Section
                  _buildSection(
                    icon: Icons.store_outlined,
                    title: 'Who is OMGNICE?',
                    content:
                        'We are an online store specializing in refreshing drinks, detox beverages, healthy drinks, and ready-to-drink products. From daily hydration needs to special occasions – you can find everything at OMGNICE.',
                    color: const Color(0xFF2196F3),
                  ),

                  // Mission Section
                  _buildSection(
                    icon: Icons.track_changes_outlined,
                    title: 'Our Mission',
                    content:
                        'We aspire to become a reliable choice for those who love convenient, quality, and safe beverages. OMGNICE is always ready to serve you anytime, anywhere.',
                    color: const Color(0xFFFF9800),
                  ),

                  // Core Values Section
                  _buildSection(
                    icon: Icons.eco_outlined,
                    title: 'Core Values',
                    content:
                        '✨ Honesty: Clear about origin and pricing\n🌿 Freshness: Always ensuring product quality\n📦 Convenience: Fast delivery – enthusiastic support',
                    color: const Color(0xFF4CAF50),
                  ),

                  // Target Customers Section
                  _buildSection(
                    icon: Icons.people_outline,
                    title: 'Our Customers',
                    content:
                        'From young Gen Z, office workers to homemakers... anyone who loves convenience, self-care, and wants to drink deliciously every day are our customers.',
                    color: const Color(0xFF9C27B0),
                  ),

                  // Services Section
                  _buildSection(
                    icon: Icons.local_shipping_outlined,
                    title: 'Featured Services',
                    content:
                        '🚚 Fast delivery within city\n📞 Consultation support for beverage selection\n💸 Clear pricing with offers\n🎁 Loyalty points – attractive rewards',
                    color: const Color(0xFFF44336),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Thank you for visiting OMGNICE!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We hope you find the perfect beverage – and enjoy it from the very first sip!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactButton(
                        icon: Icons.phone,
                        label: 'Hotline',
                        onTap: () {
                          launchUrl(Uri.parse('tel:+84338498406'));

                          /*  launchUrl(Uri.parse(
                                        'mailto:omgnicesupport@gmail.com')); */
                        },
                      ),
                      _buildContactButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () {
                          launchUrl(Uri.parse('mailto:omgniceten@gmail.com'));
                        },
                      ),
                      _buildContactButton(
                        icon: Icons.location_on,
                        label: 'Store',
                        onTap: () {
                          _openGoogleMaps();
                       //  _launchZaloPay(); 
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
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
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
