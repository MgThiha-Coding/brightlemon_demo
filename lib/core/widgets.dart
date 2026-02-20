import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppConstants.shimmerBase,
      highlightColor: AppConstants.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool light;

  const SectionHeader({
    super.key, 
    required this.title, 
    this.subtitle,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = light ? Colors.white70 : AppConstants.primaryColor;
    final subtitleColor = light ? Colors.white : AppConstants.textMainColor;

    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: titleColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: subtitleColor,
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 24),
        Container(
          width: 60,
          height: 3,
          color: light ? Colors.white : AppConstants.accentColor,
        ),
      ],
    );
  }
}
