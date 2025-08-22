import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/services/split_address.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_appbar_common.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/choose_province_district_ward.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  FocusNode focusNodeFullName = FocusNode();
  FocusNode focusNodeFullAddress = FocusNode();
  FocusNode focusNodeDetails = FocusNode();

  String ward = '';
  String district = '';
  String province = '';

  bool _isFocused = false;
  bool isDefault = false;
  bool showPhoneSuggestion = false; // New flag to control suggestion visibility
  UserEntity? user;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        // Show suggestion only if phone number is empty and user.phone exists
        showPhoneSuggestion = _isFocused &&
            phoneNumberController.text.isEmpty &&
            user?.phone != null;
      });
    });
    // Add listener to phoneNumberController to hide suggestion on text change
    phoneNumberController.addListener(() {
      setState(() {
        showPhoneSuggestion = _isFocused &&
            phoneNumberController.text.isEmpty &&
            user?.phone != null;
      });
    });
    // Fetch provinces after first frame
    Future.microtask(() {
      final provider = Provider.of<LocationProvider>(context, listen: false);
      provider.fetchProvinces();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    focusNodeDetails.dispose();
    focusNodeFullName.dispose();
    focusNodeFullAddress.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    fullNameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    const WidgetStateProperty<Color?> trackColor =
        WidgetStateProperty<Color?>.fromMap(
      <WidgetStatesConstraint, Color>{
        WidgetState.selected: Color.fromARGB(255, 6, 154, 23)
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BeautifulAppBar(
        title: 'New Address',
        gradient: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5, right: 5),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                // border: Border.all(color: Colors.grey.shade200,),
              ),
              child: IconButton(
                  onPressed: () {
                    // Todo: Show Return Home ....
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                        contentPadding: const EdgeInsets.all(24),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home_outlined,
                                color: Colors.green[700], size: 40),
                            const SizedBox(height: 16),
                            Text(
                              'Do you want to return home ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        actionsPadding:
                            const EdgeInsets.only(bottom: 16, right: 16),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<ScreenManager>(context, listen: false)
                                  .goToHome();
                              context.goNamed('home');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Yes',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address Information",
                            style: GoogleFonts.poppins(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildChooseInfo(context, size),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Set Address Default',
                            style: GoogleFonts.poppins(
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w500),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: isDefault,
                              trackColor: trackColor,
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: const WidgetStatePropertyAll<Color>(
                                  Colors.white),
                              onChanged: (value) => setState(() {
                                isDefault = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 300),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () async {
                    if (fullNameController.text.isEmpty ||
                        phoneNumberController.text.isEmpty ||
                        addressController.text.isEmpty ||
                        detailsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }
                    try {
                      final fullAddress = addressController.text;
                      List<String> addressParts = fullAddress.split('\n');
                      province = addressParts[0].trim();
                      district =
                          addressParts.length > 1 ? addressParts[1].trim() : '';
                      ward =
                          addressParts.length > 2 ? addressParts[2].trim() : '';
                      if (district.startsWith(" Huyện ")) {
                        district = district.substring(" Huyện ".length);
                      }
                      if (ward.startsWith(" Xã ")) {
                        ward = ward.substring(" Xã ".length);
                      }
                      AddressDetail address_detail = AddressDetail(
                          district: district,
                          ward: ward,
                          province: province,
                          details: detailsController.text);
                      AddressEntity address = AddressEntity(
                          is_default: isDefault,
                          fullName: fullNameController.text,
                          phone: phoneNumberController.text,
                          address: address_detail);
                      await addressProvider.addNewAddress(address);
                      await Provider.of<AddressProvider>(context, listen: false)
                          .fetchListAddress();
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            "Success!",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                          content: Text(
                            "Your address has been saved successfully.",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green.shade700,
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      print("Error saving address: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Có lỗi xảy ra khi lưu địa chỉ")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 6, 154, 23),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Complete',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChooseInfo(BuildContext context, Size size) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField("Full Name",
              controller: fullNameController,
              focusNode: focusNodeFullName,
              nextFocusNode: _focusNode),
          const SizedBox(height: 16),
          _buildField("Phone Number",
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              nextFocusNode: focusNodeFullAddress),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showPhoneSuggestion ? 60 : 0,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: showPhoneSuggestion
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Suggested: ${user!.phone}",
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade800,
                          fontSize: 14,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            phoneNumberController.text = user!.phone as String;
                            showPhoneSuggestion = false; // Hide suggestion
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          "Use now",
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            child: _buildField('Province/District/Ward',
                isIcon: true,
                controller: addressController,
                focusNode: focusNodeFullAddress,
                nextFocusNode: focusNodeDetails),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseProvinceDistrictWard(),
                ),
              );
              if (result != null && result is Map) {
                final fullAddress =
                    '${result['province']}\n${result['district']}\n${result['ward']}';
                addressController.text = fullAddress;
              }
            },
          ),
          const SizedBox(height: 10),
          _buildField('Details',
              controller: detailsController, focusNode: focusNodeDetails),
        ],
      ),
    );
  }

  Widget _buildField(String label,
      {FocusNode? focusNode,
      FocusNode? nextFocusNode,
      TextInputType? keyboardType,
      bool isIcon = false,
      TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          enabled: !isIcon,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            suffixIcon: isIcon
                ? const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey)
                : null,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter $label',
            hintStyle: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 130, 122, 122), fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Color.fromARGB(255, 15, 82, 33)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: GoogleFonts.poppins(
              fontSize: 13, color: const Color.fromARGB(255, 64, 65, 64)),
        ),
      ],
    );
  }
}
