import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';
import 'package:flutter/services.dart';

class StatusBerhasilPage extends StatelessWidget {
  final int? amount;
  
  const StatusBerhasilPage({super.key, this.amount});

  @override
  Widget build(BuildContext context) {
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
          children: [
            // Main content with SafeArea
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Seragam Santri',
                          style: AppStyles.heading1(context).copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // White overlay background starting from top
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
            
            // Main Content Card positioned over the overlay
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              bottom: 100,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                      // Profile Image with Badge
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Status Text with Success Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pembayaran Berhasil',
                            style: AppStyles.bodyText(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Date Time
                      Text(
                        '10-09-2025, 09:56 WIB',
                        style: AppStyles.bodyText(context).copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Invoice Details
                      Column(
                        children: [
                          _buildDetailRow('ID Invoice', 'INV/0900/23922'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Nama Pengirim', 'Idris Nur Wahyudi'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Administrator', 'Diah Al Quwari'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Tgl. Konfirmasi', '20-09-2025'),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Detail Pembayaran Header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Pembayaran',
                          style: AppStyles.bodyText(context).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Payment Details
                      Column(
                        children: [
                          _buildDetailRow('Rekening Pengirim', '3513839289292'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Nominal Pembayaran', amount != null ? 'Rp. ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}' : 'Rp. 1.400.000'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Keterangan', 'SPP 2025'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Nama Santri', 'Naufal Ramadhan'),
                        ],
                      ),
                    ],
                ),
              ),
            ),
            
            // Bottom Buttons
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  // Share Button
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _sharePaymentDetails(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bagikan',
                              style: AppStyles.bodyText(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Kembali Button
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
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

  void _sharePaymentDetails(BuildContext context) {
    final String shareText = '''
🎉 Pembayaran Berhasil!

📋 Detail Pembayaran:
• ID Invoice: INV/0900/23922
• Nama Pengirim: Idris Nur Wahyudi
• Administrator: Diah Al Quwari
• Tanggal Konfirmasi: 20-09-2025

💰 Informasi Pembayaran:
• Rekening Pengirim: 3513839289292
• Nominal: ${amount != null ? 'Rp. ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}' : 'Rp. 1.400.000'}
• Keterangan: SPP 2025
• Nama Santri: Naufal Ramadhan

✅ Status: Pembayaran telah berhasil dikonfirmasi
📅 Waktu: 10-09-2025, 09:56 WIB

Terima kasih telah menggunakan layanan Alhamra! 🙏
    ''';

    _showShareBottomSheet(context, shareText);
  }

  void _showShareBottomSheet(BuildContext context, String shareText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                child: Column(
                  children: [
                    // App icons row
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildIOSAppIcon(
                            context,
                            Icons.content_copy,
                            'Salin',
                            Colors.grey[700]!,
                            () {
                              Clipboard.setData(ClipboardData(text: shareText));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Detail pembayaran berhasil disalin'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildIOSAppIcon(
                            context,
                            Icons.message,
                            'Pesan',
                            Colors.green,
                            () {
                              Navigator.pop(context);
                              _showComingSoonDialog(context, 'SMS');
                            },
                          ),
                          _buildIOSAppIcon(
                            context,
                            Icons.mail,
                            'Mail',
                            Colors.blue,
                            () {
                              Navigator.pop(context);
                              _showComingSoonDialog(context, 'Email');
                            },
                          ),
                          _buildIOSAppIcon(
                            context,
                            Icons.note_add,
                            'Catatan',
                            Colors.yellow[700]!,
                            () {
                              Navigator.pop(context);
                              _showComingSoonDialog(context, 'Catatan');
                            },
                          ),
                          _buildIOSAppIcon(
                            context,
                            Icons.more_horiz,
                            'Lainnya',
                            Colors.grey[600]!,
                            () {
                              Navigator.pop(context);
                              _showComingSoonDialog(context, 'Aplikasi lainnya');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    _buildIOSAction(
                      context,
                      Icons.bookmark_border,
                      'Tambah ke Bookmark',
                      () {
                        Navigator.pop(context);
                        _showComingSoonDialog(context, 'Bookmark');
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildIOSAction(
                      context,
                      Icons.print,
                      'Cetak',
                      () {
                        Navigator.pop(context);
                        _showComingSoonDialog(context, 'Print');
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
                  onPressed: () => Navigator.pop(context),
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

  Widget _buildIOSAppIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
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
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSAction(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black87,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segera Hadir'),
        content: Text('Fitur berbagi via $feature akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
}

