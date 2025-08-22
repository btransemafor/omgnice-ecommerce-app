import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:omgnice_ecommerce_app/features/promotion/domain/entities/promotion.dart';
import 'package:omgnice_ecommerce_app/features/promotion/presentation/provider/promotion_provider.dart';
import 'package:provider/provider.dart';

class CreatePromotionScreen extends StatefulWidget {
  const CreatePromotionScreen({super.key});

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _maxDiscountValueController = TextEditingController();
  final _minOrderValueController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _productIdController = TextEditingController();
  final _categoryIdController = TextEditingController();

  DateTime _startDate = DateTime.now(); // Default to today: 2025-05-22
  DateTime _endDate = DateTime.now()
      .add(const Duration(days: 7)); // Default +7 days: 2025-05-29
  String _type = 'percentage'; // Default type
  String _appliesTo = 'ALL'; // Default applies_to
  bool _isManual = false;
  bool _isActive = true;
  bool _isExclusive = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _discountValueController.dispose();
    _maxDiscountValueController.dispose();
    _minOrderValueController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _productIdController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      setState(() => _isLoading = true);
      try {
        final data = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'discount_type': _type.toUpperCase(),
          'discount_value': double.parse(_discountValueController.text),
          'max_discount_value': _maxDiscountValueController.text.isNotEmpty
              ? double.parse(_maxDiscountValueController.text)
              : null,
          'min_order_value': _minOrderValueController.text.isNotEmpty
              ? double.parse(_minOrderValueController.text)
              : null,
          'applies_to': _appliesTo,
          'product_id': _appliesTo == 'PRODUCT'
              ? int.parse(_productIdController.text)
              : null,
          'category_id': _appliesTo == 'CATEGORY'
              ? int.parse(_categoryIdController.text)
              : null,
          'start_date': _startDate.toIso8601String(),
          'end_date': _endDate.toIso8601String(),
          'usage_limit': _quantityController.text.isNotEmpty
              ? int.parse(_quantityController.text)
              : null,
          'min_quantity': int.parse(_minQuantityController.text),
          'code': _isManual ? _codeController.text : null,
          'is_active': _isActive,

          'is_exclusive' :  _isExclusive
        };

        print('Submitting promotion data: $data');

        // Tao object promotion
        PromotionEntity promotionEntity = PromotionEntity(
          title: _titleController.text,
          description: _descriptionController.text,
          discountType: _type.toUpperCase(),
          discountValue: double.parse(_discountValueController.text),
          maxDiscountValue: _maxDiscountValueController.text.isNotEmpty
              ? double.parse(_maxDiscountValueController.text)
              : null,
          minOrderValue: _minOrderValueController.text.isNotEmpty
              ? double.parse(_minOrderValueController.text)
              : null,
          appliesTo: _appliesTo,
          productId: _appliesTo == 'PRODUCT'
              ? int.parse(_productIdController.text)
              : null,
          categoryId: _appliesTo == 'CATEGORY'
              ? int.parse(_categoryIdController.text)
              : null,
          startDate: _startDate,
          endDate: _endDate,
          usageLimit: _quantityController.text.isNotEmpty
              ? int.parse(_quantityController.text)
              : null,
          //    'min_quantity': int.parse(_minQuantityController.text),
          code: _isManual ? _codeController.text : null,
          isActive: _isActive,
          isExclusive: _isExclusive,
        );

        String isManual = '';

        final provider = Provider.of<PromotionProvider>(context, listen: false);
        if (_isManual) {
          await provider.createPromotion(promotionEntity, 'True');
        } else {
          await provider.createPromotion(promotionEntity);
        }

