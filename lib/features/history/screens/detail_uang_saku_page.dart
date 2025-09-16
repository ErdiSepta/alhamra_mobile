import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'dart:io';

import '../../../core/models/pocket_money_history.dart';
import '../../../core/utils/app_styles.dart';

class DetailUangSakuPage extends StatelessWidget {
  final PocketMoneyHistory transaction;
  final ScreenshotController screenshotController = ScreenshotController();

  DetailUangSakuPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color accent = _getTransactionColor(transaction.type);
    final String typeText = _getTransactionTypeText(transaction.type);
    final IconData typeIcon = _getTransactionIcon(transaction.type);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppStyles.primaryColor,
              AppStyles.secondaryColor,
            ],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Header (SafeArea)
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Detail Riwayat Uang Saku',
                            style: AppStyles.heading1(context).copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Overlay putih
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 28,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Overlay fill (on top of the shadow layer)
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: const Color(0xFFF2F4F7), // slightly darker off-white for stronger contrast
                elevation: 16,
                shadowColor: Colors.black.withOpacity(0.25),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: const SizedBox.expand(),
              ),
            ),

            // Kartu konten utama
            Positioned(
              top: 90,
              left: 20,
              right: 20,
              bottom: 100,
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Icon bulat
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            typeIcon,
                            color: accent,
                            size: 35,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Jenis transaksi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              typeText,
                              style: AppStyles.bodyText(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Tanggal
                        Text(
                          DateFormat('dd-MM-yyyy, HH:mm').format(transaction.date) + ' WIB',
                          style: AppStyles.bodyText(context).copyWith(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Garis
                        Container(height: 1, color: Colors.grey[300]),

                        const SizedBox(height: 24),

                        // Detail transaksi
                        Column(
                          children: [
                            _buildDetailRow('ID Transaksi', transaction.id),
                            const SizedBox(height: 12),
                            _buildDetailRow('Judul', transaction.title),
                            const SizedBox(height: 12),
                            _buildDetailRow('Keterangan', transaction.subtitle),
                            const SizedBox(height: 12),
                            _buildDetailRow('Waktu',
                                DateFormat('dd MMMM yyyy, HH:mm').format(transaction.date) + ' WIB'),
                            const SizedBox(height: 12),
                            _buildDetailRow('Sumber', transaction.bankName),
                            if (transaction.description != null && transaction.description!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildDetailRow('Catatan', transaction.description!),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Detail nominal
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Detail Transaksi',
                            style: AppStyles.bodyText(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Column(
                          children: [
                            _buildDetailRow(
                                'Nominal',
                                (transaction.type == PocketMoneyTransactionType.incoming ? '+' : '-') +
                                    _formatCurrency(transaction.amount)),
                            const SizedBox(height: 12),
                            _buildDetailRow('Jenis', typeText),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Info tambahan warna lembut
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accent.withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                typeIcon,
                                color: accent,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getTransactionMessage(transaction.type),
                                  style: AppStyles.bodyText(context).copyWith(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tombol bawah
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _share(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: accent,
                          side: BorderSide(color: accent, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: accent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Bagikan',
                              style: AppStyles.bodyText(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Kembali',
                          style: AppStyles.bodyText(context).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp ${NumberFormat('#,###').format(amount)}';
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _share(BuildContext context) {
    final String shareText = '''
📋 Detail Riwayat Uang Saku

🧾 Informasi Transaksi:
• ID: ${transaction.id}
• Judul: ${transaction.title}
• Keterangan: ${transaction.subtitle}
• Jenis: ${_getTransactionTypeText(transaction.type)}
• Nominal: ${(transaction.type == PocketMoneyTransactionType.incoming ? '+' : '-')}${_formatCurrency(transaction.amount)}
• Waktu: ${DateFormat('dd MMMM yyyy, HH:mm').format(transaction.date)} WIB
• Sumber: ${transaction.bankName}${transaction.description != null ? '\n• Catatan: ${transaction.description}' : ''}

✅ Riwayat dari Aplikasi Alhamra
📅 ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now())} WIB
''';

    _showShareBottomSheet(context, shareText);
  }

  void _showShareBottomSheet(BuildContext parentContext, String shareText) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 8),
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              // Apps section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildIOSAppIcon(parentContext, Icons.content_copy, 'Salin', Colors.grey[700]!, () {
                        Clipboard.setData(ClipboardData(text: shareText));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: const Text('Detail berhasil disalin'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }),
                      _buildIOSAppIcon(parentContext, Icons.message, 'Pesan', Colors.green, () {
                        Navigator.pop(ctx);
                        _showComingSoonDialog(parentContext, 'SMS');
                      }),
                      _buildIOSAppIcon(parentContext, Icons.mail, 'Mail', Colors.blue, () {
                        Navigator.pop(ctx);
                        _showComingSoonDialog(parentContext, 'Email');
                      }),
                    ],
                  ),
                ),
              ),

              // Actions: Save Image / Save PDF
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Simpan sebagai Gambar'),
                      onTap: () {
                        Navigator.pop(ctx);
                        _saveAsImage(parentContext);
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: const Text('Simpan sebagai PDF'),
                      onTap: () {
                        Navigator.pop(ctx);
                        _saveAsPDF(parentContext);
                      },
                    ),
                  ],
                ),
              ),
              // Cancel button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAsImage(BuildContext context) async {
    try {
      // Capture the screenshot
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('Failed to capture screenshot');
      }

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'uang_saku_${transaction.id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = '${directory.path}/$fileName';

      // Save the image file
      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Show success dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil'),
            content: Text('Gambar telah disimpan di:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Gagal menyimpan gambar: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _saveAsPDF(BuildContext context) async {
    try {
      // Capture the screenshot first
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('Failed to capture screenshot');
      }

      // Create PDF document
      final pdf = pw.Document();

      // Create PDF image from bytes
      final image = pw.MemoryImage(imageBytes);

      // Add page with the image
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'uang_saku_${transaction.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final String filePath = '${directory.path}/$fileName';

      // Save the PDF file
      final File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Show success dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil'),
            content: Text('PDF telah disimpan di:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Gagal menyimpan PDF: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildIOSAppIcon(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withOpacity(0.2), width: 0.5),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segera Hadir'),
        content: Text('Fitur berbagi via $feature akan segera tersedia.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Color _getTransactionColor(PocketMoneyTransactionType type) {
    switch (type) {
      case PocketMoneyTransactionType.incoming:
        return AppStyles.primaryColor;
      case PocketMoneyTransactionType.outgoing:
        return Colors.red[600]!;
    }
  }

  String _getTransactionTypeText(PocketMoneyTransactionType type) {
    switch (type) {
      case PocketMoneyTransactionType.incoming:
        return 'Pemasukan';
      case PocketMoneyTransactionType.outgoing:
        return 'Pengeluaran';
    }
  }

  IconData _getTransactionIcon(PocketMoneyTransactionType type) {
    switch (type) {
      case PocketMoneyTransactionType.incoming:
        return Icons.arrow_downward;
      case PocketMoneyTransactionType.outgoing:
        return Icons.arrow_upward;
    }
  }

  String _getTransactionMessage(PocketMoneyTransactionType type) {
    switch (type) {
      case PocketMoneyTransactionType.incoming:
        return 'Dana telah berhasil masuk ke dalam saku.';
      case PocketMoneyTransactionType.outgoing:
        return 'Pengeluaran telah berhasil tercatat.';
    }
  }
}
