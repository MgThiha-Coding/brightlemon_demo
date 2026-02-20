import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/font_styles.dart';
import '../../core/widgets.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.cardColor,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: AppFontStyles.h3.copyWith(
                    color: AppConstants.primaryColor,
                    letterSpacing: -1,
                    fontSize: 28,
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
              const SizedBox(height: 10),
              Text(
                "System Administration",
                style: AppFontStyles.bodyMedium.copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildField("Username", "admin_user", false),
              const SizedBox(height: 20),
              _buildField("Password", "********", true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Enter Dashboard",
                  onPressed: () => context.go('/admin/dashboard'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text("Back to Public Site", style: TextStyle(color: Colors.grey[600])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppConstants.textMainColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
        ),
      ],
    );
  }
}
