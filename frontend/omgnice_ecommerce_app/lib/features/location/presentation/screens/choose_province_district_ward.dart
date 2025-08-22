import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/location_provider.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/widgets/card_address.dart';
import 'package:provider/provider.dart';

class ChooseProvinceDistrictWard extends StatefulWidget {
  const ChooseProvinceDistrictWard({super.key});

  @override
  State<ChooseProvinceDistrictWard> createState() =>
      _ChooseProvinceDistrictWardState();
}

class _ChooseProvinceDistrictWardState
    extends State<ChooseProvinceDistrictWard> {
  final TextEditingController searchController = TextEditingController();
  int? selectedIndex;

 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<LocationProvider>(context, listen: false); 

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(provider, size),
      body: Consumer<LocationProvider>(
        builder: (context, provider, _) {
          return provider.isLoading ? Center(child: CustomLoading()) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!provider.isInit ||
                  provider.selectedNameProvince.isNotEmpty ||
                  provider.selectedNameDistrict.isNotEmpty ||
                  provider.selectedNameWard.isNotEmpty)
                _buildSelectedLocation(provider, size),
              _buildSectionHeader(provider),
              Expanded(child: _buildLocationList(provider)),
            ],
          );
        },
      ),
    );
  }
// ignore: non_constant_identifier_names
AppBar _buildAppBar(LocationProvider locationProvider, Size size) {
  return AppBar(
    backgroundColor: Colors.white,
    toolbarHeight: 70, 
    leading: Container(
      margin: const EdgeInsets.only(top:14, left: 14, bottom: 14), // Thu nhỏ margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.withOpacity(0.3),
      ),
      child: const Center(child: BackButton(color: Colors.black)),
    ),
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        margin: const EdgeInsets.only(left: 70, right: 15, top: 15), // Điều chỉnh margin
        padding: const EdgeInsets.only(top: 15), // Giảm padding trên cùng
        child: Center(
          child: SizedBox(
            height: 40, 
            child: TextField(
              onChanged: (query) {
                if (!locationProvider.isChooseProvince) {
                  locationProvider.searchLocation(query, "province");
                } else if (!locationProvider.isChooseDistrict && 
                          locationProvider.isChooseProvince && 
                          !locationProvider.isChooseWard) {
                  locationProvider.searchLocation(query, 'district');
                } else {
                  locationProvider.searchLocation(query, 'ward');
                }
              },
              controller: searchController,
              style: GoogleFonts.poppins(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search province/district/ward...',  // Thu gọn hint text
                hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey), // Thu nhỏ icon
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0), // Giảm padding bên trong
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 0.5), // Thu nhỏ độ dày đường viền
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey.shade300), // Làm mỏng viền
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Color(0xFF0F521F)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
  Widget _buildSelectedLocation(LocationProvider provider, Size size) {
    if (provider.selectedNameProvince.isEmpty &&
        provider.selectedNameDistrict.isEmpty &&
        provider.selectedNameWard.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, top: 7, right: 10),
      constraints: const BoxConstraints(minHeight: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Location',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade500,
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.resetToChooseProvince();
                  provider.clearSearch(); 
                  setState(() {
                    selectedIndex = null;
                  });
                  SuccessHelper.showSuccess(this.context, 'Reset Address'); 
                  // Don't navigate back - just stay on this screen
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                child: Text(
                  "Thiết lập lại",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          if (provider.selectedNameProvince.isNotEmpty)
            GestureDetector(
              onTap: () => provider.resetToChooseProvince(),
              child: CardAddress(
                text: provider.selectedNameProvince,
                is_province: true,
                is_district: false,
                is_ward: false,
                isActive: provider.isChooseProvince,
              ),
            ),
          if (provider.selectedNameDistrict.isNotEmpty)
            GestureDetector(
              onTap: () => provider.resetToChooseDistrict(),
              child: CardAddress(
                text: provider.selectedNameDistrict,
                is_province: false,
                is_district: true,
                is_ward: false,
                isActive: provider.isChooseDistrict,
              ),
            ),
          if (provider.selectedNameWard.isNotEmpty)
            GestureDetector(
              onTap: () => provider.resetToChooseWard(),
              child: CardAddress(
                text: provider.selectedNameWard,
                is_province: false,
                is_district: false,
                is_ward: true,
                isActive: provider.isChooseWard,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(LocationProvider provider) {
    String title = 'Select Province';
    IconData icon = Icons.location_city_outlined;

    if (provider.isChooseProvince && !provider.isChooseWard && !provider.isChooseDistrict) {
      title = 'Select District';
      icon = Icons.business;
    } else if (provider.isChooseDistrict && provider.isChooseProvince) {
      title = 'Select Ward';
      icon = Icons.home_work_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3DB10F)),
          const SizedBox(width: 8),
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationList(LocationProvider provider) {
    if (!provider.isChooseProvince) {
      return _buildGenericList(
        items: provider.provincesToDisplay,
        nameSelector: (item) => item.name,
        onTap: (item) {
          provider.filterDistrictById(item.id);
        },
        isSelected: (item) => item.id == provider.selectedProvinceId,
      );
    } else if (!provider.isChooseDistrict) {
      return _buildGenericList(
        items: provider.districtsToDisplay,
        nameSelector: (item) => item.full_name,
        onTap: (item) {
          provider.filterWardById(item.id); // Da set selectedNameDistrict
          provider.selectedDistrictId = item.id;
        },
        isSelected: (item) => item.id == provider.selectedDistrictId,
      );
    } else {
      return _buildGenericList(
        items: provider.wardsToDisplay,
        nameSelector: (item) => item.full_name,
        onTap: (item) async {
          provider.getNameWardById(item.id);
          //await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(this.context, {
            'province': provider.selectedNameProvince,
            'district': provider.selectedNameDistrict,
            'ward': provider.selectedNameWard,
          });
        },
        isSelected: (item) => item.id == provider.selectedWardId,
      );
    }
  }



Widget _buildGenericList<T>({
  required List<T> items,
  required String Function(T) nameSelector,
  required void Function(T) onTap,
  bool Function(T)? isSelected,
  IconData itemIcon = Icons.place,
  Size? size 
}) {
  return ListView.separated(
    itemCount: items.length,
    padding: const EdgeInsets.symmetric(vertical: 12),
    physics: const BouncingScrollPhysics(),
    separatorBuilder: (_, __) => Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.withOpacity(0.2),
    ),
    itemBuilder: (context, index) {
      final item = items[index];
      final selected = isSelected?.call(item) ?? false;
      
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: selected ? const Color(0xFFEEF7F1) : Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(item),
            splashColor: const Color(0xFF2C6E49).withOpacity(0.1),
            highlightColor: const Color(0xFF2C6E49).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF2C6E49).withOpacity(0.1) : Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      itemIcon,
                      color: selected ? const Color(0xFF2C6E49) : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      nameSelector(item),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: selected ? const Color(0xFF2C6E49) : Colors.black87,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (selected)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 1.0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C6E49),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
