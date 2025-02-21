import 'dart:async';
import 'package:flutter/material.dart';

class AdvertisementCarousel extends StatefulWidget {
  const AdvertisementCarousel({Key? key}) : super(key: key);

  @override
  AdvertisementCarouselState createState() => AdvertisementCarouselState();
}

class AdvertisementCarouselState extends State<AdvertisementCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _ads = [
    {
      'color': const [Color.fromRGBO(99, 102, 241, 1), Color.fromRGBO(139, 92, 246, 1)],
      'title': 'Premium Features',
      'subtitle': 'Unlock exclusive tools',
      'icon': Icons.workspace_premium,
    },
    {
      'color': const [Color.fromRGBO(59, 130, 246, 1), Color.fromRGBO(96, 165, 250, 1)],
      'title': 'New Updates',
      'subtitle': 'Discover latest features',
      'icon': Icons.update,
    },
    {
      'color': const [Color.fromRGBO(16, 185, 129, 1), Color.fromRGBO(52, 211, 153, 1)],
      'title': 'Special Offer',
      'subtitle': 'Limited time discount',
      'icon': Icons.local_offer,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _ads.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _ads.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final ad = _ads[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = index.toDouble() - (_pageController.page ?? 0);
                      value = (value * 0.1).clamp(-1, 1);
                    }
                    return Transform.scale(
                      scale: 1 - value.abs() * 0.1,
                      child: child,
                    );
                  },
                  child: _AdCard(
                    colors: ad['color'] as List<Color>,
                    title: ad['title'] as String,
                    subtitle: ad['subtitle'] as String,
                    icon: ad['icon'] as IconData,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_ads.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index 
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final String subtitle;
  final IconData icon;

  const _AdCard({
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {}, // Add your ad click handler
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text(subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, 
                    size: 32, 
                    color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}