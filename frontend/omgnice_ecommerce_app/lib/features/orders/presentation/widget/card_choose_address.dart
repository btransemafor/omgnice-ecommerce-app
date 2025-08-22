import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:provider/provider.dart';

class CardChooseAddress extends StatelessWidget {
  final AddressEntity? selectedAddress;
  
  // Constructor cho phép truyền địa chỉ đã chọn từ bên ngoài (nếu có)
  const CardChooseAddress({this.selectedAddress});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        AddressEntity? addressToShow = selectedAddress ?? addressProvider.defaultAddress();
        
        if (addressToShow == null) {
          return _buildEmptyAddressCard(context, size);
        }
        
        return _buildAddressCard(context, addressToShow, size);
      },
    );
  }
  
  // Widget hiển thị khi không có địa chỉ
  Widget _buildEmptyAddressCard(BuildContext context, Size size) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(15),
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 202, 197, 197),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping Address",
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.036, 
              fontWeight: FontWeight.w600
            )
          ),
          SizedBox(height: 15),
          
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.location_off_outlined, 
                  color: Colors.grey.shade400, 
                  size: 40
                ),
                SizedBox(height: 10),
                Text(
                  'No shipping address available',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.035,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed('myAddress');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 174, 251, 177),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Add Address',
                    style: GoogleFonts.poppins(
                      color: Colors.green, 
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
  
  // Widget hiển thị khi có địa chỉ
  Widget _buildAddressCard(BuildContext context, AddressEntity address, Size size) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 202, 197, 197),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping Address",
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.036, 
              fontWeight: FontWeight.w600
            )
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.green, size: 20),
                  Text(
                    address.fullName ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.035,
                    )
                  ),
                  const SizedBox(width: 10),
                  Text(
                    address.phone?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * 0.024,
                      color: Colors.grey.shade600
                    )
                  )
                ],
              ),

              // Button Change
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: size.width * 0.25,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed('myAddress');
                    },   
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 251, 177),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ), 
                    child: Text(
                      'Change', 
                      style: GoogleFonts.poppins(
                        color: Colors.green, 
                        fontSize: 9
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          
          // Address details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              address.address.details ?? 'No details available',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.033, 
                color: Colors.grey.shade600
              ),
              maxLines: 2,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 20),
            child: Text(
              '${address.address.ward}, ${address.address.district}, ${address.address.province}',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.033, 
                color: Colors.grey.shade600
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Default badge if this is default address
          if (address.is_default == true)
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.028,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}