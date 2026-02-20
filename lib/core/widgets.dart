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
            letterSpacing: 0.5, // Reduced from 2
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
          color: light ? Colors.white : AppConstants.primaryColor,
        ),
      ],
    );
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const ModernButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: isSecondary ? null : LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withBlue(220),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isSecondary ? Colors.black : AppConstants.primaryColor).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : Colors.transparent,
          foregroundColor: isSecondary ? AppConstants.primaryColor : Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ).copyWith(
          elevation: WidgetStateProperty.all(0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
