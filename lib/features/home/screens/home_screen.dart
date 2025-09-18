import 'package:alhamra_1/features/home/screens/menu_pages.dart';
import 'package:alhamra_1/features/payment/screens/bayar_pages.dart';
import 'package:alhamra_1/features/profile/screens/profil_page.dart';

import '../../../core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

// Simple placeholder page for different sections
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppStyles.primaryColor),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This page is under construction',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set default to index 0 (Menu - first item)
    PersistentTabController controller = PersistentTabController(
      initialIndex: 0,
    );

    List<Widget> buildScreens() {
      return [
        const BerandaPage(), // Menu (shows Beranda content)
        const StatusPage(), // Status
        const PlaceholderPage(
          title: 'Beranda',
          icon: Icons.home,
        ), // Beranda (center)
        const PlaceholderPage(
          title: 'Aktivitas',
          icon: Icons.local_activity,
        ), // Aktivitas
        ProfilPage(), // Akun
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        // Menu
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.menu, size: 26),
          title: "Menu",
          activeColorPrimary: AppStyles.primaryColor,
          inactiveColorPrimary: const Color(0xFFAAAAAA),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Status
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.history_outlined, size: 26),
          title: "Status",
          activeColorPrimary: AppStyles.primaryColor,
          inactiveColorPrimary: const Color(0xFFAAAAAA),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Beranda (Center - Default)
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home, size: 26),
          title: "Beranda",
          activeColorPrimary: AppStyles.primaryColor,
          inactiveColorPrimary: const Color(0xFFAAAAAA),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Aktivitas
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.local_activity, size: 26),
          title: "Aktivitas",
          activeColorPrimary: AppStyles.primaryColor,
          inactiveColorPrimary: const Color(0xFFAAAAAA),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Akun
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_outline, size: 26),
          title: "Akun",
          activeColorPrimary: AppStyles.primaryColor,
          inactiveColorPrimary: const Color(0xFFAAAAAA),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 12),
      backgroundColor: Colors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: 80,
      navBarStyle: NavBarStyle.style1,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        colorBehindNavBar: Colors.white,
      ),
    );
  }
}
