import '../../../features/topup/screens/topup_page.dart';
import '../../../core/utils/app_styles.dart';
import '../../../features/payment/screens/standalone_pembayaran_page.dart';
import '../../../features/notifications/screens/pemberitahuan_page.dart';
import '../../../features/payment/screens/status_berhasil_page.dart';
import '../../../core/services/notification_service.dart';
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
  bool _isOverlayVisible = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarLight = false;

  // Santri selection state
  String _selectedSantri = 'Naufal Ramadhan';
  final TextEditingController _santriSearchController = TextEditingController();
  final List<String> _allSantri = [
    'Naufal Ramadhan',
    'Santri 2',
    'Ahmad Fauzi',
    'Budi Santoso',
    'Siti Aisyah',
    'Nurul Huda',
    'Rahmat Hidayat',
  ];
  List<String> _filteredSantri = [];

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
    _filteredSantri = List.from(_allSantri);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    _santriSearchController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
      if (_isOverlayVisible) {
        _santriSearchController.clear();
        _filteredSantri = List.from(_allSantri);
      }
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
            if (_isOverlayVisible) _buildOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
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
              Stack(
                children: [
                  Icon(
                    Icons.notifications_none,
                    color: _isAppBarLight
                        ? AppStyles.primaryColor
                        : Colors.white,
                    size: 30,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSantriSelector() {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
              ),
              const SizedBox(width: 15),
              Text(_selectedSantri, style: AppStyles.cardUsername(context)),
              const Spacer(),
              Text(
                'Ganti',
                style: AppStyles.bodyText(
                  context,
                ).copyWith(color: AppStyles.primaryColor),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.swap_horiz,
                color: AppStyles.primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Santri',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _santriSearchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari santri...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (q) {
                    final query = q.toLowerCase();
                    setState(() {
                      _filteredSantri = _allSantri
                          .where((s) => s.toLowerCase().contains(query))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: _filteredSantri.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text('Tidak ada santri'),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filteredSantri.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final name = _filteredSantri[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                ),
                              ),
                              title: Text(name),
                              trailing: name == _selectedSantri
                                  ? const Icon(
                                      Icons.check,
                                      color: AppStyles.primaryColor,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedSantri = name;
                                  _isOverlayVisible = false;
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
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
            child: _buildInfoCard(
              'Total Tagihan',
              _amountTagihan,
              'Bayar',
              Icons.payment,
              'Riwayat Tagihan',
              () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const StandalonePembayaranPage()),
                );
              },
              () {
                // Navigate to billing history page
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
            child: _buildInfoCard(
              'Total Uang Saku',
              _amountUangSaku,
              'Top Up',
              Icons.add_circle_outline,
              'Riwayat Uang Saku',
              () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const TopUpPage()),
                );
              },
              () {
                // Navigate to pocket money history page
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
            child: _buildInfoCard(
              'Total Saldo Dompet',
              _amountDompet,
              '',
              null,
              'Riwayat Dompet',
              () {},
              () {
                // Navigate to wallet history page
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

  String _displayAmount(String amount) {
    if (_isRefreshing) {
      final dots = '.' * ((_ellipsisStep % 3) + 1);
      return 'Rp ' + dots;
    }
    return _saldoHidden ? '••••••••' : amount;
  }

  Widget _buildInfoCard(
    String title,
    String amount,
    String buttonText,
    IconData? icon,
    String historyText,
    VoidCallback onButtonPressed,
    VoidCallback onHistoryPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppStyles.saldoLabel(context)),
              GestureDetector(
                onTap: _triggerRefresh,
                child: Row(
                  children: [
                    Text(
                      'Segarkan',
                      style: AppStyles.bodyText(
                        context,
                      ).copyWith(color: AppStyles.primaryColor),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.sync,
                      color: AppStyles.primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _displayAmount(amount),
                    style: AppStyles.saldoValue(context),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _saldoHidden = !_saldoHidden;
                      });
                    },
                    child: Icon(
                      _saldoHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppStyles.lightGreyColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (buttonText.isNotEmpty)
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Column(
                    children: [
                      Icon(icon, color: AppStyles.primaryColor, size: 24),
                      const SizedBox(height: 4),
                      Text(buttonText, style: AppStyles.topUpButton(context)),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          const Divider(),
          GestureDetector(
            onTap: onHistoryPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.history,
                      color: AppStyles.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      historyText,
                      style: AppStyles.transactionHistory(context),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppStyles.primaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
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

