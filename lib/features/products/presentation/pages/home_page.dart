import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';
import 'package:little_commerce/features/products/presentation/providers/product_provider.dart';
import 'package:little_commerce/features/products/presentation/widgets/category_tabs.dart';
import 'package:little_commerce/features/products/presentation/widgets/home_banner.dart';
import 'package:little_commerce/features/products/presentation/widgets/product_list.dart';

const _searchInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(AppConstants.borderRadiusMedium),
  ),
  borderSide: BorderSide.none,
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(productsProvider);
          await ref.read(productsProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSearchBar(),
              const SizedBox(height: AppConstants.paddingMedium),
              const HomeBanner(),
              const SizedBox(height: AppConstants.paddingLarge),
              const CategoryTabs(),
              const SizedBox(height: AppConstants.paddingLarge),
              productsState.when(
                loading: () => const _ProductsLoadingWidget(),
                error: (error, _) => _ProductsErrorWidget(
                  error: error.toString(),
                  onRetry: () async {
                    ref.invalidate(productsProvider);
                    await ref.read(productsProvider.future);
                  },
                ),
                data: (products) => ProductList(products: products),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
      title: const Text(
        'Little Commerce',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: AppConstants.fontSizeLarge,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '0',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppConstants.paddingSmall),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(
            color: AppColors.hintText,
            fontSize: AppConstants.fontSizeMedium,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: Container(
            margin: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.secondary,
              size: 18,
            ),
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingMedium,
          ),
          border: _searchInputBorder,
          enabledBorder: _searchInputBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium,
            ),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _ProductsLoadingWidget extends StatelessWidget {
  const _ProductsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _ProductsErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ProductsErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.grey,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              error,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
