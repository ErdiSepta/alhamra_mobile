import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/aktivitas_model.dart';
import '../../../core/utils/app_styles.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'package:alhamra_1/core/data/student_data.dart';

class AktivitasDetailPage extends StatelessWidget {
  final AktivitasEntry entry;
  final String studentName;

  const AktivitasDetailPage({
    super.key,
    required this.entry,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Detail Aktivitas',
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: _buildDetailContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + Nama
          CircleAvatar(
            radius: 32,
            backgroundImage:
                NetworkImage(StudentData.getStudentAvatar(studentName)),
          ),
          const SizedBox(height: 8),
          Text(
            studentName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Divider(height: 24),

          // Informasi detail
          _buildInfoRow("Jenis Aktivitas", _getLabelForCategory(entry.tipe),
              valueColor: _getColorForType(entry.tipe)),
          _buildInfoRow("Tanggal",
              DateFormat('d MMMM yyyy', 'id_ID').format(entry.tanggal)),
          _buildInfoRow(
              "Waktu", DateFormat('HH:mm \'WIB\'', 'id_ID').format(entry.tanggal)),
          _buildInfoRow("Dicatat oleh", entry.pencatat),

          const Divider(height: 24),

          // Detail Aktivitas
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Detail Aktivitas",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 12),
                Text(entry.judul,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(entry.keterangan,
                    style: const TextStyle(color: Colors.black54, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk row informasi detail
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(AktivitasType type) {
    switch (type) {
      case AktivitasType.pelanggaran:
        return AppStyles.dangerColor;
      case AktivitasType.perizinan:
        return Colors.orange.shade700;
      case AktivitasType.kesehatan:
        return Colors.green.shade600;
    }
  }

  String _getLabelForCategory(AktivitasType type) {
    switch (type) {
      case AktivitasType.pelanggaran:
        return 'Pelanggaran';
      case AktivitasType.perizinan:
        return 'Perizinan';
      case AktivitasType.kesehatan:
        return 'Kesehatan';
    }
  }
}