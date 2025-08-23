import 'package:alhamra_1/utils/app_styles.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'beranda_page.dart';
import 'pembayaran_page.dart';
import 'status_page.dart';
import 'profil_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaPage(),
    const PembayaranPage(),
    const StatusPage(),
    const ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomBarDivider(
        items: const [
          TabItem(icon: Icons.home_outlined, title: 'Beranda'),
          TabItem(icon: Icons.payment_outlined, title: 'Pembayaran'),
          TabItem(icon: Icons.history_outlined, title: 'Status'),
          TabItem(icon: Icons.person_outline, title: 'Akun'),
        ],
        indexSelected: _selectedIndex,
        onTap: _onItemTapped,
        color: const Color(0xFFAAAAAA),
        colorSelected: AppStyles.primaryColor,
        backgroundColor: Colors.white,
        styleDivider: StyleDivider.top,
        titleStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
