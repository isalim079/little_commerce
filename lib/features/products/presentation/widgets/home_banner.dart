import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:little_commerce/core/constants/app_constants.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0; // tracks which banner is active for dot indicator

  // Banner data — later this can come from API
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'New Arrivals',
      'subtitle': 'Shop the latest trends',
      'gradient': [Color(0xFF1a1a2e), Color(0xFF16213e)],
      'icon': Icons.star_rounded,
    },
    {
      'title': 'Special Offer',
      'subtitle': 'Up to 50% off today',
      'gradient': [Color(0xFF0f3460), Color(0xFF533483)],
      'icon': Icons.local_offer_rounded,
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'On all orders above \$50',
      'gradient': [Color(0xFF1B4332), Color(0xFF2D6A4F)],
      'icon': Icons.local_shipping_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSlider(),
        const SizedBox(height: 12),
        _buildDotIndicators(),
      ],
    );
  }

  Widget _buildSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 600),
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: _banners.map((banner) => _buildBannerItem(banner)).toList(),
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: List<Color>.from(banner['gradient']),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text side
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner['subtitle'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: AppConstants.fontSizeMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusSmall,
                    ),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Icon side
            Icon(
              banner['icon'] as IconData,
              color: Colors.white.withOpacity(0.3),
              size: 90,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _banners.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.black : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}