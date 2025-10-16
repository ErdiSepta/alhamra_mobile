import 'package:alhamra_1/core/models/student_model.dart';
import 'package:alhamra_1/core/providers/auth_provider.dart';
import 'package:alhamra_1/core/services/student_service.dart';
import 'package:alhamra_1/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaftarAnakPage extends StatefulWidget {
  const DaftarAnakPage({super.key});

  @override
  State<DaftarAnakPage> createState() => _DaftarAnakPageState();
}

class _DaftarAnakPageState extends State<DaftarAnakPage> {
  final StudentService _studentService = StudentService();
  List<StudentModel> _students = [];
  List<StudentModel> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      // Debug: Print user info
      print('=== LOAD STUDENTS DEBUG ===');
      print('User: ${user?.fullName}');
      print('Orangtua ID: ${user?.orangtuaId}');
      print('Partner ID: ${user?.partnerId}');

      if (user?.orangtuaId != null) {
        // Get students from Odoo
        final students = await _studentService.getStudentsByParent(user!.orangtuaId!);
        
        print('Students loaded: ${students.length}');
        for (var student in students) {
          print('- ${student.name} (${student.displayId})');
        }
        print('========================');
        
        setState(() {
          _students = students;
          _filteredStudents = students;
          _isLoading = false;
        });
      } else {
        print('ERROR: Orangtua ID is null');
        print('========================');
        setState(() {
          _errorMessage = 'ID Orang Tua tidak ditemukan.\n\nPastikan Anda login sebagai orang tua.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('ERROR loading students: $e');
      print('========================');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students
          .where((student) => 
              student.name.toLowerCase().contains(query) ||
              student.displayId.toLowerCase().contains(query))
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
    // Show loading indicator
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show error message
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadStudents,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // Show empty state
    if (_filteredStudents.isEmpty) {
      // Check if it's because of search or truly empty
      final isSearching = _searchController.text.isNotEmpty;
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSearching ? Icons.search_off : Icons.people_outline,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                isSearching 
                    ? 'Tidak ada hasil pencarian'
                    : 'Belum Ada Data Anak',
                style: AppStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSearching
                    ? 'Coba kata kunci lain untuk mencari'
                    : 'Akun Anda belum memiliki data anak yang terdaftar.\n\nSilakan hubungi admin pesantren untuk menambahkan data anak Anda.',
                textAlign: TextAlign.center,
                style: AppStyles.bodyText(context).copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              if (!isSearching) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadStudents,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat Ulang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Show student list
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentSelectedStudent = Provider.of<AuthProvider>(context).selectedStudent;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];

        void handleSelection() {
          authProvider.selectStudent(student.name);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${student.name} dipilih sebagai anak aktif.')),
          );
          // Kembali ke halaman sebelumnya setelah memilih
          Navigator.of(context).pop();
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(student.name, style: AppStyles.bodyText(context)),
            subtitle: Text(
              'ID: ${student.displayId}${student.className != null ? " • ${student.className}" : ""}',
              style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600]),
            ),
            trailing: Radio<String>(
              value: student.name,
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