import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/features/home/providers/screen_manager.dart';
import 'package:omgnice_ecommerce_app/features/location/domains/entities/address_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/location_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/screens/choose_province_district_ward.dart';
import 'package:provider/provider.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_appbar_common.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressEntity addressToEdit;

  const EditAddressScreen({super.key, required this.addressToEdit});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController addressController;
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController detailsController;

  String ward = '';
  String district = '';
  String province = '';

  bool _isFocused = false;
  late bool isDefault;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      // Fetch List Tinh THanh VN
      Future.microtask(() {
        final provider = Provider.of<LocationProvider>(context, listen: false);
        // Fetch
        provider.fetchProvinces();
      });
    });

    fullNameController =
        TextEditingController(text: widget.addressToEdit.fullName);
    phoneNumberController =
        TextEditingController(text: widget.addressToEdit.phone);
    detailsController =
        TextEditingController(text: widget.addressToEdit.address.details);

    // Tạo địa chỉ đầy đủ để hiển thị trong trường Province/District/Ward
    final String fullAddress = '${widget.addressToEdit.address.province}\n'
        '${widget.addressToEdit.address.district}\n'
        '${widget.addressToEdit.address.ward}';
    addressController = TextEditingController(text: fullAddress);

    // Lưu các giá trị riêng lẻ để sử dụng khi cập nhật
    province = widget.addressToEdit.address.province;
    district = widget.addressToEdit.address.district;
    ward = widget.addressToEdit.address.ward;

    // Thiết lập trạng thái mặc định
    isDefault = widget.addressToEdit.is_default;

    // Gọi fetch sau 1 frame để tránh lỗi context chưa sẵn sàng
    Future.microtask(() {
      final provider = Provider.of<LocationProvider>(context, listen: false);
      provider.fetchProvinces();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  /// ------------------ DELETE FUNCTION ------------------ ///

  void handleDelete(String id) async {
    final provider = Provider.of<AddressProvider>(context, listen: false);
    if (provider.isSuccess) {
      // Show success message first
      SuccessHelper.showSuccess(context, 'Deleted Address Successfully!');
      await provider.deleteAddress(id);
      // Check if still mounted and pop
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushNamed(context, '/my-address_screen');
        }
      });
    } else {
      ErrorHelper.showError(context, 'Delete Address Failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    // Otherwise, it resolves to null and defers to values from the theme data.
    const WidgetStateProperty<Color?> trackColor =
        WidgetStateProperty<Color?>.fromMap(
      <WidgetStatesConstraint, Color>{
        WidgetState.selected: Color.fromARGB(255, 6, 154, 23)
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BeautifulAppBar(
        title: 'Edit Address',
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
              padding: const EdgeInsets.only(bottom: 80), // Tránh nút bị đè
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
                          _buildChooseInfo(
                              context, MediaQuery.of(context).size),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// -------------- PART 2 --------------- ///

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

          /// Nút "Save Changes"

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //// ------------ Button 1 ----------------- ///
                    ElevatedButton(
                      onPressed: () => handleDelete(widget.addressToEdit.id!),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor:
                              const Color.fromARGB(255, 240, 216, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),

                            // Vien
                            side: BorderSide(width: 2, color: Colors.red),
                          )),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 247, 38, 31),
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 20,
                    ),

                    /// ------------- Button 2 ----------------- ///

                    ElevatedButton(
                      onPressed: () async {
                        // Kiểm tra dữ liệu đầu vào
                        if (fullNameController.text.isEmpty ||
                            phoneNumberController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            detailsController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Please fill in all fields")),
                          );
                          return;
                        }

                        try {
                          final fullAddress = addressController.text;
                          print(fullAddress);

                          // Tách địa chỉ trực tiếp từ các dòng
                          List<String> addressParts = fullAddress.split('\n');

                          province = addressParts[0].trim();
                          district = addressParts.length > 1
                              ? addressParts[1].trim()
                              : '';
                          ward = addressParts.length > 2
                              ? addressParts[2].trim()
                              : '';

                          // Lọc các tiền tố không cần thiết
                          if (district.startsWith(" Huyện ")) {
                            district = district.substring(" Huyện ".length);
                          }
                          if (ward.startsWith(" Xã ")) {
                            ward = ward.substring(" Xã ".length);
                          }

                          final updateData = {
                            'fullName': fullNameController.text,
                            'phone': phoneNumberController.text,
                            'is_default': isDefault,
                            'ward': ward,
                            'district': district,
                            'province': province,
                            'details': detailsController.text,
                          };

                          // Cập nhật địa chỉ
                          await addressProvider.updateAddress(
                              widget.addressToEdit.id!, updateData);

                          // Fetch lại dữ liệu
                          await Provider.of<AddressProvider>(context,
                                  listen: false)
                              .fetchListAddress();

                          // Hiển thị dialog thành công
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.white,
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
                                "Your address has been updated successfully.",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(
                                        context, true); // Go back with result
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
                          print("Error updating address: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Có lỗi xảy ra khi cập nhật địa chỉ")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          backgroundColor:
                              const Color.fromARGB(255, 17, 97, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChooseInfo(
    BuildContext context,
    Size size,
  ) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField("Full Name", controller: fullNameController),
          const SizedBox(height: 16),

          _buildField("Phone Number",
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              controller: phoneNumberController),
          const SizedBox(height: 16),

          // Gợi ý số
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isFocused ? 60 : 0,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Suggested: 0338498306",
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade800,
                      fontSize: 14,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      phoneNumberController.text = "0338498306";
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
              )),
          const SizedBox(height: 5),
          GestureDetector(
              child: _buildField('Province/District/Ward',
                  isIcon: true, controller: addressController),
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
                  // Gán giá trị vào TextEditingController để hiển thị
                  addressController.text = fullAddress;

                  // Cập nhật các biến để sử dụng khi lưu
                  province = result['province'];
                  district = result['district'];
                  ward = result['ward'];
                }
              }),
          const SizedBox(
            height: 10,
          ),

          _buildField('Details', controller: detailsController),
        ],
      ),
    );
  }

  Widget _buildField(String label,
      {FocusNode? focusNode,
      TextInputType? keyboardType,
      bool isIcon = false,
      TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 3,
          minLines: 1,
          enabled: isIcon ? false : true,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: isIcon
                ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                : SizedBox.shrink(),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter $label',
            hintStyle: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 130, 122, 122), fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 1),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: const Color.fromARGB(255, 15, 82, 33)),
                borderRadius: BorderRadius.circular(10)),
          ),
          style: GoogleFonts.poppins(
              fontSize: 13, color: const Color.fromARGB(255, 64, 65, 64)),
        ),
      ],
    );
  }
}
