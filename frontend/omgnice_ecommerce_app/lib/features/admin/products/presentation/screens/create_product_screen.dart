import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/domain/entity/product.dart';
import 'package:omgnice_ecommerce_app/features/admin/products/presentation/provider/admin_product_provider.dart';
import 'package:omgnice_ecommerce_app/features/products/presentation/providers/category_provider.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _stockController = TextEditingController();
  final _discountController = TextEditingController();
  final _smallPriceController = TextEditingController();
  final _mediumPriceController = TextEditingController();
  final _largePriceController = TextEditingController();
  bool isHidden = false;
  String? _selectedCategoryId;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final adProvider =
          Provider.of<AdminProductProvider>(context, listen: false);
      categoryProvider.fetchCategories();
      adProvider.clearNew();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _smallPriceController.dispose();
    _mediumPriceController.dispose();
    _largePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _processImage(File(picked.path));
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _image = imageFile;
    });
  }

  Future<void> _cropImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final croppedFile = await _cropper.cropImage(
      sourcePath: _image!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cắt ảnh',
          toolbarColor: const Color.fromARGB(255, 68, 255, 112),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cắt ảnh',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    debugPrint('=== Bắt đầu submit sản phẩm ===');
    debugPrint('Input values:');
    debugPrint('  Tên sản phẩm: ${_nameController.text}');
    debugPrint('  Mô tả: ${_descController.text}');
    debugPrint('  Tồn kho: ${_stockController.text}');
    debugPrint('  Giảm giá (%): ${_discountController.text}');
    debugPrint('  Giá S: ${_smallPriceController.text}');
    debugPrint('  Giá M: ${_mediumPriceController.text}');
    debugPrint('  Giá L: ${_largePriceController.text}');
    debugPrint('  Danh mục ID: $_selectedCategoryId');
    debugPrint('  Ảnh: ${_image != null ? _image!.path : 'null'}');
    debugPrint(' Hien thi anh: ${isHidden}');

    if (_formKey.currentState!.validate() &&
        _image != null &&
        _selectedCategoryId != null) {
      final provider =
          Provider.of<AdminProductProvider>(context, listen: false);
      final product = Product(
        name: _nameController.text,
        isHidden: isHidden,
        imageUrl: '',
        description: _descController.text,
        variants: {
          '1': double.tryParse(_smallPriceController.text) ?? 0.0,
          '2': double.tryParse(_mediumPriceController.text) ?? 0.0,
          '3': double.tryParse(_largePriceController.text) ?? 0.0,
        },
        category_id: int.tryParse(_selectedCategoryId!) ?? 7,
        discountPercent:
            (double.tryParse(_discountController.text)?.toInt() ?? 0),
      );
      debugPrint('  Giá : ${product.variants}');
      try {
        await provider.addProduct(product, _image!);
        if (provider.errorMessage != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () => provider.clearError(),
                ),
              ),
            );
          }
        } else {
          //context.pushNamed('/adminHomeScreen');
          // Reset form
          _nameController.clear();
          _descController.clear();
          _stockController.clear();
          _discountController.clear();
          _smallPriceController.clear();
          _mediumPriceController.clear();
          _largePriceController.clear();
          _selectedCategoryId = null;
          _image = null;
          await Future.delayed(Duration(seconds: 2));
          provider.setSuccess(false);
          //provider.setSuccess(false);

          _formKey.currentState?.reset();
          setState(() {});
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields and select an image'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<AdminProductProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product',
              style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
              )), 
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 10, right: 5),
          padding: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.white, size: 23),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: productProvider.isLoading ? null : _submit,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Image',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    height: size.width * 0.7,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: _image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(_image!,
                                                fit: BoxFit.cover),
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    color: Colors.grey[600],
                                                    size: 50),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'Upload Product Image',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                if (_image != null)
                                  Positioned(
                                    right: 12,
                                    bottom: 12,
                                    child: FloatingActionButton(
                                      mini: true,
                                      onPressed: _cropImage,
                                      backgroundColor: Colors.white,
                                      child: const Icon(Icons.crop,
                                          color: Colors.blueAccent),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(
                                      Icons.photo_library,
                                      color: Colors.white,
                                    ),
                                    label: const Text('Choose Image'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Basic Information',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(_nameController, 'Product Name',
                                Icons.shopping_bag),
                            _buildTextField(_descController, 'Description',
                                Icons.description,
                                maxLines: 5),
                            _buildTextField(_discountController, 'Discount (%)',
                                Icons.discount,
                                isNumber: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price by Size',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(_smallPriceController,
                                'Small (S) Price', Icons.attach_money,
                                isNumber: true),
                            _buildTextField(_mediumPriceController,
                                'Medium (M) Price', Icons.attach_money,
                                isNumber: true),
                            _buildTextField(_largePriceController,
                                'Large (L) Price', Icons.attach_money,
                                isNumber: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedCategoryId,
                              hint: Text('Select Category',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey)),
                              isDense: true,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down_circle,
                                  color: Colors.green),
                              items:
                                  categoryProvider.categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.id
                                      .toString(), // Fixed: Convert id to string
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryId = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.category,
                                    color: Colors.green),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (value) => value == null
                                  ? 'Please select a category'
                                  : null,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Hidden',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Transform.scale(
                                    scale: 0.6,
                                    child: Switch(
                                      value: isHidden,
                                      activeColor: Colors.green,
                                      onChanged: (value) => setState(() {
                                        isHidden = !isHidden;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: productProvider.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Save Product',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Consumer<AdminProductProvider>(
            builder: (context, adminProductProvider, child) {
              if (adminProductProvider.isLoading) {
                return Container(
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
                            const CircularProgressIndicator(
                                color: Colors.green),
                            const SizedBox(height: 16),
                            const Text(
                              'Uploading product...',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (adminProductProvider.isSuccess &&
                  adminProductProvider.errorMessage == null) {
                return Container(
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
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Product uploaded successfully!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (adminProductProvider.errorMessage != null) {
                return Container(
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
                            const Icon(Icons.error,
                                color: Colors.red, size: 40),
                            const SizedBox(height: 16),
                            Text(
                              adminProductProvider.errorMessage!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        //maxLength: 255,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}