        if (provider.isSuccess) {
          _showSnackBar('Added Voucher Successfully', Colors.green);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
        _showSnackBar(_errorMessage!, Colors.redAccent);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Create Promotion',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
          )
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              physics: const BouncingScrollPhysics(),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green.shade50,
                              radius: 20,
                              child: Icon(
                                Icons.local_offer,
                                color: Colors.green.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create New Promotion',
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Manage your promotions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Title',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter promotion title',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.title,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                          validator: (value) =>
                              value!.isEmpty ? 'Title is required' : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Description',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter promotion description',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.description,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                          validator: (value) =>
                              value!.isEmpty ? 'Description is required' : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Discount Type',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _type,
                            decoration: InputDecoration(
                              hintText: 'Select type',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              prefixIcon: Icon(Icons.category,
                                  color: Colors.green.shade600, size: 20),
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.green.shade600, size: 20),
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade800),
                            items: ['percentage', 'fixed'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() => _type = newValue!);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Discount Value',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _discountValueController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter discount value',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.percent,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                          validator: (value) => value!.isEmpty
                              ? 'Discount value is required'
                              : null,
                        ),
                        if (_type == 'percentage') ...[
                          const SizedBox(height: 20),
                          Text(
                            'Max Discount Value',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _maxDiscountValueController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter max discount value (optional)',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.green.shade400, width: 1.5),
                              ),
                              prefixIcon: Icon(Icons.money_off,
                                  color: Colors.green.shade600, size: 20),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade800),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          'Minimum Order Value',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _minOrderValueController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter minimum order value (optional)',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.attach_money,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Applies To',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _appliesTo,
                            decoration: InputDecoration(
                              hintText: 'Select applies to',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              prefixIcon: Icon(Icons.select_all,
                                  color: Colors.green.shade600, size: 20),
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.green.shade600, size: 20),
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade800),
                            items: ['ALL', 'PRODUCT', 'CATEGORY']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() => _appliesTo = newValue!);
                            },
                          ),
                        ),
                        if (_appliesTo == 'PRODUCT') ...[
                          const SizedBox(height: 20),
                          Text(
                            'Product ID',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _productIdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter product ID',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.green.shade400, width: 1.5),
                              ),
                              prefixIcon: Icon(Icons.production_quantity_limits,
                                  color: Colors.green.shade600, size: 20),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade800),
                            validator: (value) => value!.isEmpty
                                ? 'Product ID is required'
                                : null,
                          ),
                        ],
                        if (_appliesTo == 'CATEGORY') ...[
                          const SizedBox(height: 20),
                          Text(
                            'Category ID',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _categoryIdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter category ID',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.green.shade400, width: 1.5),
                              ),
                              prefixIcon: Icon(Icons.category,
                                  color: Colors.green.shade600, size: 20),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey.shade800),
                            validator: (value) => value!.isEmpty
                                ? 'Category ID is required'
                                : null,
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Date',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  OutlinedButton(
                                    onPressed: () => _selectDate(context, true),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.green.shade400),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(_startDate),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey.shade800),
                                        ),
                                        Icon(Icons.calendar_today,
                                            color: Colors.green.shade600,
                                            size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End Date',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  OutlinedButton(
                                    onPressed: () =>
                                        _selectDate(context, false),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.green.shade400),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(_endDate),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey.shade800),
                                        ),
                                        Icon(Icons.calendar_today,
                                            color: Colors.green.shade600,
                                            size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Usage Limit',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter usage limit (optional)',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.format_list_numbered,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Minimum Quantity',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _minQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter minimum quantity',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.format_list_numbered_rtl,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                          validator: (value) => value!.isEmpty
                              ? 'Minimum quantity is required'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Manual Code',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Switch(
                              value: _isManual,
                              onChanged: (value) =>
                                  setState(() => _isManual = value),
                              activeColor: Colors.green.shade600,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _codeController,
                          enabled: _isManual,
                          decoration: InputDecoration(
                            hintText: 'Enter custom code (if manual)',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: _isManual
                                ? Colors.grey.shade50
                                : Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.green.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.code,
                                color: Colors.green.shade600, size: 20),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade800),
                          validator: _isManual
                              ? (value) =>
                                  value!.isEmpty ? 'Code is required' : null
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Active',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Switch(
                              value: _isActive,
                              onChanged: (value) =>
                                  setState(() => _isActive = value),
                              activeColor: Colors.green.shade600,
                            ),
                          ],
                        ),

                         Row(
                          children: [
                            Text(
                              'Exclusive',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Switch(
                              value: _isExclusive,
                              onChanged: (value) =>
                                  setState(() => _isExclusive = value),
                              activeColor: Colors.green.shade600,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_titleController.text.isNotEmpty ||
                            _descriptionController.text.isNotEmpty ||
                            _discountValueController.text.isNotEmpty ||
                            _quantityController.text.isNotEmpty ||
                            _minQuantityController.text.isNotEmpty) ...[
                          Text(
                            'Preview',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _titleController.text.isEmpty
                                      ? 'No title'
                                      : _titleController.text,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _descriptionController.text.isEmpty
                                      ? 'No description'
                                      : _descriptionController.text,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Type: ${_type.toUpperCase()} - Discount: ${_discountValueController.text}${_type == 'percentage' ? '%' : ''}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                if (_type == 'percentage' &&
                                    _maxDiscountValueController.text.isNotEmpty)
                                  Text(
                                    'Max Discount: ${_maxDiscountValueController.text}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                if (_minOrderValueController.text.isNotEmpty)
                                  Text(
                                    'Min Order: ${_minOrderValueController.text}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                Text(
                                  'Applies To: $_appliesTo',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                if (_appliesTo == 'PRODUCT')
                                  Text(
                                    'Product ID: ${_productIdController.text}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                if (_appliesTo == 'CATEGORY')
                                  Text(
                                    'Category ID: ${_categoryIdController.text}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                Text(
                                  'Code: ${_isManual ? _codeController.text : 'Auto-generated'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Valid: ${DateFormat('yyyy-MM-dd').format(_startDate)} to ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Usage Limit: ${_quantityController.text.isEmpty ? 'Unlimited' : _quantityController.text} (Min Quantity: ${_minQuantityController.text})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Status: ${_isActive ? 'Active' : 'Inactive'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              shadowColor: Colors.green.shade200,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.save,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Create Promotion',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
