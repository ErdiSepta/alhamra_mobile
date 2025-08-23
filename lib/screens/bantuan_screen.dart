import 'package:flutter/material.dart';
import 'package:alhamra_1/utils/app_styles.dart';
import 'package:alhamra_1/widgets/custom_app_bar.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.greyColor,
      appBar: const CustomAppBar(title: 'Bantuan'),
      body: ListView(
        padding: AppStyles.getResponsivePadding(context),
        children: const [
          FaqItem(
            question: 'Bagaimana cara mendapatkan akun aplikasi ini?',
            answer:
                '1. Akun untuk masuk ke aplikasi IBS Al-Hamra tidak dibuat secara mandiri oleh pengguna.\n'
                '2. Setiap username dan password hanya bisa diberikan oleh administrator resmi aplikasi.\n'
                '3. Jika Anda belum menerima akun, silakan hubungi admin melalui WhatsApp di nomor berikut: 0894-8347-387',
          ),
          FaqItem(
            question:
                'Saya lupa password akun saya, bagaimana cara mengatasinya?',
            answer:
                'Jika Anda tidak bisa mengingat password, tidak tersedia fitur reset otomatis di aplikasi ini. Untuk melakukan reset password, silakan hubungi langsung admin melalui WhatsApp: 0894-8347-387. Sebutkan nama lengkap Anda dan instansi/unit terkait agar proses verifikasi berjalan cepat.',
          ),
          FaqItem(
            question: 'Saya tidak bisa login ke aplikasi, apa penyebabnya?',
            answer:
                'Ada beberapa hal yang perlu diperiksa:\n'
                '1. Pastikan Anda menggunakan username dan password yang benar, sesuai dengan yang diberikan oleh admin.\n'
                '2. Periksa apakah Anda tidak mengaktifkan caps lock, dan perhatikan huruf besar/kecil.\n'
                '3. Pastikan perangkat Anda terhubung dengan internet.\n'
                '4. Jika semua sudah benar namun tetap gagal, segera hubungi admin di 0894-8347-387.',
          ),
          FaqItem(
            question:
                'Aplikasi tidak bisa dibuka atau force close (keluar sendiri)?',
            answer:
                'Ada beberapa hal yang perlu diperiksa:\n'
                '1. Tutup aplikasi dan buka ulang.\n'
                '2. Restart perangkat Anda.\n'
                '3. Pastikan aplikasi IBS Al-Hamra sudah diperbarui ke versi terbaru.\n'
                '4. Jika masih bermasalah, coba hapus cache aplikasi di pengaturan perangkat.',
          ),
          FaqItem(
            question: 'Apakah saya bisa mengganti atau membuat akun sendiri?',
            answer:
                'Tidak bisa. Seluruh akun hanya dibuat oleh administrator pusat untuk menjaga keamanan sistem dan data pengguna. Jika Anda membutuhkan akses baru (misalnya karena pindah unit atau ganti perangkat), silakan ajukan ke admin 0894-8347-387.',
          ),
          FaqItem(
            question: 'Apakah aplikasi bisa digunakan tanpa koneksi internet?',
            answer:
                'Tidak. Aplikasi IBS Al-Hamra membutuhkan koneksi internet aktif untuk login dan mengakses data. Pastikan Anda terhubung dengan jaringan yang stabil saat menggunakan aplikasi.',
          ),
          FaqItem(
            question: 'Apakah saya boleh login di beberapa perangkat sekaligus?',
            answer:
                'Sangat tidak disarankan. Untuk menjaga keamanan dan konsistensi data, sebaiknya Anda hanya login di satu perangkat saja. Jika ingin mengganti perangkat, logout terlebih dahulu dari perangkat sebelumnya, lalu login ulang di perangkat baru.',
          ),
          FaqItem(
            question:
                'Saya mengalami kendala lain yang tidak disebutkan di atas. Apa yang harus saya lakukan?',
            answer:
                'Jika ada masalah atau pertanyaan lain yang belum terjawab, silakan langsung hubungi admin melalui WhatsApp: 0894-8347-387. Tim admin siap membantu Anda selama jam kerja.',
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final answerParts = widget.answer.split('\n').where((s) => s.isNotEmpty).toList();

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical: AppStyles.getResponsiveSpacing(context, small: 6.0, medium: 7.0, large: 8.0),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: AppStyles.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppStyles.primaryColor,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answerParts.map((part) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        part,
                        style: AppStyles.bodyText(context).copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
