import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';

class PromotionCard extends StatelessWidget {
  final PromotionEntity promotion;
  final VoidCallback? onTap;
  final bool isSelected;

  const PromotionCard({
    Key? key,
    required this.promotion,
    this.onTap,
    required this.isSelected,
  }) : super(key: key);

  Color _getPromotionColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.green.shade800
        : Colors.green.shade600;
  }

  IconData _getPromotionIcon() {
    switch (promotion.appliesTo) {
      case 'PRODUCT':
        return Icons.shopping_bag_outlined;
      case 'CATEGORY':
        return Icons.category_outlined;
      case 'ALL':
      default:
        if (promotion.code?.contains('SHIP') == true) {
          return Icons.local_shipping_outlined;
        } else if (promotion.title?.contains('New') == true) {
          return Icons.new_releases_outlined;
        } else if (promotion.discountType == 'PERCENTAGE' && (promotion.discountValue ?? 0) >= 50) {
          return Icons.star_border;
        }
        return Icons.local_offer_outlined;
    }
  }

  String _getFormattedDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getDiscountText() {
    if (promotion.discountValue == null) return 'N/A';
    if (promotion.discountType == 'PERCENTAGE') {
      return '${promotion.discountValue!.toInt()}%';
    }
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(promotion.discountValue!);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPromotionColor(context);
    final icon = _getPromotionIcon();
    return AnimatedScale(
      scale: isSelected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: _buildListViewCard(context, color, icon, isSelected),
    );
  }

  Widget _buildListViewCard(BuildContext context, Color color, IconData icon, bool isSelected) {
    final textScaler = MediaQuery.textScalerOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth < 360 ? 0.9 : 1.0; // Responsive font trên màn hình nhỏ

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12), // Giảm margin
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.shade400
                        : color)
                    : Colors.grey.shade300,
                width: isSelected ? 4.0 : 0.5,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color,
                    Colors.green.shade400.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10), // Giảm padding
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: textScaler.scale(22 * fontScale),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                label: 'Promotion title: ${promotion.title}',
                                child: Text(
                                  promotion.title ?? 'Promotion',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: textScaler.scale(16 * fontScale),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (promotion.description != null) ...[
                                const SizedBox(height: 3),
                                Text(
                                  promotion.description!,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: textScaler.scale(12 * fontScale),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (promotion.endDate != null) ...[
                                const SizedBox(height: 3),
                                Text(
                                  'Expiry: ${_getFormattedDate(promotion.endDate)}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: textScaler.scale(10 * fontScale),
                                  ),
                                ),
                              ],
                              if (promotion.minOrderValue != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Min: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(promotion.minOrderValue)}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: textScaler.scale(10 * fontScale),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        _buildDiscountBadge(context, color, textScaler, fontScale),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Code: ',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade700,
                            fontSize: textScaler.scale(12 * fontScale),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            promotion.code ?? 'VOUCHER',
                            style: GoogleFonts.inter(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: textScaler.scale(14 * fontScale),
                              letterSpacing: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.copy, size: textScaler.scale(16 * fontScale)),
                          color: color,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: promotion.code ?? 'VOUCHER'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Copied ${promotion.code ?? 'VOUCHER'}',
                                  style: GoogleFonts.inter(),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                        if (promotion.usageLimit != null && promotion.usedCount != null)
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${promotion.usedCount}/${promotion.usageLimit}',
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade700,
                                fontSize: textScaler.scale(9 * fontScale),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: textScaler.scale(20 * fontScale),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(
      BuildContext context, Color color, TextScaler textScaler, double fontScale) {
    if (promotion.discountValue == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        (promotion.discountType == 'PERCENTAGE') ? '-${_getDiscountText()}' : _getDiscountText(),
        style: GoogleFonts.inter(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: textScaler.scale(12 * fontScale),
        ),
      ),
    );
  }
}