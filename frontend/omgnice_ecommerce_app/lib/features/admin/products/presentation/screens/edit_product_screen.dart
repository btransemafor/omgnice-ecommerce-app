import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/error_helper.dart';
import 'package:omgnice_ecommerce_app/core/utils/helpers/success_helper.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'dart:io';
import 'package:omgnice_ecommerce_app/features/admin/products/utils/update_product_utils.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountPercentController;
  late TextEditingController _urlImageController;
  late bool _isHidden;
  late Map<String, double> _variants;
  String? _imageUrl;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isDeletingProduct = false;
  late Map<String, TextEditingController> _variantControllers;

  @override
  void initState() {
    super.initState();

    debugPrint('Received product: ${widget.product.variants.toString()}');
    debugPrint('Product variants: ${widget.product.variants}');

    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _discountPercentController = TextEditingController(text: widget.product.discountPercent.toString());
    _urlImageController = TextEditingController(text: widget.product.imageUrl ?? '');

    _isHidden = widget.product.isHidden;
    _variants = Map.from(widget.product.variants);
    _imageUrl = widget.product.imageUrl;

    _variantControllers = {};
    _variants.forEach((key, value) {
      _variantControllers[key] = TextEditingController(text: value.toString());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountPercentController.dispose();
    _urlImageController.dispose();
    _variantControllers.forEach(( _

, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product name is required')),
      );
      return;
    }

    final discountPercent = int.tryParse(_discountPercentController.text);
    if (discountPercent == null || discountPercent < 0 || discountPercent > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid discount percent (0-100)')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProduct = widget.product.copyWith(
        name: _nameController.text,
        imageUrl: _imageUrl ?? widget.product.imageUrl,
        description: _descriptionController.text,
        isHidden: _isHidden,
        discountPercent: discountPercent,
        variants: _variants,
      );

      final update = extractChangedFields(updatedProduct, widget.product);
      final adProductProvider = Provider.of<AdminProductProvider>(context, listen: false);

      if (widget.product.id == null) {
        throw Exception('Product ID is missing');
      }

      await adProductProvider.updateProduct(widget.product.id!, update, _imageFile);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Updated Successfully',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 4,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, updatedProduct);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

Future<void> deleteProduct() async {
  // Show confirmation dialog
  final bool? confirmDelete = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirm Delete',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );

  // Proceed with deletion only if user confirms
  if (confirmDelete != true) {
    return;
  }

  final product_id = widget.product.id;
  if (product_id == null || product_id.isEmpty) {
    // Use WidgetsBinding to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid product ID'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return;
  }

  setState(() {
    _isDeletingProduct = true;
  });

  try {
    final adProductProvider = Provider.of<AdminProductProvider>(context, listen: false);
    
    debugPrint('Deleting product with ID: $product_id');
    
    await adProductProvider.deleteProduct(product_id);
    
    debugPrint('Delete operation completed. Success: ${adProductProvider.isSuccess}');
    
    // Use WidgetsBinding to ensure safe navigation
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !context.mounted) return;
      
      if (adProductProvider.isSuccess) {
        // Refresh the product list
        await adProductProvider.fetchListProduct();
        
        // Show success message using SnackBar instead of custom helper
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Product deleted successfully!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Wait a bit before navigation to ensure SnackBar is shown
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Safe navigation back
        if (mounted && context.mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        // Show error using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('Failed to delete product. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    
  } catch (e) {
    debugPrint('Error deleting product: $e');
    
    // Use WidgetsBinding for error handling too
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Error deleting product: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  } finally {
    if (mounted) {
      setState(() {
        _isDeletingProduct = false;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final bool showLoadingOverlay = _isDeletingProduct || Provider.of<AdminProductProvider>(context).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.save, color: Colors.white),
            onPressed: _isLoading ? null : _saveChanges,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : _imageUrl != null && _imageUrl!.isNotEmpty
                                      ? Image.network(
                                          _imageUrl!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                    : null,
                                                color: Colors.indigo,
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 63, 181, 89),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Product Image URL
                  _buildSectionTitle('Image'),
                  _buildTextField(
                    controller: _urlImageController,
                    hintText: 'Enter product URL',
                    onChanged: (value) {
                      setState(() {
                        _imageUrl = value;
                      });
                    },
                  ),
                  _buildSectionTitle('Name'),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Enter product name',
                    icon: Icons.shopping_bag,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildSectionTitle('Description'),
                  _buildTextField(
                    controller: _descriptionController,
                    hintText: 'Enter product description',
                    maxLines: 5,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 20),

                  // Discount Percent
                  _buildSectionTitle('Discount Percent'),
                  _buildTextField(
                    controller: _discountPercentController,
                    hintText: 'Enter discount percent',
                    keyboardType: TextInputType.number,
                    icon: Icons.discount,
                  ),
                  const SizedBox(height: 20),

                  // Is Hidden
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility_off,
                            color: Color.fromARGB(255, 177, 181, 206),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Hide Product',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _isHidden,
                            onChanged: (value) {
                              setState(() {
                                _isHidden = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 30, 84, 31),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Variants
                  _buildSectionTitle('Variants'),
                  const SizedBox(height: 8),
                  ..._variants.entries.map((entry) {
                    final variantId = entry.key;
                    final controller = _variantControllers[variantId]!;

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                variantId,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Variant Product',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                style: GoogleFonts.poppins(color: Colors.black87),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Price',
                                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  prefixText: '₫ ',
                                  prefixStyle: GoogleFonts.poppins(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: controller,
                                onChanged: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null) {
                                    setState(() {
                                      _variants[variantId] = parsed;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 30),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (_isLoading || _isDeletingProduct) ? null : deleteProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            child: _isDeletingProduct
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Delete',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 47, 116, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            onPressed: (_isLoading || _isDeletingProduct) ? null : _saveChanges,
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Save Changes',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (showLoadingOverlay)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.green),
                        const SizedBox(height: 16),
                        Text(
                          _isDeletingProduct ? 'Deleting product...' : 'Processing...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color.fromARGB(255, 13, 15, 28),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? icon,
    Function(String)? onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color.fromARGB(255, 161, 164, 183)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13),
                keyboardType: keyboardType,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}