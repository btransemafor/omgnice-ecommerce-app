import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:omgnice_ecommerce_app/core/widgets/beautiful_appBar.dart';
import 'dart:io';
import 'package:omgnice_ecommerce_app/features/orders/domains/entities/order_item_entity.dart';
import 'package:omgnice_ecommerce_app/features/reviews/presentation/provider/review_provider.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final OrderItemEntity item;
  final String orderId; 

  const ReviewScreen({super.key, required this.item, required this.orderId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 0;
  String reviewText = '';
  List<File> reviewImages = [];
  bool isSubmitting = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (reviewImages.length >= 5) {
      _showSnackBar('You can only add up to 5 images', isError: true);
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          reviewImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showSnackBar('Could not select image', isError: true);
    }
  }

  void _removeImage(File image) {
    setState(() {
      reviewImages.remove(image);
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (rating == 0) {
      _showSnackBar('Please select a star rating', isError: true);
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      _showSnackBar('Please write a review about the product', isError: true);
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final reviewData = {
        'order_line_id': widget.item.order_line_id.toString(),
        'rating_star': rating.toString(),
        'comment': _commentController.text.trim(),
      };
      print(jsonEncode(reviewData));

      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      //final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final success = await reviewProvider.createReview(reviewData);

      if (success) {
        _showSnackBar('Review submitted successfully!');
      //  orderProvider.updateOrderItemLocal(widget.orderId, widget.item.order_line_id!);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context, true); // Return true to indicate success
        });
      } else {
        final error = reviewProvider.createError ?? 'An error occurred';
        _showSnackBar('❌ Failed to submit review: $error', isError: true);
      }
    } catch (e) {
      _showSnackBar('❌ An error occurred: $e', isError: true);
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ReviewScreen build called $context ${widget.item.order_line_id}');
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BeautifulAppBar(title: 'Product Review', gradient: true,), 
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info Card
                  _buildProductInfoCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Rating Section
                  _buildRatingSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Comment Section
                  _buildCommentSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Image Upload Section
                  _buildImageUploadSection(),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Submit Button (Fixed at bottom)
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.network(
                widget.item.thumbnail ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.productName ?? 'Product Name',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                if (widget.item.variantName != null && widget.item.variantName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      widget.item.variantName!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Quantity: ${widget.item.quantity ?? 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rate, color: Colors.amber[600], size: 24),
              const SizedBox(width: 8),
              Text(
                'Your Rating',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    rating = index + 1;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: index < rating ? Colors.amber[500] : Colors.grey[400],
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          Center(
            child: Text(
              rating == 0 
                ? 'Tap to rate'
                : _getRatingText(rating),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: rating == 0 ? Colors.grey[500] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return 'Very Dissatisfied';
      case 2: return 'Dissatisfied';
      case 3: return 'Neutral';
      case 4: return 'Satisfied';
      case 5: return 'Very Satisfied';
      default: return '';
    }
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              Text(
                'Your Review',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 500,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Share your experience with this product...',
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green[500]!, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              counterStyle: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.purple[600], size: 24),
              const SizedBox(width: 8),
              Text(
                'Add Images',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Text(
                '(${reviewImages.length}/5)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Add Image Button
          InkWell(
            onTap: reviewImages.length < 5 ? _pickImage : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: reviewImages.length < 5 ? Colors.green[300]! : Colors.grey[300]!,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: reviewImages.length < 5 ? Colors.green[50] : Colors.grey[50],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 32,
                      color: reviewImages.length < 5 ? Colors.green[600] : Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reviewImages.length < 5 ? 'Add Images' : 'Limit Reached',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: reviewImages.length < 5 ? Colors.green[600] : Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Image Gallery
          if (reviewImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: reviewImages.length,
              itemBuilder: (context, index) {
                final image = reviewImages[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.file(
                          image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(image),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            disabledBackgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Submitting...',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Submit Review',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}