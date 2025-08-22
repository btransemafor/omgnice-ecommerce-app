import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omgnice_ecommerce_app/features/reviews/domain/entities/review_entity.dart';

class ProductReviewList extends StatelessWidget {
  final List<ReviewEntity> reviews;

  const ProductReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(child: Text("No reviews yet."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ...reviews.map((review) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildReviewCard(context, review),
            )),
      ],
    );
  }

  String format(DateTime? time) {
    if (time == null) return "---";
    return DateFormat('dd-MM-yyyy, HH:mm:ss').format(time.toLocal());
  }

  Widget _buildReviewCard(BuildContext context, ReviewEntity review) {
    final formatter = DateFormat('dd/MM/yyyy, HH:mm:ss');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        CircleAvatar(
          radius: 22,
          backgroundImage: review.userAvatar != null
              ? NetworkImage(review.userAvatar!)
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        const SizedBox(width: 12),
        // Review content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.userName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 16,
                        color: index < review.ratingStar
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text(review.ratingStar.toDouble().toStringAsFixed(1)),

                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
               format(review.reviewDate),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
