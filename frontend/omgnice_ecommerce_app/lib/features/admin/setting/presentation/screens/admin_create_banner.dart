import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'dart:io';
import 'package:omgnice_ecommerce_app/features/home/domain/entities/banner_entity.dart';
import 'package:omgnice_ecommerce_app/features/home/home.dart';
import 'package:omgnice_ecommerce_app/features/products/domains/entities/caterogy.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:provider/provider.dart';

class BannerManagementScreen extends StatefulWidget {
  @override
  _BannerManagementScreenState createState() => _BannerManagementScreenState();
}

class _BannerManagementScreenState extends State<BannerManagementScreen> {
  List<BannerEntity> banners = [];
  // LOADING BANNERS
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.loadBanners();
      banners = homeProvider.banners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Banner Management",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          leading: Container(
            padding: EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with button to create new banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Banner List',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showBannerForm(context),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Create Banner',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Banner list
            Consumer<HomeProvider>(
                builder: (context, homePro, child) => Expanded(
                      child: homePro.banners.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported,
                                      size: 80, color: Colors.grey[400]),
                                  SizedBox(height: 16),
                                  Text(
                                    'No banners available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Press "Create Banner" to add a new banner',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount:  homePro.banners.length,
                              itemBuilder: (context, index) {
                                return _buildBannerCard( homePro.banners[index]);
                              },
                            ),
                    ))
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(BannerEntity banner) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0, // No elevation for a flatter, modern look
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: InkWell(
          onTap: () => _showBannerForm(context, banner: banner),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.pink.shade100.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        banner.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E2E2E), // Darker, softer gray
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.edit_rounded,
                          color: const Color.fromARGB(255, 52, 192, 6),
                          tooltip: 'Edit',
                          onPressed: () =>
                              _showBannerForm(context, banner: banner),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.delete_rounded,
                          color: Colors.red.shade400,
                          tooltip: 'Delete',
                          onPressed: () => _deleteBanner(banner),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Banner image with playful overlay
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.shade50,
                        Colors.blue.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 160,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    size: 40,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image unavailable',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink.shade300,
                                strokeWidth: 3,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        // Cute overlay badge for Lucky Wheel Banner
                        if (banner.isLuckyWheelBanner)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade200,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow.shade100,
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 16,
                                    color: Colors.yellow.shade800,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Lucky Wheel',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.yellow.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Banner info with cute styling
                _buildInfoRow(
                  icon: Icons.touch_app_rounded,
                  label: 'Action Type:',
                  value: banner.actionType,
                  color: Colors.blue.shade300,
                ),
                _buildInfoRow(
                  icon: Icons.tag_rounded,
                  label: 'Value:',
                  value: banner.actionValue ?? 'N/A',
                  color: Colors.purple.shade300,
                ),
                _buildInfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start Time:',
                  value: _formatDateTime(banner.startTime),
                  color: Colors.green.shade300,
                ),
                _buildInfoRow(
                  icon: Icons.event_rounded,
                  label: 'End Time:',
                  value: _formatDateTime(banner.endTime),
                  color: Colors.green.shade300,
                ),
                if (banner.productId != null)
                  _buildInfoRow(
                    icon: Icons.inventory_rounded,
                    label: 'Product ID:',
                    value: banner.productId.toString(),
                    color: Colors.orange.shade300,
                  ),
                if (banner.categoryId != null)
                  _buildInfoRow(
                    icon: Icons.category_rounded,
                    label: 'Category ID:',
                    value: banner.categoryId.toString(),
                    color: Colors.orange.shade300,
                  ),
                _buildInfoRow(
                  icon: Icons.star_border_rounded,
                  label: 'Lucky Wheel Banner:',
                  value: banner.isLuckyWheelBanner ? 'Yes' : 'No',
                  color: Colors.yellow.shade600,
                ),
                if (banner.createdAt != null)
                  _buildInfoRow(
                    icon: Icons.access_time_rounded,
                    label: 'Created At:',
                    value: _formatDateTime(banner.createdAt!),
                    color: Colors.pink.shade300,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper method for action buttons
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        tooltip: tooltip,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

// Updated _buildInfoRow with cute styling
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showBannerForm(BuildContext context, {BannerEntity? banner}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BannerFormScreen(
          banner: banner,
          onSave: (newBanner) {
            setState(() {
              if (banner != null) {
                // Update existing banner
                int index = banners.indexWhere((b) => b.id == banner.id);
                if (index != -1) {
                  banners[index] = newBanner;
                }
              } else {
                // Create new banner
                /* banners.add(newBanner.copyWith(
                id: DateTime.now().millisecondsSinceEpoch,
                createdAt: DateTime.now(),
              )); */
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteBanner(BannerEntity banner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Confirm Deletion',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E2E2E),
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${banner.title}"?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  banners.removeWhere((b) => b.id == banner.id);
                });

                final homeProvider =
                    Provider.of<HomeProvider>(context, listen: false);

                homeProvider.deleteBanner(banner.id!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleted "${banner.title}"',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    backgroundColor: Colors.green.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/////// ---------------------------- FORM CHỈNH SỬA ------------------------------------- //////

class BannerFormScreen extends StatefulWidget {
  final BannerEntity? banner;
  final Function(BannerEntity) onSave;

  const BannerFormScreen({
    Key? key,
    this.banner,
    required this.onSave,
  }) : super(key: key);

  @override
  _BannerFormScreenState createState() => _BannerFormScreenState();
}

class _BannerFormScreenState extends State<BannerFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _actionValueController = TextEditingController();
  final _productIdController = TextEditingController();
  final _categoryIdController = TextEditingController();
  String _selectedActionType = 'LUCKY_WHEEL';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 30));
  bool _isLuckyWheelBanner = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isActive = false;
  List<Product> products = [];
  List<CategoryModel> categories = [];
  int? selectedProductID;
  Product? selectedProduct;
  CategoryModel? selectedCategory;

  final List<String> _actionTypes = [
    'LUCKY_WHEEL',
    'PRODUCT',
    'CATEGORY',
    'URL',
    'PROMOTION',
  ];

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<AdminProductProvider>(context, listen: false);
    final cateProvider = Provider.of<CategoryProvider>(context, listen: false);
    cateProvider.fetchCategories();
    productProvider.fetchListProduct();
    products = productProvider.listProduct;
    categories = cateProvider.categories;
    // Initialize selectedProduct based on banner
    if (widget.banner?.productId != null) {
      if (products.isNotEmpty) {
        selectedProduct = products.firstWhere(
          (product) => product.id == widget.banner!.productId,
          orElse: () => products.first,
        );
      } else {
        selectedProduct = null;
      }
    }
    // ignore: avoid_print
    print("DEBUG PRINT SẢN PHẦM ${products}");
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    ;
    if (widget.banner != null) {
      _titleController.text = widget.banner!.title;
      _imageUrlController.text = widget.banner!.imageUrl;
      _selectedActionType = widget.banner!.actionType;
      _actionValueController.text = widget.banner!.actionValue ?? '';
      _productIdController.text = widget.banner!.productId?.toString() ?? '';
      _categoryIdController.text = widget.banner!.categoryId?.toString() ?? '';
      _startTime = widget.banner!.startTime;
      _endTime = widget.banner!.endTime;
      _isLuckyWheelBanner = widget.banner!.isLuckyWheelBanner;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _actionValueController.dispose();
    _productIdController.dispose();
    _categoryIdController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 236, 243, 238), // Soft pastel pink background
      appBar: AppBar(
        title: Text(
          widget.banner != null ? 'Edit Banner' : 'Create Banner',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        leading: Container(
          padding: EdgeInsets.only(left: 5),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _saveBanner,
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                _buildTextField(
                  controller: _titleController,
                  label: 'Banner Title',
                  hint: 'Enter banner title',
                  icon: Icons.title_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Image section
                Text(
                  'Banner Image',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(height: 12),
                // Image preview
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    /*     gradient: LinearGradient(
                      colors: [Colors..shade50, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight, */

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : _imageUrlController.text.isNotEmpty
                            ? Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_rounded,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Image unavailable',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      size: 50,
                                      color: Colors.green.shade200,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No image selected',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
                const SizedBox(height: 12),
                // Image buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: Icon(
                          Icons.photo_library_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Gallery',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor:
                              const Color.fromARGB(255, 14, 14, 15),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: Colors.blue.shade100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Camera',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade50,
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: Colors.pink.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Image URL field
                _buildTextField(
                  controller: _imageUrlController,
                  label: 'Image URL',
                  hint: 'Or paste an image URL',
                  icon: Icons.link_rounded,
                ),
                const SizedBox(height: 20),
                // Action type dropdown
                _buildDropdown(
                  label: 'Action Type',
                  value: _selectedActionType,
                  items: _actionTypes,
                  icon: Icons.touch_app_rounded,
                  onChanged: (value) {
                    setState(() {
                      _selectedActionType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Action value field
               /*  _buildTextField(
                  controller: _actionValueController,
                  label: 'Action Value',
                  hint: 'Enter action value',
                  icon: Icons.tag_rounded,
                 /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an action value';
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 20), */
                // Product ID and Category ID

                _buildProductDropdown(
                  label: 'Product (Optional)',
                  value: selectedProduct,
                  items: products,
                  icon: Icons.inventory_rounded,
                  onChanged: (Product? newValue) {
                    setState(() {
                      selectedProduct = newValue;
                      _productIdController.text = selectedProduct!.id!;
                      print(
                          "Bạn đã chọn product cho id: ${_productIdController.text}");
                    });
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                _buildCategoryDropdown(
                  label: "Category (Optional)",
                  value: selectedCategory,
                  items: categories,
                  icon: Icons.category_outlined,
                  onChanged: (CategoryModel? cates) {
                    setState(() {
                      selectedCategory = cates;
                      _categoryIdController.text =
                          selectedCategory!.id.toString();

                      print(
                          "Bạn đã chọn category có id: ${_categoryIdController.text}");
                    });
                  },
                ),

                /*  Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _productIdController,
                        label: 'Product ID',
                        hint: 'Optional',
                        icon: Icons.inventory_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _categoryIdController,
                        label: 'Category ID',
                        hint: 'Optional',
                        icon: Icons.category_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ), */
                const SizedBox(height: 20),
                // Date time pickers
                _buildDateTimePicker(
                  label: 'Start Time',
                  dateTime: _startTime,
                  icon: Icons.calendar_today_rounded,
                  onChanged: (dateTime) {
                    setState(() {
                      _startTime = dateTime;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDateTimePicker(
                  label: 'End Time',
                  dateTime: _endTime,
                  icon: Icons.event_rounded,
                  onChanged: (dateTime) {
                    setState(() {
                      _endTime = dateTime;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Lucky wheel banner checkbox
                CheckboxListTile(
                  title: Text(
                    'Lucky Wheel Banner',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                  subtitle: Text(
                    'Mark as a special lucky wheel banner',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  value: _isLuckyWheelBanner,
                  onChanged: (value) {
                    setState(() {
                      _isLuckyWheelBanner = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color.fromARGB(255, 27, 201, 47),
                  checkColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color.fromARGB(255, 27, 201, 47),
                  checkColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    "Active",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                  value: _isActive,
                  onChanged: (value) => {
                    setState(() {
                      _isActive = value ?? false;
                      print("Bật kích hoạt Is Active cho banners");
                    })
                  },
                ),

                const SizedBox(height: 10),
                const SizedBox(height: 40),
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveBanner,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 18, 176, 60),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: Colors.pink.shade200,
                    ),
                    child: Text(
                      widget.banner != null ? 'Update Banner' : 'Create Banner',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E2E2E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              prefixIcon: icon != null
                  ? Icon(icon,
                      color: const Color.fromARGB(255, 8, 165, 24), size: 20)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF2E2E2E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E2E2E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.green.shade300, size: 20)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF2E2E2E),
            ),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.green.shade300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime dateTime,
    required void Function(DateTime) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E2E2E),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDateTime(context, dateTime, onChanged),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.green.shade300, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _formatDateTime(dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.green.shade300,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context, DateTime initialDateTime,
      void Function(DateTime) onChanged) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink.shade400,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.pink.shade400,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onChanged(newDateTime);
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _imageUrlController.clear();
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _imageUrlController.clear();
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _saveBanner() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _imageUrlController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select an image or enter an image URL',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      if (_startTime.isAfter(_endTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Start time must be before end time',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      final banner = BannerEntity(
        id: widget.banner?.id,
        title: _titleController.text,
        imageUrl: _selectedImage != null
            ? 'local_image_${DateTime.now().millisecondsSinceEpoch}'
            : _imageUrlController.text,
        actionType: _selectedActionType,
        actionValue: _actionValueController.text,
        productId: _productIdController.text.isNotEmpty
            ? int.tryParse(_productIdController.text)
            : null,
        categoryId: _categoryIdController.text.isNotEmpty
            ? int.tryParse(_categoryIdController.text)
            : null,
        startTime: _startTime,
        endTime: _endTime,
        isLuckyWheelBanner: _isLuckyWheelBanner,
        createdAt: widget.banner?.createdAt ?? DateTime.now(),
      );

      widget.onSave(banner);

      homeProvider.createBanner(banner);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.banner != null ? 'Banner updated' : 'Banner created',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: Colors.green.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      Navigator.of(context).pop();
    }
  }
}

Widget _buildProductDropdown({
  required String label,
  required Product? value,
  required List<Product> items,
  required void Function(Product?) onChanged,
  IconData? icon,
}) {
  // Handle empty product list
  if (items.isEmpty) {
    return Text(
      'No products available',
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2E2E2E),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<Product>(
          value: value,
          items: items.map((Product product) {
            return DropdownMenuItem<Product>(
              value: product,
              child: Text(
                product.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF2E2E2E),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        /*   validator: (value) {
            if (value == null) {
              return 'Please select a product';
            }
            return null;
          }, */
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.green.shade300, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.pink.shade300,
          ),
        ),
      ),
    ],
  );
}

Widget _buildCategoryDropdown(
    {required String label,
    required CategoryModel? value,
    required List<CategoryModel> items,
    required void Function(CategoryModel?) onChanged,
    IconData? icon}) {
  // Handle empty category list
  if (items.isEmpty) {
    return Text(
      'No categories available',
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2E2E2E),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<CategoryModel>(
          value: value,
          items: items.map((CategoryModel category) {
            return DropdownMenuItem<CategoryModel>(
              value: category,
              child: Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF2E2E2E),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.green.shade300, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.green.shade300,
          ),
        ),
      ),
    ],
  );
}
