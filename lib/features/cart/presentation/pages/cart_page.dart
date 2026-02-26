import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';
import 'package:little_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:little_commerce/features/cart/presentation/providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeLarge,
          ),
        ),
        actions: [
          if (cartState.items.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: cartState.items.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartContent(context, ref, cartState),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          const Text(
            'Add products to get started',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppConstants.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: const Text(
                'Browse Products',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
  ) {
    return Stack(
      children: [
        // Cart items list
        ListView.separated(
          padding: EdgeInsets.only(
            left: AppConstants.paddingMedium,
            right: AppConstants.paddingMedium,
            top: AppConstants.paddingMedium,
            bottom: 120, // space for bottom bar
          ),
          itemCount: cartState.items.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppConstants.paddingSmall),
          itemBuilder: (context, index) {
            return _buildCartItem(context, ref, cartState.items[index]);
          },
        ),

        // Fixed bottom checkout bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildCheckoutBar(context, ref, cartState),
        ),
      ],
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    WidgetRef ref,
    CartItemModel item,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
          // Product image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: Image.network(
              item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppConstants.fontSizeMedium,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingSmall),

                // Quantity controls + delete
                Row(
                  children: [
                    // Decrease
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .decreaseQuantity(item.product.id),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeNormal,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),

                    // Increase
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .addToCart(item.product),
                    ),
                    const Spacer(),

                    // Delete button
                    GestureDetector(
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .removeFromCart(item.product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppColors.secondary, size: 16),
      ),
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.paddingLarge,
        right: AppConstants.paddingLarge,
        top: AppConstants.paddingMedium,
        bottom:
            MediaQuery.of(context).padding.bottom + AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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
                'Total',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
              Text(
                '\$${cartState.totalPrice.toStringAsFixed(2)}',
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
              onTap: () {
                // Checkout logic comes later
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Order placed! Total: \$${cartState.totalPrice.toStringAsFixed(2)}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt_rounded,
                        color: AppColors.secondary, size: 20),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      'Checkout (${cartState.totalItems})',
                      style: const TextStyle(
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