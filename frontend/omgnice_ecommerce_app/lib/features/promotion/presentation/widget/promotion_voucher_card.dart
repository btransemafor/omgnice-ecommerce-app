import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:provider/provider.dart';

class PromotionVoucherCard extends StatelessWidget {
  final PromotionEntity promotion;
  VoidCallback? ontap;

  PromotionVoucherCard({Key? key, required this.promotion, this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format dates
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = promotion.startDate != null
        ? dateFormat.format(promotion.startDate!)
        : 'N/A';
    final endDate = promotion.endDate != null
        ? dateFormat.format(promotion.endDate!)
        : 'N/A';

    // Format discount value
    String discountText = '';
    if (promotion.discountType == 'PERCENTAGE') {
      discountText = '${promotion.discountValue?.toInt()}%';
      if (promotion.maxDiscountValue != null) {
        discountText +=
            ' up to ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(promotion.maxDiscountValue)}';
      }
    } else {
      discountText =
          NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0)
              .format(promotion.discountValue);
    }

    // Apply scope
    String applyText = '';
    switch (promotion.appliesTo) {
      case 'ALL':
        applyText = 'All products';
        break;
      case 'PRODUCT':
        applyText = 'Specific product';
        break;
      case 'CATEGORY':
        applyText = 'Product category';
        break;
      default:
        applyText = 'All products';
    }

    // Progress calculation
    double progress = 0.0;
    if (promotion.usageLimit != null && promotion.usageLimit! > 0) {
      progress = (promotion.usedCount ?? 0) / promotion.usageLimit!;
    }

    // Determine if promotion is almost expired
    bool isAlmostExpired = false;
    if (promotion.endDate != null) {
      final daysLeft = promotion.endDate!.difference(DateTime.now()).inDays;
      isAlmostExpired = daysLeft <= 3 && daysLeft >= 0;
    }

    // Check if expired
    bool isExpired = false;
    if (promotion.endDate != null) {
      isExpired = DateTime.now().isAfter(promotion.endDate!);
    }

    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with background color
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? Colors.grey[300]
                          : (isAlmostExpired
                              ? Colors.orange[50]
                              : Colors.green[50]),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isExpired
                              ? Icons.not_interested
                              : (isAlmostExpired
                                  ? Icons.timer
                                  : Icons.local_offer),
                          color: isExpired
                              ? Colors.grey[600]
                              : (isAlmostExpired
                                  ? Colors.orange[700]
                                  : Colors.green[700]),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            promotion.title ?? 'Promotion',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isExpired
                                  ? Colors.grey[600]
                                  : (isAlmostExpired
                                      ? Colors.orange[700]
                                      : Colors.green[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dotted divider
                  Row(
                    children: List.generate(
                      30,
                      (index) => Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color:
                              index % 2 == 0 ? Colors.grey[300] : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Left side with discount
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? Colors.grey[200]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    promotion.discountType == 'PERCENTAGE'
                                        ? 'DISCOUNT'
                                        : 'FIXED',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: isExpired
                                          ? Colors.grey[600]
                                          : Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    promotion.discountType == 'PERCENTAGE'
                                        ? '${promotion.discountValue?.toInt()}%'
                                        : '${promotion.discountValue?.toInt()}K',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isExpired
                                          ? Colors.grey[600]
                                          : Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Right side with details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promotion.description ??
                                        'No description available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  if (promotion.minOrderValue != null)
                                    Text(
                                      'Min order: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(promotion.minOrderValue)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Coupon code section
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      promotion.code ?? 'NO CODE',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: isExpired
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: isExpired
                                          ? null
                                          : () {
                                              Clipboard.setData(ClipboardData(
                                                  text: promotion.code ?? ''));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Copied to clipboard: ${promotion.code}'),
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: isExpired
                                            ? Colors.grey[400]
                                            : Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Progress bar and expiry date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<PromotionProvider>(
                                  builder: (context, provider, child) {
                                    return Text(
                                      'Used: ${promotion.usedCount ?? 0}/${promotion.usageLimit ?? 'Unlimited'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'Valid until: $endDate',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isAlmostExpired && !isExpired
                                        ? Colors.orange[700]
                                        : Colors.grey[600],
                                    fontWeight: isAlmostExpired && !isExpired
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (promotion.usageLimit != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[200],
                                  color: progress > 0.7
                                      ? Colors.orange
                                      : Colors.green,
                                  minHeight: 6,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          promotion.appliesTo == 'ALL'
                              ? Icons.shopping_bag_outlined
                              : (promotion.appliesTo == 'PRODUCT'
                                  ? Icons.inventory_2_outlined
                                  : Icons.category_outlined),
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          applyText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        if (!isExpired)
                          ElevatedButton(
                            onPressed: () async {
                              // To be implemented: Apply voucher action
                              // TODO: Add user promotion
                              print(promotion.id);

                              // Access the provider with listen: false
                              final promotionProvider =
                                  Provider.of<PromotionProvider>(context,
                                      listen: false);

                              // Call saveUserPromotion asynchronously and wait for the result
                              bool result = await promotionProvider
                                  .saveUserPromotion(promotion.id!);

                              // Check the result of saving the promotion
                              if (result) {
                                print(promotionProvider
                                    .isSuccess); // Check if promotion is saved successfully
                                SuccessHelper.showSuccess(
                                    context, 'Save Promotion Successfully');
                              } else {
                                // Handle the case when saving the promotion fails
                                ErrorHelper.showError(context,
                                    'You have already saved this code hehe!!');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 0),
                              minimumSize: const Size(60, 28),
                            ),
                            child: const Text(
                              'Use',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            if (isExpired || isAlmostExpired)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.grey[700] : Colors.orange[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isExpired ? 'Expired' : 'Ending Soon',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
