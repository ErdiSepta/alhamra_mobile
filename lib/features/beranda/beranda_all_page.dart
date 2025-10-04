import 'package:alhamra_1/core/utils/app_styles.dart';
import '../../core/data/dashboard_data.dart';
import '../../core/data/student_data.dart';
import '../../core/localization/app_localizations.dart';
import '../shared/widgets/search_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BerandaAllPage extends StatefulWidget {
  const BerandaAllPage({super.key});

  @override
  State<BerandaAllPage> createState() => _BerandaAllPageState();
}

class _BerandaAllPageState extends State<BerandaAllPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DashboardData _dashboardData;
  
  // Santri selection state
  String _selectedSantri = StudentData.defaultStudent;
  final List<String> _allSantri = StudentData.allStudents;
  bool _isStudentOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _dashboardData = DashboardData.getSampleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scaffold
        Scaffold(
          body: Column(
            children: [
              // Blue header section
              Container(
                color: AppStyles.primaryColor,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildStudentSelector(),
                    ],
                  ),
                ),
              ),
              // Tab bar section
              _buildTabBar(),
              // White content section
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: IgnorePointer(
                    ignoring: _isStudentOverlayVisible,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSemuaTab(),
                        _buildKeuanganTab(),
                        _buildKesantrianTab(),
                        _buildAkademikTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Full-screen overlay untuk pemilihan santri
        if (_isStudentOverlayVisible)
          SearchOverlayWidget(
            isVisible: _isStudentOverlayVisible,
            title: AppLocalizations.of(context).pilihSantri,
            items: _allSantri,
            selectedItem: _selectedSantri,
            onItemSelected: (santri) {
              setState(() {
                _selectedSantri = santri;
                _isStudentOverlayVisible = false;
              });
            },
            onClose: () {
              setState(() {
                _isStudentOverlayVisible = false;
              });
            },
            searchHint: AppLocalizations.of(context).cariSantri,
            avatarUrl: StudentData.defaultAvatarUrl,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localizations.beranda,
            style: AppStyles.heading1(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(StudentData.defaultAvatarUrl),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            // Student name
            Expanded(
              child: Text(
                _selectedSantri,
                style: AppStyles.bodyText(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Ganti button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isStudentOverlayVisible = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localizations.ganti,
                      style: AppStyles.bodyText(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppStyles.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppStyles.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final localizations = AppLocalizations.of(context);
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: AppStyles.primaryColor,
        indicatorWeight: 2,
        labelColor: AppStyles.primaryColor,
        unselectedLabelColor: Colors.grey[600],
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(text: localizations.semua),
          Tab(text: localizations.keuangan),
          Tab(text: localizations.kesantrian),
          Tab(text: localizations.akademik),
        ],
      ),
    );
  }


  Widget _buildSemuaTab() {
    return Container(
      color: AppStyles.greyColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKeuanganCards(_dashboardData.keuangan),
            const SizedBox(height: 20),
            _buildKesantrianCards(_dashboardData.kesantrian),
            const SizedBox(height: 20),
            _buildAkademikCard(_dashboardData.akademik),
          ],
        ),
      ),
    );
  }

  Widget _buildKeuanganTab() {
    return Container(
      color: AppStyles.greyColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildKeuanganCards(_dashboardData.keuangan),
      ),
    );
  }

  Widget _buildKesantrianTab() {
    return Container(
      color: AppStyles.greyColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildKesantrianCards(_dashboardData.kesantrian),
      ),
    );
  }

  Widget _buildAkademikTab() {
    return Container(
      color: AppStyles.greyColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildAkademikCard(_dashboardData.akademik, isFullPage: true),
      ),
    );
  }

  Widget _buildKeuanganCards(KeuanganOverview data) {
    final localizations = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and filter icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.keuangan,
                  style: AppStyles.heading2(context),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppStyles.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // First row - Total Tagihan Aktif
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.totalTagihanAktif,
                    style: AppStyles.sectionTitle(context).copyWith(
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.totalTagihan,
                    style: AppStyles.heading1(context).copyWith(
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Second row - Saldo cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.saldoUangSaku,
                          style: AppStyles.sectionTitle(context).copyWith(
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.saldoUangSaku,
                          style: AppStyles.saldoValue(context).copyWith(
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBDEFB), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.saldoWallet,
                          style: AppStyles.sectionTitle(context).copyWith(
                            color: const Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.saldoDompet,
                          style: AppStyles.saldoValue(context).copyWith(
                            color: const Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Progress indicators
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${localizations.lunas} ${data.persentaseLunas.toInt()}%',
                  style: AppStyles.sectionTitle(context),
                ),
                const SizedBox(width: 24),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${localizations.kurang} ${(100 - data.persentaseLunas).toInt()}%',
                  style: AppStyles.sectionTitle(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: data.persentaseLunas.toInt(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF2196F3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (100 - data.persentaseLunas).toInt(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Pie Chart
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF2196F3),
                        value: data.persentaseLunas,
                        title: '${localizations.lunas}\n${data.persentaseLunas.toInt()}%',
                        radius: 80,
                        titleStyle: AppStyles.sectionTitle(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        titlePositionPercentageOffset: 0.6,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFFF5252),
                        value: 100 - data.persentaseLunas,
                        title: '${localizations.kurang}\n${(100 - data.persentaseLunas).toInt()}%',
                        radius: 80,
                        titleStyle: AppStyles.sectionTitle(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        titlePositionPercentageOffset: 0.6,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(const Color(0xFF2196F3), localizations.lunas),
                const SizedBox(width: 32),
                _buildLegend(const Color(0xFFFF5252), localizations.kurang),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildKesantrianCards(KesantrianOverview data) {
    final localizations = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header with title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.kesantrian,
                  style: AppStyles.heading2(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppStyles.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Cards row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.totalHafalan,
                          style: AppStyles.sectionTitle(context).copyWith(
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.totalHafalan,
                          style: AppStyles.saldoValue(context).copyWith(
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBDEFB), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.semesterIni,
                          style: AppStyles.sectionTitle(context).copyWith(
                            color: const Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.detailSetoran,
                          style: AppStyles.facilityDescription(context).copyWith(
                            color: const Color(0xFF1976D2),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAkademikCard(AkademikOverview data, {bool isFullPage = false}) {
    final localizations = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.akademik,
                  style: AppStyles.heading2(context),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppStyles.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountChip(localizations.totalAbsen, '${data.totalAbsen} ${localizations.hari}', Colors.orange),
                _buildCountChip(localizations.rataRataNilai, data.rataRataNilai.toString(), Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text('${localizations.perkembanganNilai} (6 ${localizations.bulan})', style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.perkembanganNilai.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(data.perkembanganNilai[value.toInt()].bulan, style: const TextStyle(fontSize: 10)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.perkembanganNilai.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.nilai);
                      }).toList(),
                      isCurved: true,
                      color: AppStyles.primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppStyles.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCountChip(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
      ],
    );
  }


  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
