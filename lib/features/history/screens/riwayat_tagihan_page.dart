import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/models/bill.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatTagihanPage extends StatefulWidget {
  const RiwayatTagihanPage({super.key});

  @override
  State<RiwayatTagihanPage> createState() => _RiwayatTagihanPageState();
}

class _RiwayatTagihanPageState extends State<RiwayatTagihanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Bulan Ini';
  String _selectedCategory = 'Pemasukan';
  
  // Filter state variables from notification system
  String _selectedSortOrder = 'Terbaru';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();
  bool _showFilter = false;

  // Dummy data untuk riwayat tagihan
  final List<Bill> _allBills = [
    Bill(
      id: 'TGH-001',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 1200000,
      dueDate: DateTime(2025, 7, 22, 12, 9),
      status: BillStatus.paid,
      period: 'Juli 2025',
    ),
    Bill(
      id: 'TGH-002',
      title: 'Pembayaran SPP',
      subtitle: 'November 2024',
      amount: 350000,
      dueDate: DateTime(2025, 7, 21, 14, 30),
      status: BillStatus.paid,
      period: 'November 2024',
    ),
    Bill(
      id: 'TGH-003',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 800000,
      dueDate: DateTime(2025, 7, 20, 10, 15),
      status: BillStatus.paid,
      period: 'Juli 2025',
    ),
    Bill(
      id: 'TGH-004',
      title: 'Biaya Makan',
      subtitle: 'Oktober 2024',
      amount: 450000,
      dueDate: DateTime(2025, 7, 19, 16, 45),
      status: BillStatus.paid,
      period: 'Oktober 2024',
    ),
    Bill(
      id: 'TGH-005',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 600000,
      dueDate: DateTime(2025, 7, 18, 14, 20),
      status: BillStatus.paid,
      period: 'Juli 2025',
    ),
    Bill(
      id: 'TGH-006',
      title: 'Biaya Seragam',
      subtitle: 'September 2024',
      amount: 275000,
      dueDate: DateTime(2025, 7, 17, 11, 10),
      status: BillStatus.paid,
      period: 'September 2024',
    ),
    Bill(
      id: 'TGH-004',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 1200000,
      dueDate: DateTime(2025, 7, 22, 12, 9),
      status: BillStatus.paid,
      period: 'Juli 2025',
    ),
    Bill(
      id: 'TGH-005',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 1200000,
      dueDate: DateTime(2025, 7, 22, 12, 9),
      status: BillStatus.paid,
      period: 'Juli 2025',
    ),
    Bill(
      id: 'TGH-006',
      title: 'Dana Masuk Dari',
      subtitle: 'Muhammad Ilham',
      amount: 1200000,
      dueDate: DateTime(2025, 7, 22, 12, 9),
      status: BillStatus.paid,
      period: 'Juli 2025',
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
          title: 'Riwayat Tagihan',
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
                    onTap: () {
                      setState(() {
                        _showFilter = !_showFilter;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.tune,
                          color: AppStyles.primaryColor,
                          size: 20,
                        ),
                      ],
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
                  _buildTransactionList(_allBills),
                  _buildTransactionList([]), // Empty for pengeluaran
                  _buildReportTab(), // Laporan dengan chart
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Bill> bills) {
    if (bills.isEmpty) {
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
      itemCount: bills.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _buildTransactionItem(bill);
      },
    );
  }

  Widget _buildTransactionItem(Bill bill) {
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
                  bill.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bill.subtitle ?? '',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bank Mandiri',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(bill.dueDate),
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
            _formatAmount(bill.amount),
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

  String _formatAmount(int amount) {
    final s = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return '- Rp ${s.replaceAllMapped(reg, (m) => '.')}';
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day Juli $year $hour:$minute WIB';
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
                  'Rp. 7.200.000',
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
                            '+Rp.7.200.000',
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
                            '-Rp.0',
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
                        '100%',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.primaryColor,
                        ),
                      ),
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
                  ? _allBills.where((bill) => bill.title.contains('Dana Masuk')).take(2)
                  : _allBills.where((bill) => !bill.title.contains('Dana Masuk')).take(2)
              ).map((bill) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildTransactionItem(bill),
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

  List<ChartData> _getChartData() {
    return [
      ChartData('Pemasukan', 100, AppStyles.primaryColor),
      ChartData('Pengeluaran', 0, Colors.pink[300]!),
    ];
  }
}

class ChartData {
  ChartData(this.category, this.value, this.color);
  final String category;
  final double value;
  final Color color;
}
