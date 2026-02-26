import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';
import 'package:little_commerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:little_commerce/features/products/data/models/product_model.dart';
import 'package:little_commerce/features/products/presentation/pages/product_detail_page.dart';
import 'package:little_commerce/features/products/presentation/widgets/product_card.dart';

class ProductList extends ConsumerWidget {
  final List<ProductModel> products;

  const ProductList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Products',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppConstants.fontSizeNormal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppConstants.fontSizeMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppConstants.paddingSmall,
              mainAxisSpacing: AppConstants.paddingSmall,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ProductDetailPage(
                        product: product,
                      ),
                    ),
                  );
                },
                child: ProductCard(
                  title: product.title,
                  category: product.category,
                  price: product.price,
                  rating: product.rating,
                  imageUrl: product.image,
                  onAddToCart: () {
                    ref.read(cartProvider.notifier).addToCart(product);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
