import 'package:flutter/material.dart';
import 'package:alhamra_1/models/berita_model.dart';
import 'package:alhamra_1/models/santri_model.dart';
import 'package:alhamra_1/providers/auth_provider.dart';
import 'package:alhamra_1/services/berita_service.dart';
import 'package:alhamra_1/services/santri_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alhamra_1/utils/app_styles.dart';
import 'package:alhamra_1/widgets/child_info_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final BeritaService _beritaService = BeritaService();
  final SantriService _santriService = SantriService();
  late Future<List<Berita>> _beritaFuture;
  ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _hasNotifications =
      true; // For demo purposes, set to true to show red indicator
  bool _santriDataInitialized = false;

  List<Santri> _santriList = [];
  Santri? _currentSantri;
  bool _isLoadingSantri = true;

  @override
  void initState() {
    super.initState();
    _beritaFuture = _beritaService.getBerita();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_santriDataInitialized) {
      _fetchSantriData();
      _santriDataInitialized = true;
    }
  }

  Future<void> _fetchSantriData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null && user.santriIds.isNotEmpty) {
      final santriList = await _santriService.getSantriByIds(user.santriIds);
      if (mounted) {
        setState(() {
          _santriList = santriList;
          if (_santriList.isNotEmpty) {
            _currentSantri = _santriList.first;
          }
          _isLoadingSantri = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingSantri = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      body: Stack(
        children: [
          // Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                collapsedHeight: 120, // Fixed height
                pinned: true,
                backgroundColor:
                    Colors.transparent, // Handled by FlexibleSpaceBar
                elevation: 0, // Handled by container shadow
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _isScrolled ? Colors.white : null,
                      gradient: _isScrolled
                          ? null
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppStyles.primaryColor.withOpacity(0.8),
                                AppStyles.secondaryColor.withOpacity(0.8),
                              ],
                            ),
                      image: _isScrolled
                          ? null
                          : const DecorationImage(
                              image: AssetImage(
                                'assets/gambar/background_beranda.png',
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.6,
                            ),
                      boxShadow: _isScrolled
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 25.0,
                          bottom: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: _isScrolled
                                  ? Colors.grey.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                color: _isScrolled
                                    ? Colors.black87
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Assalamualaikum,',
                                    style: GoogleFonts.poppins(
                                      color: _isScrolled
                                          ? Colors.black87
                                          : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    Provider.of<AuthProvider>(context)
                                            .user
                                            ?.fullName ??
                                        'Wali Santri',
                                    style: GoogleFonts.poppins(
                                      color: _isScrolled
                                          ? Colors.black87
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildNotificationIcon(isScrolled: _isScrolled),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Green Container with Saldo Card
                    _buildGreenContainer(context),

                    // Spacing between green section and menu
                    const SizedBox(height: 20),

                    // Menu Section
                    _buildMenuSection(context),

                    // Fasilitas Section
                    _buildFasilitasSection(context),

                    // Berita Section
                    _buildBeritaSection(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreenContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/gambar/background_beranda.png'),
          fit: BoxFit.cover,
          opacity: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 6.0,
          bottom: 30.0,
        ),
        child: _buildSaldoCardInGreen(context),
      ),
    );
  }

  Widget _buildSaldoCardInGreen(BuildContext context) {
    return ChildInfoCard(
      currentSantri: _currentSantri,
      allSantri: _santriList,
      onChildChanged: (newSantri) {
        setState(() {
          _currentSantri = newSantri;
        });
        print('Child changed to: ${newSantri.namaLengkap}');
      },
      onTopUp: () {
        if (_currentSantri != null) {
          print('Top Up button pressed for ${_currentSantri!.namaLengkap}');
        }
        // TODO: Navigate to top up page
      },
      onTransactionHistory: () {
        if (_currentSantri != null) {
          print(
              'Transaction history pressed for ${_currentSantri!.namaLengkap}');
        }
        // TODO: Navigate to transaction history page
      },
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {'icon': Icons.person_outline, 'label': 'Profil Santri'},
      {'icon': Icons.school_outlined, 'label': 'Info\nAkademik'},
      {'icon': Icons.check_circle_outline, 'label': 'Absensi'},
      {'icon': Icons.grade_outlined, 'label': 'Nilai\nAkademik'},
      {'icon': Icons.menu_book_outlined, 'label': 'Tahfidz\nQur\'an'},
      {'icon': Icons.record_voice_over_outlined, 'label': 'Tahsin\nQur\'an'},
      {'icon': Icons.trending_up_outlined, 'label': 'Mutabaah'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Menu',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // First row - 4 items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: menuItems.take(4).map((item) {
              return Expanded(child: _buildMenuItem(item));
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Second row - 3 items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildMenuItem(menuItems[4])),
              Expanded(child: _buildMenuItem(menuItems[5])),
              Expanded(child: _buildMenuItem(menuItems[6])),
              const Expanded(child: SizedBox()), // Empty space for alignment
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon({required bool isScrolled}) {
    return GestureDetector(
      onTap: () {
        print('Notification icon pressed');
        // Handle notification tap
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.notifications_outlined,
              color: isScrolled ? Colors.black87 : Colors.white,
              size: 24,
            ),
          ),
          // Red notification indicator
          if (_hasNotifications)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    const Color tealColor = Color(
      0xFF4DD0E1,
    ); // Teal/turquoise color from the design

    return InkWell(
      onTap: () {
        print('Menu ${item['label']} pressed');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  15,
                  215,
                  152,
                ).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  item['icon'] as IconData,
                  color: tealColor,
                  size: 27,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFasilitasSection(BuildContext context) {
    final fasilitasItems = [
      {
        'title':
            'Masjid Megal Al - Hamra, Salah satu situs peninggalan bersejarah',
        'icon': Icons.mosque,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
      {
        'title': 'Bangunan Asrama dengan fasilitas terbaik',
        'icon': Icons.apartment,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              'Fasilitas Pesantren',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: fasilitasItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return GestureDetector(
                    onTap: () {
                      print('Fasilitas ${item['title']} pressed');
                    },
                    child: Container(
                      width: 280,
                      margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Background with gradient
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppStyles.primaryColor.withOpacity(0.3),
                                    AppStyles.secondaryColor.withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                size: 80,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            // Title overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(16),
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
                                child: Text(
                                  item['title'] as String,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeritaSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seputar Al - Hamra',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  print('Lihat Semua pressed');
                },
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    color: AppStyles.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Berita>>(
            future: _beritaFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada berita.'));
              }

              final beritaItems = snapshot.data!;

              return Column(
                children: beritaItems.map((berita) {
                  return GestureDetector(
                    onTap: () {
                      print('Berita ${berita.title} pressed');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                                      .format(berita.publishedAt),
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  berita.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: berita.thumbnailUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppStyles.primaryColor.withOpacity(0.3),
                                      AppStyles.secondaryColor
                                          .withOpacity(0.5),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.article_outlined,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 24,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
