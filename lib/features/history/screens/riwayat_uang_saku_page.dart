import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../../core/models/pocket_money_history.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatUangSakuPage extends StatefulWidget {
  const RiwayatUangSakuPage({super.key});

  @override
  State<RiwayatUangSakuPage> createState() => _RiwayatUangSakuPageState();
}

class _RiwayatUangSakuPageState extends State<RiwayatUangSakuPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedPeriod = 'Bulan Ini';
  String _selectedCategory = 'Pemasukan';
  
  // Filter state variables from notification system
  String _selectedSortOrder = 'Terbaru';
  DateTime? _startDate;
  DateTime? _endDate;

  // Dummy data untuk riwayat uang saku
  final List<PocketMoneyHistory> _allTransactions = [
    PocketMoneyHistory(
      id: 'US-001',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 1200000,
      date: DateTime(2025, 7, 22, 12, 9),
      type: PocketMoneyTransactionType.incoming,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-002',
      title: 'Pembelian Makanan',
      subtitle: 'Kantin Pesantren',
      amount: 25000,
      date: DateTime(2025, 7, 21, 13, 30),
      type: PocketMoneyTransactionType.outgoing,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-003',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 500000,
      date: DateTime(2025, 7, 20, 10, 15),
      type: PocketMoneyTransactionType.incoming,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-004',
      title: 'Beli Alat Tulis',
      subtitle: 'Toko Buku Pesantren',
      amount: 45000,
      date: DateTime(2025, 7, 19, 16, 45),
      type: PocketMoneyTransactionType.outgoing,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-005',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 300000,
      date: DateTime(2025, 7, 18, 14, 20),
      type: PocketMoneyTransactionType.incoming,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-006',
      title: 'Laundry Pakaian',
      subtitle: 'Laundry Pesantren',
      amount: 15000,
      date: DateTime(2025, 7, 17, 11, 10),
      type: PocketMoneyTransactionType.outgoing,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-007',
      title: 'Snack & Minuman',
      subtitle: 'Warung Pak Haji',
      amount: 35000,
      date: DateTime(2025, 7, 16, 19, 30),
      type: PocketMoneyTransactionType.outgoing,
      bankName: 'Bank Mandiri',
    ),
    PocketMoneyHistory(
      id: 'US-008',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 200000,
      date: DateTime(2025, 7, 15, 9, 0),
      type: PocketMoneyTransactionType.incoming,
      bankName: 'Bank Mandiri',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(
          title: 'Riwayat Uang Saku',
          backgroundColor: AppStyles.primaryColor,
        ),
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppStyles.primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppStyles.primaryColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(text: 'Pemasukan'),
                  Tab(text: 'Pengeluaran'),
                  Tab(text: 'Laporan'),
                ],
              ),
            ),
            // Filter Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semua',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Filter',
                            style: GoogleFonts.poppins(
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.tune,
                            color: AppStyles.primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList(_getFilteredTransactions().where((t) => t.type == PocketMoneyTransactionType.incoming).toList()),
                  _buildTransactionList(_getFilteredTransactions().where((t) => t.type == PocketMoneyTransactionType.outgoing).toList()),
                  _buildReportTab(), // Laporan dengan chart
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<PocketMoneyHistory> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada transaksi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(PocketMoneyHistory transaction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.pink[300],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.bankName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.formattedDateTime,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            transaction.formattedAmount,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Filter
          Row(
            children: [
              _buildPeriodChip('Bulan Ini', _selectedPeriod == 'Bulan Ini'),
              const SizedBox(width: 8),
              _buildPeriodChip('Bulan Lalu', _selectedPeriod == 'Bulan Lalu'),
              const SizedBox(width: 8),
              _buildPeriodChip('3 Bulan', _selectedPeriod == '3 Bulan'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Period Label
          Text(
            _selectedPeriod,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Selisih',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp. 354.000',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppStyles.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pemasukan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+Rp.1.250.000',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.pink[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pengeluaran',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '-Rp.250.000',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Doughnut Chart
          Container(
            height: 200,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: _getChartData(),
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  pointColorMapper: (ChartData data, _) => data.color,
                  innerRadius: '70%',
                  radius: '90%',
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                  ),
                ),
              ],
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '25%',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                      Text(
                        'Pengeluaran',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Category Sections
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Pemasukan';
                    });
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: 2,
                        color: _selectedCategory == 'Pemasukan' ? AppStyles.primaryColor : Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: _selectedCategory == 'Pemasukan' ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedCategory == 'Pemasukan' ? AppStyles.primaryColor : Colors.grey[600],
                        ),
                        child: const Text('Pemasukan'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Pengeluaran';
                    });
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: 2,
                        color: _selectedCategory == 'Pengeluaran' ? AppStyles.primaryColor : Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: _selectedCategory == 'Pengeluaran' ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedCategory == 'Pengeluaran' ? AppStyles.primaryColor : Colors.grey[600],
                        ),
                        child: const Text('Pengeluaran'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Transaction List for Report
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                ),
              );
            },
            child: Column(
              key: ValueKey(_selectedCategory),
              children: (_selectedCategory == 'Pemasukan' 
                  ? _getFilteredTransactions().where((t) => t.type == PocketMoneyTransactionType.incoming).take(2)
                  : _getFilteredTransactions().where((t) => t.type == PocketMoneyTransactionType.outgoing).take(2)
              ).map((transaction) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildTransactionItem(transaction),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppStyles.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    String tempSortOrder = _selectedSortOrder;
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Riwayat',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Sort Order Section
                  Text(
                    'Urutkan Berdasarkan Waktu',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSortButton(
                          'Terbaru',
                          tempSortOrder == 'Terbaru',
                          () {
                            setModalState(() {
                              tempSortOrder = 'Terbaru';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSortButton(
                          'Terlama',
                          tempSortOrder == 'Terlama',
                          () {
                            setModalState(() {
                              tempSortOrder = 'Terlama';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Date Range Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dari',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDatePicker(
                              tempStartDate,
                              'Pilih Tanggal Awal',
                              (date) {
                                setModalState(() {
                                  tempStartDate = date;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sampai',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDatePicker(
                              tempEndDate,
                              'Pilih Tanggal Akhir',
                              (date) {
                                setModalState(() {
                                  tempEndDate = date;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSortOrder = 'Terbaru';
                              _startDate = null;
                              _endDate = null;
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppStyles.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Atur Ulang',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSortOrder = tempSortOrder;
                              _startDate = tempStartDate;
                              _endDate = tempEndDate;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Terapkan',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppStyles.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(DateTime? selectedDate, String placeholder, Function(DateTime?) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppStyles.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : placeholder,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selectedDate != null ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  List<PocketMoneyHistory> _getFilteredTransactions() {
    List<PocketMoneyHistory> filtered = List.from(_allTransactions);
    
    // Filter by date range
    if (_startDate != null || _endDate != null) {
      filtered = filtered.where((transaction) {
        final transactionDate = transaction.date;
        
        if (_startDate != null && _endDate != null) {
          return transactionDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                 transactionDate.isBefore(_endDate!.add(const Duration(days: 1)));
        } else if (_startDate != null) {
          return transactionDate.isAfter(_startDate!.subtract(const Duration(days: 1)));
        } else if (_endDate != null) {
          return transactionDate.isBefore(_endDate!.add(const Duration(days: 1)));
        }
        
        return true;
      }).toList();
    }
    
    // Sort by date
    if (_selectedSortOrder == 'Terbaru') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    }
    
    return filtered;
  }

  List<ChartData> _getChartData() {
    return [
      ChartData('Pemasukan', 75, AppStyles.primaryColor),
      ChartData('Pengeluaran', 25, Colors.pink[300]!),
    ];
  }
}

class ChartData {
  ChartData(this.category, this.value, this.color);
  final String category;
  final double value;
  final Color color;
}
