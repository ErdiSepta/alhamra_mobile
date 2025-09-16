import '../../../features/topup/screens/topup_page.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/data/student_data.dart';
import '../../../features/payment/screens/standalone_pembayaran_page.dart';
import '../../../features/notifications/screens/pemberitahuan_page.dart';
import '../../../features/payment/screens/status_berhasil_page.dart';
import '../../../core/services/notification_service.dart';
import '../../history/screens/riwayat_tagihan_page.dart';
import '../../history/screens/riwayat_uang_saku_page.dart';
import '../../history/screens/riwayat_dompet_page.dart';
import '../../shared/widgets/index.dart';
import '../../shared/widgets/student_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarLight = false;

  // Santri selection state
  String _selectedSantri = StudentData.defaultStudent;
  final List<String> _allSantri = StudentData.allStudents;
  bool _isStudentOverlayVisible = false;

  // Saldo amounts
  String _amountTagihan = 'Rp 2.345.000';
  String _amountUangSaku = 'Rp 2.345.000';
  String _amountDompet = 'Rp 2.345.000';

  // Saldo visibility and refresh
  bool _saldoHidden = false;
  bool _isRefreshing = false;
  Timer? _refreshTimer;
  int _ellipsisStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    _scrollController.addListener(() {
      final shouldLight = _scrollController.offset > 16;
      if (shouldLight != _isAppBarLight) {
        setState(() {
          _isAppBarLight = shouldLight;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _onSantriChanged(String santri) {
    setState(() {
      _selectedSantri = santri;
    });
  }

  void _triggerRefresh() {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
      _ellipsisStep = 0;
    });
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted || !_isRefreshing) return;
      setState(() {
        _ellipsisStep = (_ellipsisStep + 1) % 3;
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _refreshTimer?.cancel();
      setState(() {
        _isRefreshing = false;
      });
    });
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
        backgroundColor: AppStyles.primaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: _isAppBarLight
                ? Colors.white
                : AppStyles.primaryColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            systemOverlayStyle: _isAppBarLight
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamualaikum,',
                        style: AppStyles.headerGreeting(context).copyWith(
                          color: _isAppBarLight ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        'Muhammad Faithfullah Ilhamy Azda',
                        style: AppStyles.headerUsername(context).copyWith(
                          color: _isAppBarLight ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => const PemberitahuanPage()),
                      );
                    },
                    child: Stack(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          color: _isAppBarLight
                              ? AppStyles.primaryColor
                              : Colors.white,
                          size: 30,
                        ),
                        AnimatedBuilder(
                          animation: NotificationService(),
                          builder: (context, child) {
                            final notificationService = NotificationService();
                            if (!notificationService.hasUnreadNotifications) {
                              return const SizedBox.shrink();
                            }
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    notificationService.unreadCount > 9 
                                        ? '9+' 
                                        : notificationService.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildSantriSelector(),
                  const SizedBox(height: 20),
                  _buildInfoCarousel(),
                  const SizedBox(height: 10),
                  _buildPageIndicator(),
                  const SizedBox(height: 16),
                  _buildBottomContent(),
                ],
              ),
            ),
            // Add overlay at the top level to ensure it appears above all content
            if (_isStudentOverlayVisible)
              SearchOverlayWidget(
                isVisible: _isStudentOverlayVisible,
                title: 'Pilih Santri',
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
                searchHint: 'Cari santri...',
                avatarUrl: StudentData.defaultAvatarUrl,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildSantriSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: StudentSelectionWidget(
        selectedStudent: _selectedSantri,
        students: _allSantri,
        onStudentChanged: _onSantriChanged,
        onOverlayVisibilityChanged: (visible) {
          setState(() {
            _isStudentOverlayVisible = visible;
          });
        },
        avatarUrl: StudentData.defaultAvatarUrl,
      ),
    );
  }


  Widget _buildInfoCarousel() {
    return SizedBox(
      height: 160,
      child: PageView(
        controller: _pageController,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            tween: Tween<double>(
              begin: 0.95,
              end: _currentPage == 0 ? 1.0 : 0.95,
            ),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: InfoCardWidget(
              title: 'Total Tagihan',
              amount: _amountTagihan,
              buttonText: 'Bayar',
              buttonIcon: Icons.payment,
              historyText: 'Riwayat Tagihan',
              onButtonPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const StandalonePembayaranPage()),
                );
              },
              onHistoryPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const RiwayatTagihanPage()),
                );
              },
              onRefresh: _triggerRefresh,
              isRefreshing: _isRefreshing,
              isAmountHidden: _saldoHidden,
              onToggleVisibility: () {
                setState(() {
                  _saldoHidden = !_saldoHidden;
                });
              },
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            tween: Tween<double>(
              begin: 0.95,
              end: _currentPage == 1 ? 1.0 : 0.95,
            ),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: InfoCardWidget(
              title: 'Total Uang Saku',
              amount: _amountUangSaku,
              buttonText: 'Top Up',
              buttonIcon: Icons.add_circle_outline,
              historyText: 'Riwayat Uang Saku',
              onButtonPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const TopUpPage()),
                );
              },
              onHistoryPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const RiwayatUangSakuPage()),
                );
              },
              onRefresh: _triggerRefresh,
              isRefreshing: _isRefreshing,
              isAmountHidden: _saldoHidden,
              onToggleVisibility: () {
                setState(() {
                  _saldoHidden = !_saldoHidden;
                });
              },
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            tween: Tween<double>(
              begin: 0.95,
              end: _currentPage == 2 ? 1.0 : 0.95,
            ),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: InfoCardWidget(
              title: 'Total Saldo Dompet',
              amount: _amountDompet,
              historyText: 'Riwayat Dompet',
              onHistoryPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const RiwayatDompetPage()),
                );
              },
              onRefresh: _triggerRefresh,
              isRefreshing: _isRefreshing,
              isAmountHidden: _saldoHidden,
              onToggleVisibility: () {
                setState(() {
                  _saldoHidden = !_saldoHidden;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }


  Widget _buildBottomContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Menu',
            style: AppStyles.bodyText(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              // Test Status Berhasil Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => const StatusBerhasilPage(amount: 1400000),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Status Berhasil',
                      style: AppStyles.bodyText(
                        context,
                      ).copyWith(fontSize: 10, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              // Regular menu items
              ...List.generate(7, (i) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.apps,
                        color: AppStyles.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Menu ${i + 2}',
                      style: AppStyles.bodyText(
                        context,
                      ).copyWith(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Fasilitas Pesantren',
            style: AppStyles.bodyText(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                return Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Fasilitas ${i + 1}',
                        style: AppStyles.bodyText(
                          context,
                        ).copyWith(color: Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Berita',
            style: AppStyles.bodyText(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, i) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppStyles.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.article,
                    color: AppStyles.primaryColor,
                  ),
                ),
                title: Text(
                  'Judul Berita ${i + 1}',
                  style: AppStyles.bodyText(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                ),
                subtitle: const Text('Ringkasan singkat berita...'),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppStyles.primaryColor,
                ),
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
