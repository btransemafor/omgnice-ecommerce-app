import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/edit_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/empty_address_screen.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/widgets/card_my_address.dart';
import 'package:provider/provider.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi fetch sau 1 frame để tránh lỗi context chưa sẵn sàng
    Future.microtask(() {
      final provider = Provider.of<AddressProvider>(context, listen: false);
      provider.fetchListAddress();
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
        appBar: BeautifulAppBar(
        title: 'My Address',
        titleColor: Colors.white,
        backButtonColor : Colors.white,
        gradient: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
        backgroundColor: Colors.grey.shade200,
        body: RefreshIndicator(
          onRefresh: () async {
            final provider = Provider.of<AddressProvider>(context, listen: false);
            await provider.fetchListAddress();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                print("Building list with ${addressProvider.addresses.length} addresses");
                
                // Hiển thị loading indicator nếu đang load
                if (addressProvider.isLoading) {
                  return SizedBox(
                    height: size.height * 0.7,
                    child: const Center(
                      child: CustomLoading(),
                    ),
                  );
                }
                
                // Hiển thị Empty state nếu không có địa chỉ nào
                if (addressProvider.addresses.isEmpty) {
                  return SizedBox(
                    height: size.height * 0.7,
                    child: EmptyAddressWidget(
                      onAddNew: _navigateToAddAddress,
                    ),
                  );
                }
                
                // Hiển thị danh sách địa chỉ
                return Column(
                  children: [
                    const SizedBox(height: 10,),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: addressProvider.addresses.length,
                      itemBuilder: (context, index) {
                        final addressItem = addressProvider.addresses[index];
                        
                        return CardMyAddress(
                          fullAddress: addressItem, 
                          onTap: () {
                            print('${addressItem.id}');
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => EditAddressScreen(addressToEdit: addressItem)
                              )
                            );
                          },
                          // Không cần isSelectable vì mặc định là false
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
                    
                    // Button Add new Address
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.white,
                      child: InkWell(
                        onTap: _navigateToAddAddress,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.green,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 10,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Add new address",
                                style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}