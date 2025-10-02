import 'package:alhamra_1/features/shared/widgets/student_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../core/data/student_data.dart';
import '../../../core/models/aktivitas_model.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/localization/app_localizations.dart';
import '../../shared/widgets/index.dart';
import 'aktivitas_list_kesehatan.dart';
import 'aktivitas_list_perizinan.dart';
import 'aktivitas_list_pelanggaran.dart';
import 'aktivitas_list_all.dart';
import '../widgets/aktivitas_category_filter.dart';
import 'aktivitas_detail_page.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> with TickerProviderStateMixin {
  // --- State Management ---
  late Map<String, StudentAktivitasProfile> _allAktivitasData;
  late StudentAktivitasProfile _selectedProfile;
  String _selectedStudentName = StudentData.defaultStudent;
  bool _isStudentOverlayVisible = false;
  late List<AktivitasEntry> _filteredEntries;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String? _lastLocale;
  // --- Filter State ---
  String _selectedSortOrder = 'Terbaru';
  AktivitasType? _selectedTypeFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _generateMockData();
    _selectedProfile = _allAktivitasData[_selectedStudentName]!;
    _filteredEntries = _selectedProfile.entries;

    final categories = [null, ...AktivitasType.values];
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTypeFilter = categories[_tabController.index];
          _filterAktivitasEntries();
        });
      }
    });
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    // Use static data for initial load to avoid context issues
    _allAktivitasData = {
      for (var student in StudentData.allStudents)
        student: StudentAktivitasProfile.createMock(
            (StudentData.allStudents.indexOf(student) + 1).toString())
    };
  }
  
  void _regenerateMockDataWithLocalization() {
    // This method can be called after context is available
    _allAktivitasData = {
      for (var student in StudentData.allStudents)
        student: _createMockProfile(
            (StudentData.allStudents.indexOf(student) + 1).toString())
    };
  }
  
  StudentAktivitasProfile _createMockProfile(String studentId) {
    final localizations = AppLocalizations.of(context);
    final random = Random(int.parse(studentId));
    final now = DateTime.now();
    final List<AktivitasEntry> mockEntries = [];

    final List<String> pelanggaranJudul = [
      localizations.terlambatApel,
      localizations.tidakSeragam,
      localizations.meninggalkanKelas,
      localizations.keributan,
    ];
    final List<String> perizinanJudul = [
      localizations.izinPulang,
      localizations.izinSakit,
      localizations.izinKeluar,
    ];
    final List<String> kesehatanJudul = [
      localizations.pemeriksaanRutin,
      localizations.sakitDemam,
      localizations.konsultasiKesehatan,
    ];
    final List<String> pencatat = ['Ustadz Ahmad', 'Ustadzah Fatimah', 'Tim Kesehatan'];

    for (int i = 0; i < 15; i++) {
      final type = AktivitasType.values[random.nextInt(AktivitasType.values.length)];
      String judul;
      String keterangan;

      switch (type) {
        case AktivitasType.pelanggaran:
          judul = pelanggaranJudul[random.nextInt(pelanggaranJudul.length)];
          keterangan = 'Santri telah diberi teguran dan pembinaan oleh ${pencatat[random.nextInt(2)]}.';
          break;
        case AktivitasType.perizinan:
          judul = perizinanJudul[random.nextInt(perizinanJudul.length)];
          keterangan = 'Telah mendapat izin dari wali asrama dan akan kembali pada waktu yang ditentukan.';
          break;
        case AktivitasType.kesehatan:
          judul = kesehatanJudul[random.nextInt(kesehatanJudul.length)];
          keterangan = 'Telah diperiksa oleh tim kesehatan dan diberikan obat. Disarankan untuk istirahat.';
          break;
      }

      mockEntries.add(
        AktivitasEntry(
          id: 'AKT-${studentId.padLeft(3, '0')}-${i.toString().padLeft(3, '0')}',
          judul: judul,
          keterangan: keterangan,
          pencatat: pencatat[random.nextInt(pencatat.length)],
          tanggal: now.subtract(Duration(days: random.nextInt(60), hours: random.nextInt(24))),
          tipe: type,
        ),
      );
    }

    // Sort entries by date descending
    mockEntries.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return StudentAktivitasProfile(
      studentId: studentId,
      entries: mockEntries,
    );
  }

  void _updateSelectedData() {
    setState(() {
      _selectedProfile = _allAktivitasData[_selectedStudentName]!;
      // Reset filters and search when student changes
      _searchController.clear();
      _selectedSortOrder = 'Terbaru';
      _selectedTypeFilter = null;
      _startDate = null;
      _endDate = null;
      _filterAktivitasEntries(); // Apply reset filters
    });
  }

  void _filterAktivitasEntries() {
    final query = _searchController.text.toLowerCase();
    var filtered = _selectedProfile.entries.where((entry) {
      final searchMatch = entry.judul.toLowerCase().contains(query);
      final typeMatch =
          _selectedTypeFilter == null || entry.tipe == _selectedTypeFilter;

      // Normalize dates to ignore time component for correct comparison
      final entryDate =
          DateTime(entry.tanggal.year, entry.tanggal.month, entry.tanggal.day);
      final startDate = _startDate != null
          ? DateTime(_startDate!.year, _startDate!.month, _startDate!.day)
          : null;
      final endDate = _endDate != null
          ? DateTime(_endDate!.year, _endDate!.month, _endDate!.day)
          : null;

      final isAfterStartDate =
          startDate == null || !entryDate.isBefore(startDate);
      final isBeforeEndDate = endDate == null || !entryDate.isAfter(endDate);

      return searchMatch && typeMatch && isAfterStartDate && isBeforeEndDate;
    }).toList();

    // Sorting
    filtered.sort((a, b) {
      return _selectedSortOrder == 'Terbaru'
          ? b.tanggal.compareTo(a.tanggal)
          : a.tanggal.compareTo(b.tanggal);
    });

    setState(() {
      _filteredEntries = filtered;
    });
  }

  // --- UI Builders ---
  @override
  Widget build(BuildContext context) {
    // Regenerate mock data only when locale changes
    final currentLocale = Localizations.localeOf(context).toString();
    if (_lastLocale != currentLocale) {
      _regenerateMockDataWithLocalization();
      _selectedProfile = _allAktivitasData[_selectedStudentName]!;
      _lastLocale = currentLocale;
    }
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
              // White content section
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _buildAktivitasDetails(),
                ),
              ),
            ],
          ),
          if (_isStudentOverlayVisible)
            SearchOverlayWidget(
              isVisible: _isStudentOverlayVisible,
              title: AppLocalizations.of(context).pilihSantri,
              items: StudentData.allStudents,
              selectedItem: _selectedStudentName,
              onItemSelected: (nama) {
                setState(() {
                  _selectedStudentName = nama;
                  _updateSelectedData();
                  _isStudentOverlayVisible = false;
                });
              },
              onClose: () => setState(() => _isStudentOverlayVisible = false),
              searchHint: AppLocalizations.of(context).cariSantri,
              avatarUrl: StudentData.getStudentAvatar(_selectedStudentName),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).aktivitas, style: AppStyles.heading1(context)),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: StudentSelectionWidget(
        selectedStudent: _selectedStudentName,
        students: StudentData.allStudents,
        onStudentChanged: (nama) {
          setState(() {
            _selectedStudentName = nama;
            _updateSelectedData();
          });
        },
        onOverlayVisibilityChanged: (visible) =>
            setState(() => _isStudentOverlayVisible = visible),
        avatarUrl: StudentData.getStudentAvatar(_selectedStudentName),
      ),
    );
  }

  Widget _buildAktivitasDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AktivitasCategoryFilter(
          categories: const [null, ...AktivitasType.values],
          tabController: _tabController,
          onCategorySelected: (category) {
            // Logika sudah ditangani oleh listener TabController
            // _tabController.animateTo([null, ...AktivitasType.values].indexOf(category));
          },
        ),
        _buildFilterSection(),
        Expanded(
          child: Container(
            color: const Color(0xFFF5F7FA),
            child: TabBarView(
  controller: _tabController,
  children: [
    AktivitasListAll(entries: _selectedProfile.entries, studentName: _selectedStudentName),
    AktivitasListPelanggaran(entries: _selectedProfile.entries, studentName: _selectedStudentName),
    AktivitasListPerizinan(entries: _selectedProfile.entries, studentName: _selectedStudentName),
    AktivitasListKesehatan(entries: _selectedProfile.entries, studentName: _selectedStudentName),
  ],
)


          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    // Hanya tampilkan filter jika tab bukan "Semua"
    if (_selectedTypeFilter == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedSortOrder,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).filter,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppStyles.primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.tune,
                  size: 18,
                  color: AppStyles.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasList() {
    return _filteredEntries.isEmpty
        ? Center(
            child: Text(AppLocalizations.of(context).tidakAdaData,
                style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: _filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = _filteredEntries[index];
              return _buildAktivitasCard(entry);
            },
          );
  }

  Widget _buildSearchAndFilter() {
    // Logika filter kategori sekarang dipindahkan ke _buildAktivitasDetails
    // untuk penataan layout yang lebih baik.
    return const SizedBox.shrink();
  }

  Widget _buildAktivitasCard(AktivitasEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Kategori
          Text(
            "${AppLocalizations.of(context).status} ${_getLabelForCategory(entry.tipe)}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Divider(height: 24),

          // Isi Data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Santri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).pilihSantri, style: TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      _selectedStudentName,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Tanggal
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context).tanggal, style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM yyyy', 'id_ID').format(entry.tanggal),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Judul Aktivitas
          Text(AppLocalizations.of(context).aktivitas, style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            entry.judul,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),

          const SizedBox(height: 16),

          // Tombol Detail
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => AktivitasDetailPage(
                        entry: entry, studentName: _selectedStudentName),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context).lihatDetail),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    // Temporary state for the bottom sheet
    String tempSortOrder = _selectedSortOrder;
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${AppLocalizations.of(context).filter} ${AppLocalizations.of(context).aktivitas}', style: AppStyles.heading2(context)),
                  const SizedBox(height: 24),
                  Text(AppLocalizations.of(context).urutkanBerdasarkan,
                      style: AppStyles.bodyText(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildSortButton(
                              AppLocalizations.of(context).terbaru, tempSortOrder == 'Terbaru',
                              () => setModalState(() => tempSortOrder = 'Terbaru'))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildSortButton(
                              AppLocalizations.of(context).terlama, tempSortOrder == 'Terlama',
                              () => setModalState(() => tempSortOrder = 'Terlama'))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePicker(AppLocalizations.of(context).dari, tempStartDate,
                            (date) => setModalState(() => tempStartDate = date),
                            onClear: () =>
                                setModalState(() => tempStartDate = null)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDatePicker(AppLocalizations.of(context).ke, tempEndDate,
                            (date) => setModalState(() => tempEndDate = date),
                            onClear: () =>
                                setModalState(() => tempEndDate = null)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempSortOrder = 'Terbaru';
                              tempStartDate = null;
                              tempEndDate = null;
                            });
                          },
                          child: Text(AppLocalizations.of(context).refresh),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedSortOrder = tempSortOrder;
                              _startDate = tempStartDate;
                              _endDate = tempEndDate;
                              _filterAktivitasEntries();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context).save),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortButton(String label, bool isSelected, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? AppStyles.primaryColor.withOpacity(0.1) : Colors.transparent,
        side: BorderSide(
            color: isSelected ? AppStyles.primaryColor : Colors.grey.shade300),
      ),
      child: Text(label,
          style:
              TextStyle(color: isSelected ? AppStyles.primaryColor : Colors.black87)),
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate,
      Function(DateTime) onDateSelected, {VoidCallback? onClear}) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
          locale: const Locale('id', 'ID'),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppStyles.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.calendar_today,
                  size: 18, color: AppStyles.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.bodyText(context).copyWith(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedDate != null
                        ? DateFormat('d MMM yyyy', 'id_ID').format(selectedDate)
                        : AppLocalizations.of(context).tanggal,
                    style: AppStyles.bodyText(context).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (selectedDate != null && onClear != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.close, size: 16, color: Colors.black54),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColorForType(AktivitasType type) {
    switch (type) {
      case AktivitasType.pelanggaran:
        return Colors.red.shade600;
      case AktivitasType.perizinan:
        return Colors.orange.shade700;
      case AktivitasType.kesehatan:
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(AktivitasType type) {
    switch (type) {
      case AktivitasType.pelanggaran:
        return Icons.gavel;
      case AktivitasType.perizinan:
        return Icons.assignment_turned_in_outlined;
      case AktivitasType.kesehatan:
        return Icons.local_hospital_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getLabelForCategory(AktivitasType? type) {
    if (type == null) {
      return AppLocalizations.of(context).semua;
    }
    
    switch (type) {
      case AktivitasType.pelanggaran:
        return AppLocalizations.of(context).pelanggaran;
      case AktivitasType.perizinan:
        return AppLocalizations.of(context).perizinan;
      case AktivitasType.kesehatan:
        return AppLocalizations.of(context).kesehatan;
    }
  }
}