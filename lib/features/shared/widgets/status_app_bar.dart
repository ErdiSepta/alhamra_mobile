import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';

class StatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double height;

  const StatusAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor,
    this.height = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor ?? AppStyles.primaryColor,
      child: SafeArea(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              // Back button positioned on the left
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              // Centered title with better typography
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56), // Account for back button space
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
