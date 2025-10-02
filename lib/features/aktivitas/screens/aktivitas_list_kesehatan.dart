import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/models/aktivitas_model.dart';
import '../screens/aktivitas_detail_page.dart';

class AktivitasListKesehatan extends StatelessWidget {
  final List<AktivitasEntry> entries;
  final String studentName;

  const AktivitasListKesehatan({
    super.key,
    required this.entries,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = entries
        .where((entry) => entry.tipe == AktivitasType.kesehatan)
        .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('Tidak ada data kesehatan.',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final entry = filtered[index];
        return _buildCard(context, entry);
      },
    );
  }

  Widget _buildCard(BuildContext context, AktivitasEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Kesehatan",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.green.shade600)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(studentName,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                DateFormat('d MMM yyyy', 'id_ID').format(entry.tanggal),
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(entry.judul,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        AktivitasDetailPage(entry: entry, studentName: studentName),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text("Lihat Detail"),
            ),
          ),
        ],
      ),
    );
  }
}
