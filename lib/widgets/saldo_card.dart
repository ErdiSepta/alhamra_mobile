import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alhamra_1/utils/app_styles.dart';

class SaldoCard extends StatefulWidget {
  final String? studentName;
  final String saldoAmount;
  final VoidCallback? onGantiPressed;
  final VoidCallback? onTopUpPressed;
  final VoidCallback? onRiwayatPressed;

  const SaldoCard({
    super.key,
    this.studentName,
    this.saldoAmount = 'Rp ••••••••••',
    this.onGantiPressed,
    this.onTopUpPressed,
    this.onRiwayatPressed,
  });

  @override
  State<SaldoCard> createState() => _SaldoCardState();
}

class _SaldoCardState extends State<SaldoCard> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    print('🔥 TOGGLE BERHASIL DIKLIK! 🔥');
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
    print('Status sekarang: $_isBalanceVisible');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER SECTION - SIMPLE ROW
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF0BD4A0).withOpacity(0.1),
                child: const Icon(Icons.person, color: Color(0xFF0BD4A0), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.studentName ?? 'Naufal Ramadhan',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: widget.onGantiPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ganti', style: GoogleFonts.poppins(color: const Color(0xFF0BD4A0))),
                    const SizedBox(width: 4),
                    const Icon(Icons.swap_horiz, color: Color(0xFF0BD4A0), size: 16),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // SALDO SECTION - SUPER SIMPLE!
          Text('Saldo Uang Saku', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
          
          const SizedBox(height: 8),
          
          // SALDO DAN TOGGLE - DALAM SATU BARIS SEDERHANA
          Row(
            children: [
              Text(
                _isBalanceVisible ? widget.saldoAmount : 'Rp ••••••••••',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              // TOGGLE BUTTON SUPER SEDERHANA!
              TextButton(
                onPressed: _toggleBalanceVisibility,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0BD4A0).withOpacity(0.1),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                ),
                child: Icon(
                  _isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF0BD4A0),
                  size: 20,
                ),
              ),
              const Spacer(),
              // TOP UP BUTTON
              TextButton(
                onPressed: widget.onTopUpPressed,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0BD4A0).withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0BD4A0)),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF0BD4A0), size: 16),
                    ),
                    const SizedBox(height: 4),
                    Text('Top Up', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF0BD4A0))),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // RIWAYAT SECTION - SIMPLE
          TextButton(
            onPressed: widget.onRiwayatPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: Color(0xFF0BD4A0), size: 20),
                const SizedBox(width: 8),
                Text('Riwayat Transaksi', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}