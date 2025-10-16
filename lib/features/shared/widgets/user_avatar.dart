import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:alhamra_1/core/models/user_model.dart';
import 'package:alhamra_1/core/utils/app_styles.dart';

/// Widget untuk menampilkan avatar user dari Odoo atau default
class UserAvatar extends StatelessWidget {
  final UserModel? user;
  final double radius;
  final bool showEditButton;
  final VoidCallback? onEditTap;

  const UserAvatar({
    super.key,
    required this.user,
    this.radius = 30,
    this.showEditButton = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    if (showEditButton) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildAvatar(),
          if (onEditTap != null)
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppStyles.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      );
    }

    return _buildAvatar();
  }

  Widget _buildAvatar() {
    // Cek apakah ada avatar dari Odoo (base64)
    if (user?.avatar128 != null && user!.avatar128!.isNotEmpty) {
      try {
        // Decode base64 ke bytes
        Uint8List bytes = base64Decode(user!.avatar128!);

        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(bytes),
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
        );
      } catch (e) {
        // Jika error decode, gunakan default avatar
        return _buildDefaultAvatar();
      }
    }

    // Default avatar dengan inisial atau icon
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    // Jika ada nama, tampilkan inisial
    if (user?.fullName != null && user!.fullName.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
        child: Text(
          user!.fullName.substring(0, 2).toUpperCase(),
          style: TextStyle(
            color: AppStyles.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.6, // Proporsi font terhadap radius
          ),
        ),
      );
    }

    // Jika tidak ada nama, tampilkan icon
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: radius * 1.2,
        color: AppStyles.primaryColor,
      ),
    );
  }
}
