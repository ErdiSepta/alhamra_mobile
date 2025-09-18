import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/data/student_data.dart';
import '../../../core/models/bill.dart';
import '../../shared/widgets/index.dart';
import '../../shared/widgets/history_filter_widget.dart';
import '../../shared/widgets/student_selection_widget.dart';
import 'custom_status_menunggu_page.dart';
import 'status_berhasil_page.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key, this.initialTabIndex = 0});
  
  final int initialTabIndex;

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _listController = ScrollController();
  String _selectedStudent = StudentData.defaultStudent;
  final List<String> _students = StudentData.allStudents;
  bool _isStudentOverlayVisible = false;
  
  // Filter state variables
  String _selectedSortOrder = 'Terbaru';
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Payment type filters
  final Map<String, bool> _paymentTypeFilters = {
    'SPP': true,
    'Uang Tahunan': true,
    'Seragam': true,
    'Uang Pembangunan': true,
    'Uang Sumbangan': true,
  };

  // Sample payment data
  final List<PaymentItem> _allPayments = [
    PaymentItem(
      id: 'INV/083/329382',
      type: 'Uang Tahunan',
      studentName: 'Naufal Ramadhan',
      amount: 2500000,
      dueDate: DateTime(2026, 1, 30),
      status: PaymentStatus.lunas,
    ),
    PaymentItem(
      id: 'INV/083/329383',
      type: 'SPP Santri',
      studentName: 'Naufal Ramadhan',
      amount: 2500000,
      dueDate: DateTime(2026, 1, 30),
      status: PaymentStatus.belumLunas,
    ),
    PaymentItem(
      id: 'INV/083/329384',
      type: 'SPP Santri',
      studentName: 'Naufal Ramadhan',
      amount: 2500000,
      dueDate: DateTime(2026, 1, 30),
      status: PaymentStatus.sebagian,
    ),
    PaymentItem(
      id: 'INV/083/329385',
      type: 'Uang Tahunan',
      studentName: 'Naufal Ramadhan',
      amount: 2500000,
      dueDate: DateTime(2026, 1, 30),
      status: PaymentStatus.lunas,
    ),
    // Payments for second student to demonstrate switching
    PaymentItem(
      id: 'INV/083/329386',
      type: 'Seragam',
      studentName: 'Aisyah Zahra',
      amount: 420000,
      dueDate: DateTime(2026, 2, 15),
      status: PaymentStatus.belumLunas,
    ),
    PaymentItem(
      id: 'INV/083/329387',
      type: 'SPP Santri',
      studentName: 'Aisyah Zahra',
      amount: 350000,
      dueDate: DateTime(2026, 2, 10),
      status: PaymentStatus.sebagian,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        _scrollListToTop();
      }
    });
  }

  void _onStudentChanged(String student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listController.dispose();
    super.dispose();
  }

  List<PaymentItem> _getFilteredPayments() {
    List<PaymentItem> filtered = _allPayments;
    // Filter by selected student
    filtered = filtered.where((p) => p.studentName == _selectedStudent).toList();
    
    // Filter by tab
    final currentTab = _tabController.index;
    if (currentTab == 1) { // Menunggu - only yellow cards (belumLunas/sebagian)
      filtered = filtered.where((p) => p.status == PaymentStatus.belumLunas || p.status == PaymentStatus.sebagian).toList();
    } else if (currentTab == 2) { // Terkonfirmasi - only green cards (lunas)
      filtered = filtered.where((p) => p.status == PaymentStatus.lunas).toList();
    }
    
    // Filter by payment types
    filtered = filtered.where((payment) {
      // If no payment types are selected, show nothing
      if (!_paymentTypeFilters.values.any((selected) => selected)) {
        return false;
      }
      
      // Check if payment type matches any selected filter
      final paymentType = payment.type.toLowerCase();
      
      return _paymentTypeFilters.entries.any((entry) {
        if (!entry.value) return false; // Skip unselected types
        
        final filterType = entry.key.toLowerCase();
        
        // Direct matching and specific cases
        return paymentType.contains(filterType) ||
               paymentType.contains(filterType.replaceAll(' ', '')) ||
               (filterType == 'spp' && paymentType.contains('spp')) ||
               (filterType == 'uang tahunan' && (paymentType.contains('tahunan') || paymentType.contains('uang tahunan'))) ||
               (filterType == 'seragam' && paymentType.contains('seragam')) ||
               (filterType == 'uang pembangunan' && (paymentType.contains('pembangunan') || paymentType.contains('uang pembangunan'))) ||
               (filterType == 'uang sumbangan' && (paymentType.contains('sumbangan') || paymentType.contains('uang sumbangan')));
      });
    }).toList();
    
    // Filter by date range
    if (_startDate != null && _endDate != null) {
      filtered = filtered.where((payment) {
        return payment.dueDate.isAfter(_startDate!) && payment.dueDate.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }
    
    // Sort by order
    if (_selectedSortOrder == 'Terbaru') {
      filtered.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    } else {
      filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Blue gradient header section
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
                  child: Column(
                    children: [
                      _buildTabBar(),
                      _buildFilterSection(),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF5F7FA),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildPaymentList(), // Semua
                              _buildPaymentList(), // Menunggu
                              _buildPaymentList(), // Terkonfirmasi
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add overlay at the top level to ensure it appears above all content
          if (_isStudentOverlayVisible)
            SearchOverlayWidget(
              isVisible: _isStudentOverlayVisible,
              title: 'Pilih Santri',
              items: _students,
              selectedItem: _selectedStudent,
              onItemSelected: (student) {
                setState(() {
                  _selectedStudent = student;
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pembayaran', style: AppStyles.heading1(context)),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    return StudentSelectionWidget(
      selectedStudent: _selectedStudent,
      students: _students,
      onStudentChanged: _onStudentChanged,
      onOverlayVisibilityChanged: (visible) {
        setState(() {
          _isStudentOverlayVisible = visible;
        });
      },
      avatarUrl: StudentData.defaultAvatarUrl,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppStyles.primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppStyles.primaryColor,
        indicatorWeight: 2,
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
        onTap: (index) {
          _scrollListToTop();
          setState(() {});
        },
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Menunggu'),
          Tab(text: 'Terkonfirmasi'),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left area: sort chips (always visible) + active filter chips (if any)
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 4,
              spacing: 4,
              children: [
                ..._buildSortChips(),
                if (_hasActiveFilters) _buildActiveFilters(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Filter button (right)
          GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppStyles.getButtonBorderRadius(context) / 2),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter',
                    style: AppStyles.bodyText(context).copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: AppStyles.primaryColor),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.tune,
                    size: 14,
                    color: AppStyles.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasActiveFilters {
    final hasDate = _startDate != null && _endDate != null;
    final selectedTypes = _paymentTypeFilters.entries.where((e) => e.value).length;
    final hasTypeSelection = selectedTypes > 0 && selectedTypes < _paymentTypeFilters.length;
    return hasDate || hasTypeSelection;
  }

  List<Widget> _buildSortChips() {
    final isTerbaru = _selectedSortOrder == 'Terbaru';
    final chipStyle = AppStyles.bodyText(context).copyWith(fontSize: 11);
    return [
      ChoiceChip(
        label: Text('Terbaru', style: chipStyle),
        selected: isTerbaru,
        onSelected: (v) {
          if (!isTerbaru) {
            setState(() => _selectedSortOrder = 'Terbaru');
          }
        },
        selectedColor: AppStyles.primaryColor.withOpacity(0.15),
        side: BorderSide(color: isTerbaru ? AppStyles.primaryColor : Colors.grey.shade300),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        labelStyle: chipStyle.copyWith(
          color: isTerbaru ? AppStyles.primaryColor : Colors.black87,
          fontWeight: isTerbaru ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      ChoiceChip(
        label: Text('Terlama', style: chipStyle),
        selected: !isTerbaru,
        onSelected: (v) {
          if (isTerbaru) {
            setState(() => _selectedSortOrder = 'Terlama');
          }
        },
        selectedColor: AppStyles.primaryColor.withOpacity(0.15),
        side: BorderSide(color: !isTerbaru ? AppStyles.primaryColor : Colors.grey.shade300),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        labelStyle: chipStyle.copyWith(
          color: !isTerbaru ? AppStyles.primaryColor : Colors.black87,
          fontWeight: !isTerbaru ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    ];
  }

  Widget _buildActiveFilters() {
    final chips = <Widget>[];

    // Payment type chips (show only when not all are selected)
    final allCount = _paymentTypeFilters.length;
    final selectedEntries = _paymentTypeFilters.entries.where((e) => e.value).toList();
    if (selectedEntries.isNotEmpty && selectedEntries.length < allCount) {
      for (final entry in selectedEntries) {
        chips.add(Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: InputChip(
            label: Text(entry.key, style: AppStyles.bodyText(context).copyWith(fontSize: 11)),
            labelPadding: const EdgeInsets.symmetric(horizontal: 6),
            onDeleted: () {
              setState(() {
                _paymentTypeFilters[entry.key] = false;
              });
            },
            deleteIcon: const Icon(Icons.close, size: 14),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ));
      }
    }

    // Date range chip
    if (_startDate != null && _endDate != null) {
      final label = '${_formatDateDisplay(_startDate!)} - ${_formatDateDisplay(_endDate!)}';
      chips.add(Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 4),
        child: InputChip(
          avatar: const Icon(Icons.date_range, size: 14),
          label: Text(label, style: AppStyles.bodyText(context).copyWith(fontSize: 11)),
          labelPadding: const EdgeInsets.symmetric(horizontal: 6),
          onDeleted: () {
            setState(() {
              _startDate = null;
              _endDate = null;
            });
          },
          deleteIcon: const Icon(Icons.close, size: 14),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ));
    }

    // Sort order chip (only when not default)
    if (_selectedSortOrder != 'Terbaru') {
      chips.add(Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 4),
        child: InputChip(
          avatar: const Icon(Icons.sort, size: 14),
          label: Text('Urut: $_selectedSortOrder', style: AppStyles.bodyText(context).copyWith(fontSize: 11)),
          labelPadding: const EdgeInsets.symmetric(horizontal: 6),
          onDeleted: () {
            setState(() {
              _selectedSortOrder = 'Terbaru';
            });
          },
          deleteIcon: const Icon(Icons.close, size: 14),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ));
    }

    // Clear all chip
    chips.add(Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 4),
      child: ActionChip(
        avatar: const Icon(Icons.clear_all, size: 14),
        label: Text('Hapus semua', style: AppStyles.bodyText(context).copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        onPressed: () {
          setState(() {
            _selectedSortOrder = 'Terbaru';
            _startDate = null;
            _endDate = null;
            _paymentTypeFilters.updateAll((key, value) => true);
          });
        },
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey[300]!),
      ),
    ));

    return Wrap(children: chips);
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // ensure it overlays bottom navbar
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HistoryFilterWidget(
        title: 'Filter Pembayaran',
        selectedSortOrder: _selectedSortOrder,
        startDate: _startDate,
        endDate: _endDate,
        categoryFilters: Map.from(_paymentTypeFilters),
        availableCategories: _paymentTypeFilters.keys.toList(),
        onSortOrderChanged: (v) => _selectedSortOrder = v,
        onStartDateChanged: (d) => _startDate = d,
        onEndDateChanged: (d) => _endDate = d,
        onCategoryFiltersChanged: (map) => _paymentTypeFilters
          ..clear()
          ..addAll(map),
        onApply: () {
          setState(() {});
          _scrollListToTop();
        },
        onReset: () {
          setState(() {
            _selectedSortOrder = 'Terbaru';
            _startDate = null;
            _endDate = null;
            _paymentTypeFilters.updateAll((key, value) => true);
          });
        },
      ),
    );
  }

  Widget _buildSortButton(String label, StateSetter setModalState) {
    final isSelected = _selectedSortOrder == label;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedSortOrder = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppStyles.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
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
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? _formatDateDisplay(date) : 'Pilih tanggal',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: date != null ? Colors.black87 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildPaymentList() {
    final filteredPayments = _getFilteredPayments();
    
    if (filteredPayments.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      controller: _listController,
      itemCount: filteredPayments.length,
      itemBuilder: (context, index) {
        final payment = filteredPayments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  void _scrollListToTop() {
    if (_listController.hasClients) {
      _listController.animateTo(0,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  Widget _buildEmptyState() {
    return CustomEmptyStateWidget(
      icon: Icons.payment_outlined,
      title: 'Tidak ada pembayaran',
      subtitle: 'Coba ubah filter atau pilih tab lain',
    );
  }

  Widget _buildPaymentCard(PaymentItem payment) {
    Color cardColor;
    Color statusColor;
    String statusText;
    
    switch (payment.status) {
      case PaymentStatus.lunas:
        cardColor = const Color(0xFF00C896); // Green for lunas
        statusColor = const Color(0xFF00A67E);
        statusText = 'Lunas';
        break;
      case PaymentStatus.belumLunas:
      case PaymentStatus.sebagian:
        cardColor = const Color(0xFFFFC107); // Yellow for menunggu (both belumLunas and sebagian)
        statusColor = const Color(0xFFFF8F00);
        statusText = payment.status == PaymentStatus.belumLunas ? 'Belum Lunas' : 'Terbayar Sebagian';
        break;
    }
    
    final radius = AppStyles.getCardBorderRadius(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          // Header with payment type
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
            ),
            child: Text(
              payment.type,
              style: AppStyles.sectionTitle(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          // Content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Invoice', style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          payment.id,
                          style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: AppStyles.bodyText(context).copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: statusColor),
                      ),
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
                        Text('Nama Santri', style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          payment.studentName,
                          style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          payment.status == PaymentStatus.lunas ? 'Dikonfirmasi' : 'Tenggat Bayar',
                          style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 12),
                        ),
                        Text(
                          _formatDate(payment.dueDate),
                          style: AppStyles.bodyText(context).copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                      ],
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
                        Text('Nominal Bayar', style: AppStyles.bodyText(context).copyWith(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          _formatCurrency(payment.amount),
                          style: AppStyles.saldoValue(context).copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to appropriate detail page based on payment status
                        if (payment.status == PaymentStatus.lunas) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => StatusBerhasilPage(amount: payment.amount),
                              fullscreenDialog: true,
                            ),
                          );
                        } else {
                          // For belumLunas and sebagian (menunggu status)
                          // Create PaymentData for CustomStatusMenungguPage
                          final paymentData = PaymentData(
                            bills: [
                              Bill(
                                id: payment.id,
                                title: payment.type,
                                subtitle: 'Pembayaran ${payment.type}',
                                amount: payment.amount,
                                dueDate: payment.dueDate,
                                status: payment.status == PaymentStatus.belumLunas ? BillStatus.unpaid : BillStatus.partial,
                                period: '${payment.dueDate.month}/${payment.dueDate.year}',
                              ),
                            ],
                            studentName: payment.studentName,
                            paymentMethod: 'Transfer Bank',
                            virtualAccount: '1234567890123456',
                            totalAmount: payment.amount,
                            paymentDate: DateTime.now(),
                            invoiceId: payment.id,
                            senderName: 'Muhammad Faithfullah Ilhamy Azda',
                            administrator: 'Diah Al Quwari',
                          );
                          
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CustomStatusMenungguPage(paymentData: paymentData),
                              fullscreenDialog: true,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppStyles.getButtonBorderRadius(context) / 2),
                        ),
                      ),
                      child: Text(
                        'Lihat Detail',
                        style: AppStyles.bodyText(context).copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatCurrency(int amount) {
    return 'Rp. ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}

class PaymentItem {
  final String id;
  final String type;
  final String studentName;
  final int amount;
  final DateTime dueDate;
  final PaymentStatus status;

  PaymentItem({
    required this.id,
    required this.type,
    required this.studentName,
    required this.amount,
    required this.dueDate,
    required this.status,
  });
}

enum PaymentStatus {
  belumLunas,
  sebagian,
  lunas,
}
