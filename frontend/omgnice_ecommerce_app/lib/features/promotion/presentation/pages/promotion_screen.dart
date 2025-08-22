import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/modal_Promotion_details.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/promotion_countdown.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/promotion_voucher_card.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/reset_countdown_widget.dart';
import 'package:provider/provider.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool _isContentLoaded = false;
  bool _isCountdownLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<PromotionProvider>(context, listen: false);
      provider.fetchPromotions();
    });
    
    // Load all content together
    _loadContent();
  }

  void _loadContent() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isContentLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set fixed end time (doesn't change when app restarts)
    final endTime = DateTime(2025, 12, 31, 23, 59, 59); // 31/12/2025 23:59:59
    
    // Or set specific future time
    final flashSaleEndTime = DateTime(2025, 6, 15, 12, 0, 0); // 15/06/2025 12:00:00

    return Scaffold(
      appBar: BeautifulAppBar(
        title: 'Gift Voucher',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        gradient: true,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            // Show loading or actual content
            _isContentLoaded ? _buildActualContent() : _buildLoadingContent(),
            
            const SizedBox(height: 28),

            // Promotion List
            Consumer<PromotionProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.promotions.length,
                  itemBuilder: (context, index) {
                    final promotion = provider.promotions[index];
                    return PromotionVoucherCard(
                      ontap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ModalPromotionDetails(promotion),
                        );
                      },
                      promotion: promotion,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Loading Banner
        
          
          // Loading Alert Placeholder
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Loading Countdown Placeholder
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => 
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActualContent() {
    return Column(
      children: [
        // Promotion Banner Image
        _buildPromotionBanner(),
        
        const SizedBox(height: 24),
        
        // Limited Stock Alert
        _buildLimitedStockAlert(),
        
        // Daily Reset Countdown
        _buildCountdownSection(),
      ],
    );
  }
  bool _isImageLoaded = false;

  Widget _buildPromotionBanner() {
    // Simulate image loading
    if (!_isImageLoaded) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isImageLoaded = true;
          });
        }
      });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child:
              Image.asset(
                  'assets/promotion/promotion.png',
                  fit: BoxFit.cover,
                  height: 190,
                  width: double.infinity,
                )
             
            
        )
      ),
    );
  }

  Widget _buildLimitedStockAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Hurry! Limited stock – blink and it's gone!",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
          ],
        ),
      );
    }
  
    Widget _buildCountdownSection() {
      // Simulate countdown loading, you can replace this logic as needed
      if (!_isCountdownLoaded) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _isCountdownLoaded = true;
            });
          }
        });
      }
      return DailyResetCountdown(
        title: "DEAL EVERYDAY",
        style: CountdownStyle.neon,
        dailyDuration: const Duration(hours: 23),
        resetTime: const TimeOfDay(hour: 0, minute: 0),
        primaryColor: const Color(0xFF00E676),
      );
    }
  }
  