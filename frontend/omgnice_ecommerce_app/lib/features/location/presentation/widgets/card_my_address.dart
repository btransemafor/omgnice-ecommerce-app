import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';

class CardMyAddress extends StatelessWidget {
  final AddressEntity fullAddress;
  final VoidCallback? onTap;
  final bool isSelectable; // Hiển thị radio button để chọn hay không
  final bool isSelected; // Đánh dấu địa chỉ đã được chọn
  final Function(bool)? onSelect; // Callback khi chọn địa chỉ
  final VoidCallback? onEdit; // Callback khi nhấn nút edit

  const CardMyAddress({
    Key? key,
    required this.fullAddress,
    this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: InkWell(
        onTap: isSelectable ? () {
          // Chỉ gọi onSelect khi đang ở chế độ có thể chọn
          onSelect?.call(!isSelected);
        } : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio button chỉ hiển thị khi isSelectable = true
              if (isSelectable)
                Radio<bool>(
                  value: true,
                  groupValue: isSelected ? true : null,
                  onChanged: (value) {
                    if (value != null && value) {
                      onSelect?.call(true);
                    }
                  },
                  activeColor: Colors.green,
                ),
              
              // Thông tin địa chỉ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullAddress.fullName ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      fullAddress.phone ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _getFullAddressText(fullAddress),
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    
                    // Badge "Default" nếu là địa chỉ mặc định
                    if (fullAddress.is_default)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Default",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Nút Edit chỉ hiển thị khi isSelectable = true và có onEdit
              if (isSelectable && onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  child: Text(
                    "Edit",
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method để tạo chuỗi địa chỉ đầy đủ
  String _getFullAddressText(AddressEntity address) {
    List<String> parts = [];
    
    if (address.address.details != null && address.address.details!.isNotEmpty) {
      parts.add(address.address.details!);
    }
    
    if (address.address.ward.isNotEmpty) {
      parts.add(address.address.ward);
    }
    
    if (address.address.district.isNotEmpty) {
      parts.add(address.address.district);
    }
    
    if (address.address.province.isNotEmpty) {
      parts.add(address.address.province);
    }
    
    return parts.join(', ');
  }
}