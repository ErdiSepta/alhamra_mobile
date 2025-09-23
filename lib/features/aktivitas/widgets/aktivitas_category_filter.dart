import'package:flutter/material.dart';
import '../../../core/models/aktivitas_model.dart';
import '../../../core/utils/app_styles.dart';

class AktivitasCategoryFilter extends StatelessWidget {
  final AktivitasType? selectedCategory;
  final ValueChanged<AktivitasType?> onCategorySelected;

  // Baru: atur posisi dan jarak
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;

  const AktivitasCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.alignment = Alignment.centerLeft, // default kiri
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    final List<AktivitasType?> categories = [null, ...AktivitasType.values];

    return DefaultTabController(
      length: categories.length,
      initialIndex: _getInitialIndex(categories),
      child: Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: TabBar(
            isScrollable: true,
            indicatorColor: AppStyles.primaryColor,
            indicatorWeight: 2,
            labelColor: AppStyles.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            onTap: (index) {
              onCategorySelected(categories[index]);
            },
            tabs: categories.map((category) {
              return Tab(text: _getLabelForCategory(category));
            }).toList(),
          ),
        ),
      ),
    );
  }

  int _getInitialIndex(List<AktivitasType?> categories) {
    return selectedCategory == null
        ? 0
        : categories.indexOf(selectedCategory);
  }

  String _getLabelForCategory(AktivitasType? category) {
    if (category == null) return 'Semua Aktivitas';
    switch (category) {
      case AktivitasType.pelanggaran:
        return 'Pelanggaran';
      case AktivitasType.perizinan:
        return 'Perijinan';
      case AktivitasType.kesehatan:
        return 'Kesehatan';
    }
  }
}
