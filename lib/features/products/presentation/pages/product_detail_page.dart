import 'package:flutter/material.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';
import 'package:little_commerce/features/products/data/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: _buildProductInfo(context),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.cardBackground,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: AppConstants.paddingSmall),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.cardBackground,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Image.network(
            product.image,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadiusXL),
          topRight: Radius.circular(AppConstants.borderRadiusXL),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                ),
                child: Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeNormal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${product.ratingCount} reviews)',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppConstants.fontSizeMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            product.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeXL,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: AppConstants.paddingMedium),
          const Text(
            'Description',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeNormal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            product.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppConstants.fontSizeMedium,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.paddingLarge,
        right: AppConstants.paddingLarge,
        top: AppConstants.paddingMedium,
        bottom:
            MediaQuery.of(context).padding.bottom + AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppConstants.paddingLarge),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: AppConstants.fontSizeNormal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
