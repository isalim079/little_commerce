import 'package:flutter/material.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int _selectedIndex = 0;

  // Hardcoded for now — later will come from API
  final List<String> _categories = [
    'All',
    'Electronics',
    'Jewelery',
    "Men's Clothing",
    "Women's Clothing",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Text(
            'Categories',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeNormal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),

        // Scrollable tabs
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return _buildTab(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Text(
          _categories[index],
          style: TextStyle(
            color: isSelected ? AppColors.secondary : AppColors.textPrimary,
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}