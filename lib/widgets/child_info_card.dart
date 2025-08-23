import 'package:flutter/material.dart';
import 'package:alhamra_1/models/santri_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alhamra_1/utils/app_styles.dart';

class ChildInfoCard extends StatefulWidget {
  final Santri? currentSantri;
  final List<Santri> allSantri;
  final Function(Santri) onChildChanged;
  final VoidCallback onTopUp;
  final VoidCallback onTransactionHistory;

  const ChildInfoCard({
    Key? key,
    required this.currentSantri,
    required this.allSantri,
    required this.onChildChanged,
    required this.onTopUp,
    required this.onTransactionHistory,
  }) : super(key: key);

  @override
  State<ChildInfoCard> createState() => _ChildInfoCardState();
}

class _ChildInfoCardState extends State<ChildInfoCard> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    if (widget.currentSantri == null) {
      // Show a loading state or an empty placeholder card
      return Container(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Section
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                // backgroundImage: widget.currentSantri!.fotoUrl != null
                //     ? NetworkImage(widget.currentSantri!.fotoUrl!)
                //     : null,
                child: widget.currentSantri!.fotoUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppStyles.primaryColor,
                        size: 20,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.currentSantri!.namaLengkap,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _showChildSelectionModal(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ganti',
                      style: GoogleFonts.poppins(
                        color: AppStyles.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.swap_horiz,
                      color: AppStyles.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Saldo Section
          Text(
            'Saldo Uang Saku',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),

          const SizedBox(height: 2),

          // Saldo dan Toggle
          Row(
            children: [
              Text(
                _isBalanceVisible
                    ? 'Rp 150.000' // Placeholder for saldo
                    : 'Rp ••••••••••',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              // Toggle Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                  print('Toggle balance visibility');
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppStyles.primaryColor,
                    size: 22,
                  ),
                ),
              ),
              const Spacer(),
              // Top Up Button
              GestureDetector(
                onTap: widget.onTopUp,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppStyles.primaryColor,
                            width: 2.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppStyles.primaryColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Top Up',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(thickness: 0.5, height: 1),
          const SizedBox(height: 10),

          // Riwayat Section
          GestureDetector(
            onTap: widget.onTransactionHistory,
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: AppStyles.primaryColor,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  'Riwayat Transaksi',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(num amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showChildSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChildSelectionModal(
        currentSantri: widget.currentSantri!,
        allSantri: widget.allSantri,
        onChildSelected: (santri) {
          widget.onChildChanged(santri);
        },
      ),
    );
  }
}

// Child Selection Modal Widget
class ChildSelectionModal extends StatefulWidget {
  final Santri currentSantri;
  final List<Santri> allSantri;
  final Function(Santri) onChildSelected;

  const ChildSelectionModal({
    Key? key,
    required this.currentSantri,
    required this.allSantri,
    required this.onChildSelected,
  }) : super(key: key);

  @override
  State<ChildSelectionModal> createState() => _ChildSelectionModalState();
}

class _ChildSelectionModalState extends State<ChildSelectionModal> {
  final TextEditingController _searchController = TextEditingController();

  List<Santri> _filteredChildren = [];

  @override
  void initState() {
    super.initState();
    _filteredChildren = List.from(widget.allSantri);
    _searchController.addListener(_filterChildren);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChildren() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChildren = widget.allSantri
          .where(
            (child) => child.namaLengkap.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Pilih Anak',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Berdasarkan Nama Anak',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Children list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredChildren.length,
              itemBuilder: (context, index) {
                final santri = _filteredChildren[index];
                final bool isSelected = santri.id == widget.currentSantri.id;
                return _buildChildItem(santri, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildItem(Santri santri, bool isSelected) {
    return GestureDetector(
      onTap: () {
        widget.onChildSelected(santri);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppStyles.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppStyles.primaryColor.withOpacity(0.1),
                // backgroundImage: santri.fotoUrl != null
                //     ? NetworkImage(santri.fotoUrl!)
                //     : null,
                child: santri.fotoUrl == null
                    ? Icon(
                        Icons.person,
                        color:
                            isSelected ? Colors.white : AppStyles.primaryColor,
                        size: 24,
                      )
                    : null),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    santri.namaLengkap,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  // The 'kelas' field is removed as it will be in a separate collection.
                  // You can add a placeholder or fetch it separately later.
                  const SizedBox(), // Placeholder
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Terpilih',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppStyles.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppStyles.primaryColor,
                    ),
                  ],
                ),
              )
            else
              Text(
                'Pilih',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
