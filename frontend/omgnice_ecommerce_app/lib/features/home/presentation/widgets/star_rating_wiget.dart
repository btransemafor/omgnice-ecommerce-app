import 'package:flutter/material.dart';
// You can replace these colors with your theme or custom color values.
class AppColors {
  static const Color secondaryContainerGray = Color(0xFFB0BEC5);
  static const Color ratingPrimaryColor = Color(0xFFFFD700); // Gold color for rating stars
}
class StarRatingWidget extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color? color;
  const StarRatingWidget({
    super.key,
    this.starCount = 5,
    this.rating = 0.0,  
    this.color,  
  });
 
  Widget buildStar(final BuildContext context, final int index) {
    Icon icon;
    
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,  
        size: 25,
        color: Colors.white,  
      );
    } 
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,  // Half star
        size: 25,
        color: color ?? AppColors.ratingPrimaryColor,  // Default to gold color or custom color
      );
    } 
    // Otherwise, show a full star
    else {
      icon = Icon(
        Icons.star,  
        size: 25,
        color: color ?? AppColors.ratingPrimaryColor, 
      );
    }
    return icon;
  }
  @override
  Widget build(final BuildContext context) {
    // Creating a row of stars based on the starCount
    return Row(
      children: List.generate(
        starCount,  // Generate a row with 'starCount' stars
        (final index) => buildStar(context, index),
      ),
    );
  }
}