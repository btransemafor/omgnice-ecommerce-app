import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_appbar_common.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/edit_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/empty_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/widgets/card_my_address.dart';
import 'package:provider/provider.dart';

class SelectAddressScreen extends StatefulWidget {
  final AddressEntity? initialAddress;
  
  const SelectAddressScreen({
    Key? key,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  String? selectedAddressId;
  
  @override
  void initState() {
    super.initState();
    
    // Thiết lập địa chỉ đã chọn nếu có
    if (widget.initialAddress != null && widget.initialAddress!.id != null) {
      selectedAddressId = widget.initialAddress!.id;
    }
    
    // Gọi fetch sau 1 frame để tránh lỗi context chưa sẵn sàng
    Future.microtask(() {
      final provider = Provider.of<AddressProvider>(context, listen: false);
      provider.fetchListAddress().then((_) {
        // Nếu chưa có địa chỉ được chọn trước đó, chọn địa chỉ mặc định
        if (selectedAddressId == null && provider.addresses.isNotEmpty) {
          // Tìm địa chỉ mặc định
          final defaultAddress = provider.addresses.firstWhere(
            (addr) => addr.is_default,
            orElse: () => provider.addresses.first,
          );
          
          setState(() {
            selectedAddressId = defaultAddress.id;
          });
        }
      });
    });
  }

  // Hàm để thêm địa chỉ mới
  void _navigateToAddAddress() async {
    final result = await context.pushNamed('addAddress');
    
    if (result == true) {
      // Refresh lại danh sách địa chỉ
      final provider = Provider.of<AddressProvider>(context, listen: false);
      provider.fetchListAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: const CustomAppbarCommon(title: "Select Delivery Address"),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final provider = Provider.of<AddressProvider>(context, listen: false);
                await provider.fetchListAddress();
              },
              child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
                  // Hiển thị loading indicator nếu đang load
                  if (addressProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  
                  // Hiển thị Empty state nếu không có địa chỉ nào
                  if (addressProvider.addresses.isEmpty) {
                    return EmptyAddressWidget(
                      onAddNew: _navigateToAddAddress,
                    );
                  }
                  
                  // Hiển thị danh sách địa chỉ
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: addressProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final addressItem = addressProvider.addresses[index];
                      
                      return CardMyAddress(
                        fullAddress: addressItem,
                        isSelectable: true, // Có thể chọn trong trang checkout
                        isSelected: selectedAddressId == addressItem.id,
                        onSelect: (isSelected) {
                          if (isSelected) {
                            setState(() {
                              selectedAddressId = addressItem.id;
                            });
                          }
                        },
                        onEdit: () {
                          // Navigate to edit screen
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => EditAddressScreen(
                                addressToEdit: addressItem
                              )
                            )
                          ).then((_) {
                            // Refresh lại danh sách địa chỉ sau khi sửa
                            final provider = Provider.of<AddressProvider>(
                              context, 
                              listen: false
                            );
                            provider.fetchListAddress();
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(height: 1),
                  );
                },
              ),
            ),
          ),
          
          // Button footer để tiếp tục với địa chỉ đã chọn
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Button Add new Address
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _navigateToAddAddress,
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                ),
                
                // Button Continue
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedAddressId != null ? () {
                      // Lấy instance của AddressProvider
                      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
                      
                      // Tìm địa chỉ đã chọn để trả về
                      final selectedAddress = addressProvider.addresses.firstWhere(
                        (addr) => addr.id == selectedAddressId
                      );
                      
                      // Trả về địa chỉ đã chọn và quay lại màn hình trước
                      Navigator.pop(context, selectedAddress);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Continue with this address",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
}