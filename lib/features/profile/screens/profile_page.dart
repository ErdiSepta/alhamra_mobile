import 'package:alhamra_1/core/data/student_data.dart';
import 'package:alhamra_1/core/providers/auth_provider.dart';
import 'package:alhamra_1/core/localization/app_localizations.dart';
import 'package:alhamra_1/features/profile/screens/daftar_anak_page.dart';
import 'package:alhamra_1/features/profile/screens/edit_profile_page.dart';
import 'package:alhamra_1/features/profile/screens/ubah_kata_sandi_page.dart';
import 'package:alhamra_1/features/profile/screens/informasi_aplikasi_page.dart';
import 'package:alhamra_1/features/profile/screens/ketentuan_layanan_page.dart';
import 'package:alhamra_1/features/shared/widgets/language_switcher.dart';
import 'package:alhamra_1/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${localizations.logout} ${localizations.konfirmasiHapus}'),
        content: Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.dangerColor,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.logout),
          ),
        ],
      ),
    );
 
    if (confirm == true) {
      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      // ignore: use_build_context_synchronously
      if (context.mounted) {
        // Use named route to ensure clean navigation
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    final selectedStudent = authProvider.selectedStudent; // Mengambil data dari provider
    return Scaffold(
      backgroundColor: AppStyles.greyColor,
      appBar: AppBar(
        title: Text(localizations.akun),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: AppStyles.getResponsivePadding(context),
                child: Column(
                  children: [
                    _buildProfileHeader(context, currentUser, selectedStudent),
                    const SizedBox(height: 20),
                    _buildSection(context,
                      title: localizations.akun,
                      children: [
                        _buildMenuItem(context, Icons.people_outline, localizations.daftarAnak, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const DaftarAnakPage()),
                          );
                        }),
                        const LanguageSwitcher(showLabel: true, isCompact: false),
                      ],
                    ),
                    _buildSection(context,
                      title: localizations.keamanan,
                      children: [
                        _buildMenuItem(context, Icons.lock_outline, localizations.ubahKataSandi, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const UbahKataSandiPage()),
                          );
                        }),
                        _buildMenuItem(context, Icons.info_outline, localizations.tentangAplikasi, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const InformasiAplikasiPage()),
                          );
                        }),
                      ],
                    ),
                    _buildSection(context,
                      title: localizations.informasiAplikasi,
                      children: [
                        _buildMenuItem(context, Icons.description_outlined, localizations.ketentuanLayanan, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const KetentuanLayananPage()),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, currentUser, String selectedStudent) {
    final localizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
            child: Text(
              currentUser?.fullName.substring(0, 2).toUpperCase() ?? 'AK',
              style: const TextStyle(color: AppStyles.primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser?.fullName ?? 'Nama Pengguna',
                  style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${localizations.anakYangDipilih}: $selectedStudent',
                  style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppStyles.primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Text(title.toUpperCase(), style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppStyles.primaryColor),
      title: Text(title, style: AppStyles.bodyText(context)),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: Text(localizations.logout),
        onPressed: () => _logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.dangerColor.withOpacity(0.1),
          foregroundColor: AppStyles.dangerColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}