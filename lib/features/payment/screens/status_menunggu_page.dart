import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';

class StatusMenungguPage extends StatelessWidget {
  final int? amount;
  
  const StatusMenungguPage({super.key, this.amount});

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
              child: SingleChildScrollView(
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
                                color: Colors.blue,
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
                      
                      // Status Text with Clock Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Menunggu Konfirmasi',
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
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_time,
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
            ),
            
            // Kembali Button positioned at bottom
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                width: double.infinity,
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
