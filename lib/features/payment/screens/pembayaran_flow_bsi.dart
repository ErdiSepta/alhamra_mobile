import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/app_styles.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../../core/models/bill.dart';
import '../../payment/screens/status_menunggu_page.dart';

class PembayaranConfirmPage extends StatelessWidget {
  const PembayaranConfirmPage({super.key, required this.bills});
  final List<Bill> bills;

  int get total => bills.fold(0, (prev, b) => prev + b.outstanding);

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final themed = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Poppins'),
    );

    return Theme(
      data: themed,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Konfirmasi Pembayaran'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(context),
              const SizedBox(height: 16),
              _buildBillsCard(context),
              const SizedBox(height: 16),
              _buildMethodCard(context),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bills.isEmpty
                      ? null
                      : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: Text('Buat kode bayar untuk total ' + _rupiah(total) + '?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Ya, Lanjut'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PembayaranPaymentPage(amount: total),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                  ),
                  child: const Text('Buat Kode Bayar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppStyles.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long, color: AppStyles.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Pembayaran', style: AppStyles.bodyText(context).copyWith(color: Colors.black54)),
                const SizedBox(height: 4),
                Text(_rupiah(total), style: AppStyles.saldoValue(context).copyWith(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Tagihan',
            style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 8),
          ...bills.map((b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        b.title,
                        style: AppStyles.bodyText(context).copyWith(color: Colors.black87),
                      ),
                    ),
                    Text(
                      _rupiah(b.outstanding),
                      style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Text('Total', style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
              ),
              Text(_rupiah(total), style: AppStyles.saldoValue(context).copyWith(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
            child: const Icon(Icons.account_balance, color: AppStyles.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('BSI Virtual Account', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                SizedBox(height: 2),
                Text('Pembayaran dicek otomatis'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _rupiah(int amount) {
    final s = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return 'Rp ' + s.replaceAllMapped(reg, (m) => '.');
  }
}

class PembayaranPaymentPage extends StatefulWidget {
  const PembayaranPaymentPage({super.key, required this.amount});
  final int amount;

  @override
  State<PembayaranPaymentPage> createState() => _PembayaranPaymentPageState();
}

class _PembayaranPaymentPageState extends State<PembayaranPaymentPage> {
  late Timer _timer;
  Duration _remaining = const Duration(minutes: 30);
  final String _vaNumber = '9001234567890123';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _countdownString {
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = _remaining.inHours.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final themed = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Poppins'),
    );

    return Theme(
      data: themed,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Pembayaran BSI'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context),
              const SizedBox(height: 16),
              _buildSteps(context),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                child: const Icon(Icons.account_balance, color: AppStyles.primaryColor),
              ),
              const SizedBox(width: 12),
              Text('BSI Virtual Account', style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('Batas bayar: ' + _countdownString, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Nomor Virtual Account', style: AppStyles.bodyText(context).copyWith(color: Colors.black54)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    _vaNumber,
                    style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _vaNumber));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor VA disalin')));
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Salin'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nominal', style: AppStyles.bodyText(context).copyWith(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(_rupiah(widget.amount), style: AppStyles.saldoValue(context).copyWith(fontSize: 20)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Biaya Admin', style: AppStyles.bodyText(context).copyWith(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(_rupiah(0), style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    final methods = [
      {
        'title': 'BSI Mobile',
        'steps': [
          'Buka aplikasi BSI Mobile dan login',
          'Pilih menu Pembayaran > Virtual Account Billing',
          'Masukkan nomor VA: ' + _vaNumber,
          'Periksa detail transaksi dan konfirmasi',
          'Masukkan PIN BSI Mobile untuk menyelesaikan pembayaran',
        ],
      },
      {
        'title': 'Internet Banking BSI',
        'steps': [
          'Login ke Internet Banking BSI',
          'Pilih menu Pembayaran/Transfer > Virtual Account',
          'Masukkan nomor Virtual Account: ' + _vaNumber,
          'Periksa detail transaksi dan konfirmasi OTP jika diminta',
          'Selesaikan pembayaran',
        ],
      },
      {
        'title': 'ATM BSI',
        'steps': [
          'Masukkan kartu ATM BSI dan PIN',
          'Pilih menu Pembayaran > Lainnya > Virtual Account',
          'Masukkan nomor Virtual Account: ' + _vaNumber,
          'Periksa detail transaksi lalu konfirmasi',
          'Selesaikan pembayaran dan simpan struk',
        ],
      },
      {
        'title': 'ATM Bank Lain / Jaringan ATM',
        'steps': [
          'Masukkan kartu ATM bank lain dan PIN',
          'Pilih Transfer ke Bank Lain / Antar Bank',
          'Pilih bank tujuan BSI (kode bank 451) bila diminta kode bank',
          'Masukkan nomor rekening tujuan dengan nomor Virtual Account: ' + _vaNumber,
          'Masukkan nominal sesuai tagihan dan konfirmasi',
          'Selesaikan pembayaran dan simpan bukti transaksi',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Petunjuk Pembayaran',
          style: AppStyles.bodyText(context).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: methods.map((m) {
              final title = m['title'] as String;
              final steps = (m['steps'] as List<String>);
              return Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  title: Text(
                    title,
                    style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          _StepItem(index: i + 1, text: steps[i]),
                          if (i != steps.length - 1) const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10 + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nominal', style: AppStyles.bodyText(context).copyWith(color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(
                    _rupiah(widget.amount),
                    style: AppStyles.saldoValue(context).copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Anda yakin sudah melakukan pembayaran?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Ya, Lanjut'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StatusMenungguPage(amount: widget.amount),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Saya Sudah Bayar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _rupiah(int amount) {
    final s = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return 'Rp ' + s.replaceAllMapped(reg, (m) => '.');
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.index, required this.text});
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppStyles.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: const TextStyle(color: AppStyles.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}


