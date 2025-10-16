import '../../../features/topup/screens/topup_page.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/data/student_data.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../features/payment/screens/standalone_pembayaran_page.dart';
import '../../../features/notifications/screens/pemberitahuan_page.dart';
import '../../../core/services/notification_service.dart';
import '../../history/screens/riwayat_tagihan_page.dart';
import '../../history/screens/riwayat_uang_saku_page.dart';
import '../../history/screens/riwayat_dompet_page.dart';
import '../../shared/widgets/index.dart';
import '../../shared/widgets/student_selection_widget.dart';
import '../../news/screens/news_list_screen.dart';
import '../../news/screens/news_detail_screen.dart';
import '../../../core/services/news_service.dart';
import '../../../core/models/article_model.dart';
import '../../menu/screens/info_akademik_page.dart';
import '../../menu/screens/absensi_page.dart';
import '../../menu/screens/nilai_page.dart';
import '../../menu/screens/tahfidz_page.dart';
import '../../menu/screens/tahsin_page.dart';
import '../../menu/screens/mutabaah_page.dart';
import '../../menu/screens/perizinan_page.dart';
import '../../menu/screens/profile_santri.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  // News data
  List<Article> _newsArticles = [];
  bool _isLoadingNews = false;
  final NewsService _newsService = NewsService();
  
  // Facilities data (using news articles)
  List<Article> _facilitiesArticles = [];
  bool _isLoadingFacilities = false;
  
  // Pull to refresh
  bool _isRefreshingAll = false;

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
    _loadNews();
    _loadFacilities();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoadingNews = true;
    });
    
    try {
      final articles = await _newsService.getNews(pageSize: 3).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // Return sample data on timeout
          return _newsService.getSampleNews().take(3).toList();
        },
      );
      setState(() {
        _newsArticles = articles;
        _isLoadingNews = false;
      });
    } catch (e) {
      print('Error loading news: $e');
      // Fallback to sample data
      setState(() {
        _newsArticles = _newsService.getSampleNews().take(3).toList();
        _isLoadingNews = false;
      });
    }
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _isLoadingFacilities = true;
    });
    
    try {
      final articles = await _newsService.getNews(pageSize: 6).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return _newsService.getSampleNews().take(6).toList();
        },
      );
      setState(() {
        _facilitiesArticles = articles;
        _isLoadingFacilities = false;
      });
    } catch (e) {
      print('Error loading facilities: $e');
      setState(() {
        _facilitiesArticles = _newsService.getSampleNews().take(6).toList();
        _isLoadingFacilities = false;
      });
    }
  }

  Future<void> _refreshAllData() async {
    setState(() {
      _isRefreshingAll = true;
    });
    
    try {
      // Reload both news and facilities data
      await Future.wait([
        _loadNews(),
        _loadFacilities(),
      ]);
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      setState(() {
        _isRefreshingAll = false;
      });
    }
  }

  String _getTimeAgo(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
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
                        AppLocalizations.of(context).assalamualaikum,
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
            RefreshIndicator(
              onRefresh: _refreshAllData,
              color: AppStyles.primaryColor,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
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

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppStyles.menuLabel(context).copyWith(
              fontSize: 11, 
              color: Colors.black87, 
              fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
            AppLocalizations.of(context).pilihSantri,
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
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
            children: [
              // Profil Santri
              _buildMenuItem(
                context,
                icon: Icons.person,
                label: 'Profil Santri',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const ProfileSantriPage()),
                  );
                },
              ),
              
              // Info Akademik
              _buildMenuItem(
                context,
                icon: Icons.wifi_tethering,
                label: 'Info Akademik',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const InfoAkademikPage()),
                  );
                },
              ),
              
              // Absensi
              _buildMenuItem(
                context,
                icon: Icons.check_box,
                label: 'Absensi',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const AbsensiPage()),
                  );
                },
              ),
              
              // Nilai Akademik
              _buildMenuItem(
                context,
                icon: Icons.edit_note,
                label: 'Nilai Akademik',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const NilaiPage()),
                  );
                },
              ),
              
              // Tahfidz Qur'an
              _buildMenuItem(
                context,
                icon: Icons.menu_book,
                label: 'Tahfidz Qur\'an',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const TahfidzPage()),
                  );
                },
              ),
              
              // Tahsin
              _buildMenuItem(
                context,
                icon: Icons.g_translate,
                label: 'Tahsin',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const TahsinPage()),
                  );
                },
              ),
              
              // Mutabaah
              _buildMenuItem(
                context,
                icon: Icons.hiking,
                label: 'Mutabaah',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const MutabaahPage()),
                  );
                },
              ),
              
              // Formulir Perijinan
              _buildMenuItem(
                context,
                icon: Icons.description,
                label: 'Formulir Perijinan',
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const PerizinanPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).fasilitas,
            style: AppStyles.bodyText(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _isLoadingFacilities
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppStyles.primaryColor,
                    ),
                  ),
                )
              : SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (_facilitiesArticles.length > 5 ? 5 : _facilitiesArticles.length) + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      // Show "Lihat Semua" as the last item
                      if (index == (_facilitiesArticles.length > 5 ? 5 : _facilitiesArticles.length)) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (context) => const NewsListScreen()),
                            );
                          },
                          child: Container(
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppStyles.primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppStyles.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppStyles.primaryColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context).lihatSemua,
                                  style: AppStyles.bodyText(context).copyWith(
                                    color: AppStyles.primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context).berita,
                                  style: AppStyles.bodyText(context).copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      // Show regular facility articles
                      final article = _facilitiesArticles[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(article: article),
                            ),
                          );
                        },
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                // Background Image
                                Positioned.fill(
                                  child: _buildFacilityImageWidget(article.urlToImage),
                                ),
                                // Gradient Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Content
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Text(
                                    article.title,
                                    style: AppStyles.bodyText(context).copyWith(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).berita,
                style: AppStyles.bodyText(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const NewsListScreen()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context).lihatSemua,
                  style: AppStyles.bodyText(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppStyles.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _isLoadingNews
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppStyles.primaryColor,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _newsArticles.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, i) {
                    final article = _newsArticles[i];
                    final timeAgo = _getTimeAgo(article.publishedAt);
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildNewsImageWidget(article.urlToImage),
                      ),
                      title: Text(
                        article.title,
                        style: AppStyles.bodyText(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            article.description,
                            style: AppStyles.bodyText(context).copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeAgo,
                            style: AppStyles.bodyText(context).copyWith(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppStyles.primaryColor,
                      ),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(article: article),
                          ),
                        );
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNewsImageWidget(String imageUrl) {
    // Check if URL is valid and not SVG
    if (imageUrl.isEmpty || imageUrl.endsWith('.svg') || imageUrl.contains('svg')) {
      return _buildNewsPlaceholderImage();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildNewsPlaceholderImage(),
      errorWidget: (context, url, error) => _buildNewsPlaceholderImage(),
    );
  }

  Widget _buildNewsPlaceholderImage() {
    return Container(
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
    );
  }

  Widget _buildFacilityImageWidget(String imageUrl) {
    // Check if URL is valid and not SVG
    if (imageUrl.isEmpty || imageUrl.endsWith('.svg') || imageUrl.contains('svg')) {
      return _buildFacilityPlaceholderImage();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildFacilityPlaceholderImage(),
      errorWidget: (context, url, error) => _buildFacilityPlaceholderImage(),
    );
  }

  Widget _buildFacilityPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppStyles.primaryColor.withOpacity(0.8),
            AppStyles.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.location_city,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
