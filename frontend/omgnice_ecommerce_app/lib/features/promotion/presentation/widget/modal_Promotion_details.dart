import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/widget/my_promotion_card.dart';
import 'package:provider/provider.dart';

class ModalPromotionDetails extends StatelessWidget {
  final PromotionEntity promotion;
  //final VoidCallback onApply;
  ModalPromotionDetails(this.promotion);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Voucher Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Voucher Card
            SizedBox(
              height: 200,
              child: PromotionCard(
                promotion: promotion,
                isSelected: false,
              ),
            ),
            const SizedBox(height: 20),

            // Details
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Discount Code', promotion.code ?? 'N/A'),
                    _buildDetailItem('Title', promotion.title ?? 'N/A'),
                    _buildDetailItem(
                        'Description', promotion.description ?? 'N/A'),
                    _buildDetailItem(
                        'Discount Value',
                        promotion.discountType == 'PERCENTAGE'
                            ? '${promotion.discountValue?.toInt()}%'
                            : '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(promotion.discountValue)}'),
                    if (promotion.maxDiscountValue != null)
                      _buildDetailItem(
                          'Max Discount',
                          NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ',
                                  decimalDigits: 0)
                              .format(promotion.maxDiscountValue)),
                    if (promotion.minOrderValue != null &&
                        promotion.minOrderValue! > 0)
                      _buildDetailItem(
                          'Min Order Value',
                          NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ',
                                  decimalDigits: 0)
                              .format(promotion.minOrderValue)),
                    _buildDetailItem('Validity',
                        '${_formatDate(promotion.startDate)} to ${_formatDate(promotion.endDate)}'),
                    _buildDetailItem(
                        'Applies to', _getAppliesString(promotion)),
                    if (promotion.usageLimit != null)
                      _buildDetailItem('Usage Limit',
                          '${promotion.usedCount ?? 0}/${promotion.usageLimit} times'),
                  ],
                ),
              ),
            ),

            // Buttons
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Close',
                        style: GoogleFonts.poppins(color: Colors.green)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Áp dụng promotion ngay lập tức và sao chép mã vào clipboard
                   
                      Clipboard.setData(
                          ClipboardData(text: promotion.code ?? ''));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('use',
                        style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

String _formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return DateFormat('dd-MM-yyyy').format(date);
}

String _getAppliesString(PromotionEntity promotion) {
  switch (promotion.appliesTo) {
    case 'ALL':
      return 'All product';
    case 'PRODUCT':
      return 'Sản phẩm cụ thể (ID: ${promotion.productId})';
    case 'CATEGORY':
      return 'Danh mục sản phẩm (ID: ${promotion.categoryId})';
    default:
      return 'Undefined';
  }
}
