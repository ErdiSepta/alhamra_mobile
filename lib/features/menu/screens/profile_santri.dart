import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/student_data.dart';
import '../../../../core/models/santri_model.dart';
import '../../../../core/utils/app_styles.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/index.dart';
import '../../shared/widgets/student_selection_widget.dart';

class ProfileSantriPage extends StatefulWidget {
  const ProfileSantriPage({super.key});

  @override
  State<ProfileSantriPage> createState() => _ProfileSantriPageState();
}

class _ProfileSantriPageState extends State<ProfileSantriPage> {
  // Generate mock data based on existing StudentData
  final List<Santri> _allSantri = StudentData.allStudents.map((nama) {
    int index = StudentData.allStudents.indexOf(nama);
    return Santri(
      id: (index + 1).toString(),
      namaLengkap: nama,
      namaPanggilan: nama.split(' ').first,
      tempatLahir: ['Malang', 'Surabaya', 'Jakarta', 'Bandung'][index % 4],
      tanggalLahir: DateTime(2004, 7, 12).subtract(Duration(days: index * 365)),
      jenisKelamin: 'Laki-Laki',
      hobi: ['Membaca', 'Menulis', 'Olahraga', 'Musik'][index % 4],
      citaCita: ['Dokter', 'Guru', 'Atlet', 'Insinyur'][index % 4],
      agama: 'Islam',
      golonganDarah: ['O', 'A', 'B', 'AB'][index % 4],
      fotoUrl: StudentData.getStudentAvatar(nama),
      nomorInduk: '23533${430 + index}',
    );
  }).toList();

  late Santri _selectedSantri;
  bool _isStudentOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the first santri
    _selectedSantri = _allSantri[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: CustomAppBar(
        title: 'Profil Santri',
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildStudentSelector(),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildProfileDetails(),
                ),
              ),
            ],
          ),
          // Overlay for student selection
          if (_isStudentOverlayVisible)
            SearchOverlayWidget(
              isVisible: _isStudentOverlayVisible,
              title: 'Pilih Santri',
              items: _allSantri.map((s) => s.namaLengkap).toList(),
              selectedItem: _selectedSantri.namaLengkap,
              onItemSelected: (nama) {
                setState(() {
                  _selectedSantri = _allSantri.firstWhere((s) => s.namaLengkap == nama, orElse: () => _selectedSantri);
                  _isStudentOverlayVisible = false;
                });
              },
              onClose: () {
                setState(() {
                  _isStudentOverlayVisible = false;
                });
              },
              searchHint: 'Cari santri...',
              avatarUrl: StudentData.defaultAvatarUrl,
            ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: StudentSelectionWidget(
        selectedStudent: _selectedSantri.namaLengkap,
        students: _allSantri.map((s) => s.namaLengkap).toList(),
        onStudentChanged: (nama) {
          setState(() {
            _selectedSantri = _allSantri.firstWhere((s) => s.namaLengkap == nama, orElse: () => _selectedSantri);
          });
        },
        onOverlayVisibilityChanged: (visible) {
          setState(() {
            _isStudentOverlayVisible = visible;
          });
        },
        avatarUrl: _selectedSantri.fotoUrl,
      ),
    );
  }

  Widget _buildProfileDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Pribadi',
            style: AppStyles.sectionTitle(context),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileDetailRow('Nama Lengkap', _selectedSantri.namaLengkap),
                _buildProfileDetailRow('Nama Panggilan', _selectedSantri.namaPanggilan),
                _buildProfileDetailRow('Nomor Induk', _selectedSantri.nomorInduk),
                _buildProfileDetailRow('Jenis Kelamin', _selectedSantri.jenisKelamin),
                _buildProfileDetailRow('Tempat Lahir', _selectedSantri.tempatLahir),
                _buildProfileDetailRow('Tanggal Lahir', DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedSantri.tanggalLahir)),
                _buildProfileDetailRow('Agama', _selectedSantri.agama),
                _buildProfileDetailRow('Golongan Darah', _selectedSantri.golonganDarah),
                _buildProfileDetailRow('Hobi', _selectedSantri.hobi),
                _buildProfileDetailRow('Cita-Cita', _selectedSantri.citaCita),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
