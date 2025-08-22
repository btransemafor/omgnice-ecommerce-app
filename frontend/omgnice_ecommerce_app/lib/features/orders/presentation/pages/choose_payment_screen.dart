import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/orders/presentation/provider/order_provider.dart';
import 'package:provider/provider.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  bool isMomoSelected = true;
  bool isCODSelected = false;
  bool isPayOSSelected = false;

  void _selectMomo() {
    setState(() {
      isMomoSelected = true;
      isCODSelected = false;
      isPayOSSelected = false;
    });
    
    Provider.of<OrderProvider>(context, listen: false).choosePaymentMethod("MoMo E-wallet");
  }

  void _selectCOD() {
    setState(() {
      isMomoSelected = false;
      isCODSelected = true;
      isPayOSSelected = false;
    });
    
    Provider.of<OrderProvider>(context, listen: false).choosePaymentMethod("Cash On Delivery");
  }

  void _selectPayOS() {
    setState(() {
      isMomoSelected = false;
      isCODSelected = false;
      isPayOSSelected = true;
    });
    
    Provider.of<OrderProvider>(context, listen: false).choosePaymentMethod("PayOS");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: BeautifulAppBar(
        title: 'Payment Method',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        gradient: true,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Method',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how you want to pay for your order',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Payment methods section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'AVAILABLE PAYMENT OPTIONS',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Payment methods list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // MoMo Payment Option
                  _buildPaymentCard(
                    isSelected: isMomoSelected,
                    onTap: _selectMomo,
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/momo.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: 'MoMo E-Wallet',
                    subtitle: 'Fast payments with exclusive promotions',
                    badgeText: 'RECOMMENDED',
                  ),
                  
                  // PayOS Payment Option
                  _buildPaymentCard(
                    isSelected: isPayOSSelected,
                    onTap: _selectPayOS,
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/payos.png', // Make sure to add this asset to your project
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: 'PayOS',
                    subtitle: 'Multiple payment methods in one platform',
                    badgeText: 'NEW',
                  ),
                  
                  // COD Payment Option
                  _buildPaymentCard(
                    isSelected: isCODSelected,
                    onTap: _selectCOD,
                    icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                    title: 'Cash On Delivery',
                    subtitle: 'Pay when you receive your order',
                  ),
                  
                  // Additional payment info section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your payment details are encrypted and secure',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Return selected payment method
                String selectedMethod = "Cash On Delivery";
                if (isMomoSelected) {
                  selectedMethod = "MoMo E-wallet";
                } else if (isPayOSSelected) {
                  selectedMethod = "PayOS";
                }
                
                // Update provider with the selected payment method
                Provider.of<OrderProvider>(context, listen: false)
                    .choosePaymentMethod(selectedMethod);
                
                // Debug log
                print("Selected payment method before pop: $selectedMethod");
                    
                GoRouter.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget icon,
    required String title,
    required String subtitle,
    String? badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isSelected
            ? Border.all(color: Colors.green, width: 2)
            : Border.all(color: Colors.grey.shade100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Payment method icon
              icon,
              const SizedBox(width: 15),
              
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeText == 'NEW' 
                                  ? Colors.blue.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badgeText,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: badgeText == 'NEW' 
                                    ? Colors.blue.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.green,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}