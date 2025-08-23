import 'package:flutter/material.dart';
import 'package:alhamra_1/utils/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppStyles.heading1(context).copyWith(
          fontSize: AppStyles.getResponsiveFontSize(
            context,
            small: 18.0,
            medium: 20.0,
            large: 22.0,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: AppStyles.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
      toolbarHeight: AppStyles.getResponsiveFontSize(
        context,
        small: 52.0,
        medium: 56.0,
        large: kToolbarHeight,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
