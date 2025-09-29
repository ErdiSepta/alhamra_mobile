 import 'package:alhamra_1/core/utils/app_styles.dart';
 import '../../core/data/dashboard_data.dart';
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
     return Scaffold(
       backgroundColor: AppStyles.greyColor,
       appBar: AppBar(
         backgroundColor: AppStyles.primaryColor,
         foregroundColor: Colors.white,
         elevation: 0,
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text('Assalamualaikum,', style: AppStyles.headerGreeting(context).copyWith(color: Colors.white70)),
             Text('Naufal Ramadhan', style: AppStyles.headerUsername(context).copyWith(color: Colors.white)),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () {},
             child: const Text('Ganti', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
           ),
           const SizedBox(width: 10),
         ],
         bottom: TabBar(
           controller: _tabController,
           labelColor: Colors.white,
           unselectedLabelColor: Colors.white.withOpacity(0.7),
           indicatorColor: Colors.white,
           indicatorWeight: 3,
           tabs: const [
             Tab(text: 'Semua'),
             Tab(text: 'Keuangan'),
             Tab(text: 'Kesantrian'),
             Tab(text: 'Akademik'),
           ],
         ),
       ),
       body: TabBarView(
         controller: _tabController,
         children: [
           _buildSemuaTab(), // Tab "Semua"
           _buildKeuanganTab(), // Tab "Keuangan"
           _buildKesantrianTab(), // Tab "Kesantrian"
           _buildAkademikTab(), // Tab "Akademik"
         ],
       ),
     );
   }
 
   // Widget untuk Tab "Semua"
   Widget _buildSemuaTab() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildSectionTitle('Keuangan'),
           _buildKeuanganCard(_dashboardData.keuangan),
           const SizedBox(height: 20),
           _buildSectionTitle('Kesantrian'),
           _buildKesantrianCard(_dashboardData.kesantrian),
           const SizedBox(height: 20),
           _buildSectionTitle('Akademik'),
           _buildAkademikCard(_dashboardData.akademik),
         ],
       ),
     );
   }
 
   // Placeholder untuk Tab "Keuangan"
   Widget _buildKeuanganTab() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: _buildKeuanganCard(_dashboardData.keuangan, isFullPage: true),
     );
   }
 
   // Placeholder untuk Tab "Kesantrian"
   Widget _buildKesantrianTab() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: _buildKesantrianCard(_dashboardData.kesantrian, isFullPage: true),
     );
   }
 
   // Placeholder untuk Tab "Akademik"
   Widget _buildAkademikTab() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: _buildAkademikCard(_dashboardData.akademik, isFullPage: true),
     );
   }
 
   Widget _buildSectionTitle(String title) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 12.0),
       child: Text(title, style: AppStyles.heading2(context)),
     );
   }
 
   // --- KUMPULAN WIDGET CARD ---
 
   Widget _buildKeuanganCard(KeuanganOverview data, {bool isFullPage = false}) {
     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _buildInfoChip('Total Tagihan', data.totalTagihan),
                 _buildInfoChip('Uang Saku', data.saldoUangSaku),
                 _buildInfoChip('Saldo Wallet', data.saldoDompet),
               ],
             ),
             const SizedBox(height: 20),
             const Divider(),
             const SizedBox(height: 10),
             Text('Statistika Pembayaran', style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.bold)),
             SizedBox(
               height: 150,
               child: PieChart(
                 PieChartData(
                   sections: [
                     PieChartSectionData(
                       color: Colors.green,
                       value: data.persentaseLunas,
                       title: '${data.persentaseLunas.toInt()}%',
                       radius: 50,
                       titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                     ),
                     PieChartSectionData(
                       color: Colors.red,
                       value: 100 - data.persentaseLunas,
                       title: '${(100 - data.persentaseLunas).toInt()}%',
                       radius: 50,
                       titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                     ),
                   ],
                   sectionsSpace: 2,
                   centerSpaceRadius: 30,
                 ),
               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 _buildLegend(Colors.green, 'Lunas'),
                 const SizedBox(width: 20),
                 _buildLegend(Colors.red, 'Kurang'),
               ],
             )
           ],
         ),
       ),
     );
   }
 
   Widget _buildKesantrianCard(KesantrianOverview data, {bool isFullPage = false}) {
     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _buildDetailRow('Total Hafalan', data.totalHafalan),
             _buildDetailRow('Semester Ini', data.detailSetoran),
             _buildDetailRow('Setoran Terakhir', data.setoranTerakhir),
             const Divider(height: 24),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 _buildCountChip('Pelanggaran', data.jumlahPelanggaran.toString(), Colors.red),
                 _buildCountChip('Izin', data.jumlahIzin.toString(), Colors.blue),
               ],
             )
           ],
         ),
       ),
     );
   }
 
   Widget _buildAkademikCard(AkademikOverview data, {bool isFullPage = false}) {
     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 _buildCountChip('Total Absen', '${data.totalAbsen} Hari', Colors.orange),
                 _buildCountChip('Rata-rata Nilai', data.rataRataNilai.toString(), Colors.purple),
               ],
             ),
             const SizedBox(height: 20),
             const Divider(),
             const SizedBox(height: 10),
             Text('Perkembangan Nilai (6 Bulan)', style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.bold)),
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
 
   // --- KUMPULAN WIDGET HELPER ---
 
   Widget _buildInfoChip(String title, String value) {
     return Column(
       children: [
         Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
         const SizedBox(height: 4),
         Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
       ],
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
 
   Widget _buildDetailRow(String title, String value) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 6.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(title, style: TextStyle(color: Colors.grey[700])),
           Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
         ],
       ),
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