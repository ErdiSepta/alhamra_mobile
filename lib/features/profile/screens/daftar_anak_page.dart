import 'package:alhamra_1/core/data/student_data.dart';
import 'package:alhamra_1/core/providers/auth_provider.dart';
import 'package:alhamra_1/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaftarAnakPage extends StatefulWidget {
  const DaftarAnakPage({super.key});

  @override
  State<DaftarAnakPage> createState() => _DaftarAnakPageState();
}

class _DaftarAnakPageState extends State<DaftarAnakPage> {
  // Dummy data for student IDs, paired with names from StudentData
  final Map<String, String> _studentDetails = {
    'Muhammad Fathan Abdillah': '2301012',
    'Muhammad Rafi Afifuddin': '23002010',
    'Ahmad Zaky Mubarak': '23003015',
    'Raisa Anggiani Putri': '23004021',
    'Zahra Nur Azizah': '23005007',
  };

  late List<String> _filteredStudents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStudents = _studentDetails.keys.toList(); 
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _studentDetails.keys
          .where((student) => student.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan listen: true agar UI di sini juga ikut update jika ada perubahan
    final authProvider = Provider.of<AuthProvider>(context);
    final parentName = authProvider.user?.fullName ?? 'Nama Orang Tua';

    return Scaffold(
      backgroundColor: AppStyles.greyColor,
      appBar: AppBar(
        title: const Text('Daftar Anak'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParentInfoCard(context, parentName, authProvider.selectedStudent),
            const SizedBox(height: 24),
            _buildSearchBar(context),
            const SizedBox(height: 16),
            _buildStudentList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParentInfoCard(BuildContext context, String parentName, String selectedStudent) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppStyles.primaryColor,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parentName, style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Anak yang dipilih: $selectedStudent',
                    style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Tuliskan apa yang anda cari . . .',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStudentList(BuildContext context) {
    // Gunakan listen: false di dalam fungsi build, karena kita hanya butuh memanggil method
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Dapatkan nilai student yang dipilih saat ini dari provider
    final currentSelectedStudent = Provider.of<AuthProvider>(context).selectedStudent;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final studentName = _filteredStudents[index];
        final studentId = _studentDetails[studentName] ?? 'N/A';

        void handleSelection() {
          authProvider.selectStudent(studentName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$studentName dipilih sebagai anak aktif.')),
          );
          // Kembali ke halaman sebelumnya setelah memilih
          Navigator.of(context).pop();
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(studentName, style: AppStyles.bodyText(context)),
            subtitle: Text('ID: $studentId', style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600])),
            trailing: Radio<String>(
              value: studentName,
              groupValue: currentSelectedStudent,
              onChanged: (value) => handleSelection(),
              activeColor: AppStyles.primaryColor,
            ),
            onTap: handleSelection,
          ),
        );
      },
    );
  }
}