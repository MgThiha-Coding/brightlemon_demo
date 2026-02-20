import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../core/font_styles.dart';
import '../core/responsive.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final currentYear = DateTime.now().year;

    return Container(
      color: const Color(0xFF0F172A), // Dark Midnight Slate
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 80 : 60,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          Responsive(
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildBrandInfo()),
                const SizedBox(width: 40),
                Expanded(child: _buildLinksColumn("Quick Links", ["Home", "About", "Projects", "Gallery", "Contact"])),
                const SizedBox(width: 40),
                Expanded(child: _buildLinksColumn("Our Work", ["Education", "Healthcare", "Environment", "Community"])),
                const SizedBox(width: 40),
                Expanded(flex: 1, child: _buildContactColumn()),
              ],
            ),
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandInfo(),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildLinksColumn("Quick Links", ["Home", "About", "Projects", "Gallery", "Contact"])),
                    Expanded(child: _buildLinksColumn("Our Work", ["Education", "Healthcare", "Environment", "Community"])),
                  ],
                ),
                const SizedBox(height: 40),
                _buildContactColumn(),
              ],
            ),
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white12),
          const SizedBox(height: 30),
          isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "© $currentYear LemonBright Foundation. All rights reserved.",
                          style: AppFontStyles.bodyMedium.copyWith(color: Colors.white54, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.go('/admin'),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.white.withOpacity(0.05),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _socialIcon(Icons.facebook),
                        _socialIcon(Icons.camera_alt_outlined),
                        _socialIcon(Icons.link),
                        _socialIcon(Icons.email_outlined),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "© $currentYear LemonBright Foundation. All rights reserved.",
                          style: AppFontStyles.bodyMedium.copyWith(color: Colors.white54, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.go('/admin'),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.white.withOpacity(0.05),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _socialIcon(Icons.facebook),
                        _socialIcon(Icons.camera_alt_outlined),
                        _socialIcon(Icons.link),
                        _socialIcon(Icons.email_outlined),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildBrandInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppFontStyles.h3.copyWith(
              color: Colors.white,
              letterSpacing: -1,
            ),
            children: const [
              TextSpan(
                text: 'Lemon',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: 'Bright',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: Text(
            "Empowering communities through sustainable initiatives and compassionate action. Join us in making the world a brighter place for everyone.",
            style: AppFontStyles.bodyMedium.copyWith(color: Colors.white70, height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLinksColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyles.navLink.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            link,
            style: AppFontStyles.bodyMedium.copyWith(color: Colors.white54, fontSize: 14),
          ),
        )),
      ],
    );
  }

  Widget _buildContactColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get In Touch",
          style: AppFontStyles.navLink.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _footerContactItem(Icons.location_on, "Mayangone, Yangon"),
        _footerContactItem(Icons.phone, "+95 9 789 234 567"),
        _footerContactItem(Icons.email, "hello@lemonbright.org"),
      ],
    );
  }

  Widget _footerContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.accentColor, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppFontStyles.bodyMedium.copyWith(color: Colors.white54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Icon(icon, color: Colors.white54, size: 20),
    );
  }
}
