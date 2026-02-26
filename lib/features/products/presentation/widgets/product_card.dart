import 'package:flutter/material.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          _buildInfo(),
        ],
      ),
    );
  }

  // Product Image
  Widget _buildImage() {
    return Stack(
      children: [
        // Image container
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadiusMedium),
            topRight: Radius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            // show loader while image loads
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: 150,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            // show error icon if image fails
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 150,
                child: Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      color: AppColors.grey),
                ),
              );
            },
          ),
        ),

        // Wishlist button
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 18,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }

  // Product Info
  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Product title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Rating
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 2),
              Text(
                rating.toString(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price + Add to cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$$price',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppConstants.fontSizeNormal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusSmall,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}