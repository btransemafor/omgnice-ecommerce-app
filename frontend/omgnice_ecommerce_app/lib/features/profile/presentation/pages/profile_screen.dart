import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/constants/format_currency.dart';
import 'package:omgnice_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:omgnice_ecommerce_app/features/location/presentation/providers/address_provider.dart';
import 'package:omgnice_ecommerce_app/features/profile/presentation/providers/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'package:omgnice_ecommerce_app/core/widgets/commonAvatar.dart';
import 'package:omgnice_ecommerce_app/features/user/presentation/provider/user_provider.dart'
    as user;
import 'package:omgnice_ecommerce_app/core/widgets/custom_loading.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _image;

  // Define theme colors (Green-based palette)
  final Color primaryColor = const Color(0xFF2E7D32); // Forest Green
  final Color secondaryColor = const Color(0xFF4CAF50); // Green
  final Color accentColor = const Color(0xFF81C784); // Light Green
  final Color textPrimaryColor = const Color(0xFF1A1A1A); // Dark Gray
  final Color textSecondaryColor = const Color(0xFF757575); // Gray
  final Color backgroundLightColor =
      const Color(0xFFF1F8E9); // Light Green Background
  final Color cardColor = Colors.white;

  Future<void> pickImageAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile picture selected'),
          backgroundColor: secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Save changes Profile
  void _saveChangeProfile() async {
    final userProvider = context.read<user.UserProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final currentUser = userProvider.user;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user information found.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    // Validate inputs
    if (newEmail.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (newPhone.isNotEmpty && !RegExp(r'^\d{10,12}$').hasMatch(newPhone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final hasChanges = newName != (currentUser.name ?? '') ||
        newEmail != (currentUser.email ?? '') ||
        newPhone != (currentUser.phone ?? '') ||
        _image != null;

    if (!hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save.'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    try {
      final updatedUser = UserEntity(
        isActive: currentUser.isActive,
        id: currentUser.id,
        name: newName,
        email: newEmail,
        phone: newPhone,
      );

      final success = await userProvider.updateUserInfo({
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
      });

      if (success) {
        setState(() {
          _nameController.text = newName;
          _emailController.text = newEmail;
          _phoneController.text = newPhone;
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Updated Profile Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Update failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    final currentUser =
        Provider.of<user.UserProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _phoneController = TextEditingController(text: currentUser?.phone ?? '');

    Future.microtask(() {
      Provider.of<AddressProvider>(context, listen: false).defaultAddress();
      final userProvider =
          Provider.of<user.UserProvider>(context, listen: false);
      userProvider.getProfileUser().then((_) {
        setState(() {
          final updatedUser = userProvider.user;
          _nameController.text = updatedUser?.name ?? '';
          _emailController.text = updatedUser?.email ?? '';
          _phoneController.text = updatedUser?.phone ?? '';
        });
      });
      final userId = currentUser?.id;
      if (userId != null) {
        userProvider.getStatisticUser(userId);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: BeautifulAppBar(title: 'Profile', gradient: true),
      body: RefreshIndicator(
        onRefresh: () async {
          final userProvider =
              Provider.of<user.UserProvider>(context, listen: false);
          final addressProvider =
              Provider.of<AddressProvider>(context, listen: false);

          await Future.wait([
            userProvider.getProfileUser(),
            addressProvider.fetchListAddress(),
          ]);

          setState(() {
            final currentUser = userProvider.user;
            _nameController.text = currentUser?.name ?? '';
            _emailController.text = currentUser?.email ?? '';
            _phoneController.text = currentUser?.phone ?? '';
          });
        },
        child: Consumer<user.UserProvider>(
          builder: (context, userProvider, child) {
            final currentUser = userProvider.user;
            if (currentUser == null) {
              return CustomLoading();
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeaderSection(context, currentUser),
                  const SizedBox(height: 20),
                  _buildStatsSection(),
                  _buildInfoSection(context, currentUser),
                  ElevatedButton(
                    onPressed: _saveChangeProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      elevation: 4,
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, dynamic currentUser) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CommonAvatar(
                    radius: 50,
                    imageUrl: currentUser.avatar ??
                        "https://res.cloudinary.com/dehehzz2t/image/upload/v1745651286/download_e4ryfq.png",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImageAvatar,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _nameController.text.isEmpty
                  ? 'Cuc Vang Cua Shop'
                  : _nameController.text,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(width: 6),
                Text(
                  _emailController.text.isEmpty
                      ? 'No Email'
                      : _emailController.text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final statistic = Provider.of<user.UserProvider>(context).stats;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 20,
          runSpacing: 16,
          children: [
            _buildStatItem(
              onTap: () => context.pushNamed('orderScreen'),
              'Orders',
              statistic?.totalQuantityOrder.toString() ?? '0',
              Icons.shopping_bag_outlined,
            ),
            _buildStatItem(
              onTap: () => context.pushNamed('mypromotion'),
              'Coupons',
              statistic?.totalCoupon?.toString() ?? '24',
              Icons.favorite_border,
            ),
            _buildStatItem(
              'Spending',
              FormatCurrency.formatCurrency(statistic?.totalSpending ?? 0),
              Icons.attach_money,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: secondaryColor, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic currentUser) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              Icons.person_outline,
              'Name',
              _nameController.text,
              context,
            ),
            _buildInfoItem(
              Icons.email_outlined,
              'Email',
              _emailController.text,
              context,
            ),
            _buildInfoItem(
              Icons.phone_outlined,
              'Phone',
              _phoneController.text,
              context,
            ),
            Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                final address = addressProvider.defaultAddr?.address;
                final String finalAddress = address != null
                    ? '${address.ward}, ${address.district}, ${address.province}'
                    : 'Not yet address';
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _buildInfoItem(
                    Icons.location_on_outlined,
                    'Location',
                    finalAddress,
                    context,
                    key: ValueKey(finalAddress),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      IconData icon, String label, String value, BuildContext context,
      {Key? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: accentColor.withOpacity(0.1),
          highlightColor: accentColor.withOpacity(0.05),
          onTap: () {
            switch (label) {
              case "Location":
                context.pushNamed('myAddress').then((_) {
                  Provider.of<AddressProvider>(context, listen: false)
                      .defaultAddress();
                });
                break;
              default:
                _showEditBottomSheet(context, label.toLowerCase());
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: secondaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textPrimaryColor,
                        ),
                        child: Text(value),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: secondaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, String field) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _currentController;
    String _fieldTitle;
    String _fieldHint;
    IconData _fieldIcon;

    switch (field) {
      case 'name':
        _currentController = _nameController;
        _fieldTitle = 'Edit Name';
        _fieldHint = 'Enter your full name';
        _fieldIcon = Icons.person_outline;
        break;
      case 'email':
        _currentController = _emailController;
        _fieldTitle = 'Edit Email';
        _fieldHint = 'Enter your email address';
        _fieldIcon = Icons.email_outlined;
        break;
      case 'phone':
        _currentController = _phoneController;
        _fieldTitle = 'Edit Phone';
        _fieldHint = 'Enter your phone number';
        _fieldIcon = Icons.phone_outlined;
        break;
      default:
        _currentController = _nameController;
        _fieldTitle = 'Edit Profile';
        _fieldHint = 'Enter your information';
        _fieldIcon = Icons.edit_outlined;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: secondaryColor.withOpacity(0.1),
                          child: Icon(
                            _fieldIcon,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _fieldTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: backgroundLightColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: TextFormField(
                        controller: _currentController,
                        decoration: InputDecoration(
                          hintText: _fieldHint,
                          hintStyle: GoogleFonts.poppins(
                            color: textSecondaryColor,
                          ),
                          border: InputBorder.none,
                          icon: Icon(_fieldIcon, color: primaryColor),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: textPrimaryColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          if (field == 'email' &&
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          if (field == 'phone' &&
                              !RegExp(r'^\d{10,12}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.grey[200],
                              foregroundColor: textSecondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
