import 'package:alhamra_1/features/shared/widgets/student_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/data/student_data.dart';
import '../../../core/utils/app_styles.dart';
import '../../shared/widgets/index.dart';

class PerizinanPage extends StatefulWidget {
  const PerizinanPage({super.key});

  @override
  State<PerizinanPage> createState() => _PerizinanPageState();
}

class _PerizinanPageState extends State<PerizinanPage> {
  // --- State Management ---
  String _selectedStudentName = StudentData.defaultStudent;
  bool _isStudentOverlayVisible = false;

  // --- Form State ---
  final _formKey = GlobalKey<FormState>();
  final _keperluanController = TextEditingController();
  final _penjemputController = TextEditingController();
  DateTime? _tanggalJemput;
  DateTime? _tanggalKembali;

  @override
  void dispose() {
    _keperluanController.dispose();
    _penjemputController.dispose();
    super.dispose();
  }

  void _updateSelectedData() {
    // Reset form when student changes
    setState(() {
      _formKey.currentState?.reset();
      _keperluanController.clear();
      _penjemputController.clear();
      _tanggalJemput = null;
      _tanggalKembali = null;
    });
  }

  void _submitPerizinan() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process the data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Formulir perizinan untuk $_selectedStudentName telah diajukan.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  // --- UI Builders ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: CustomAppBar(
        title: 'Formulir Perizinan',
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildStudentSelector(),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildPerizinanForm(),
                ),
              ),
            ],
          ),
          if (_isStudentOverlayVisible)
            SearchOverlayWidget(
              isVisible: _isStudentOverlayVisible,
              title: 'Pilih Santri',
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
              searchHint: 'Cari santri...',
              avatarUrl: StudentData.getStudentAvatar(_selectedStudentName),
            ),
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

  Widget _buildPerizinanForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Perizinan',
              style: AppStyles.sectionTitle(context)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _keperluanController,
              decoration: const InputDecoration(
                labelText: 'Keperluan',
                hintText: 'Contoh: Pulang kampung, acara keluarga',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keperluan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _penjemputController,
              decoration: const InputDecoration(
                labelText: 'Penjemput',
                hintText: 'Contoh: Ayah, Ibu, Kakak',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama penjemput tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildDatePicker(
              'Tanggal Penjemputan',
              _tanggalJemput,
              (date) => setState(() => _tanggalJemput = date),
            ),
            const SizedBox(height: 20),
            _buildDatePicker(
              'Tanggal Kembali',
              _tanggalKembali,
              (date) => setState(() => _tanggalKembali = date),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPerizinan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ajukan Perizinan',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppStyles.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              locale: const Locale('id', 'ID'),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme:
                        const ColorScheme.light(primary: AppStyles.primaryColor),
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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                          .format(selectedDate)
                      : 'Pilih tanggal',
                  style: AppStyles.bodyText(context).copyWith(
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
                const Icon(Icons.calendar_today,
                    color: AppStyles.primaryColor, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}