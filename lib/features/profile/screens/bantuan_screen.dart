import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.greyColor,
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Time (9:41) - biasanya ini status bar, jadi bisa diabaikan
            // atau dibuat sebagai decorative element
            
            // Section: Cari jawaban atau hubungi kami
            _buildHelpSection(context),
            
            const SizedBox(height: 24),
            
            // Section: Topik Populer
            _buildPopularTopics(context),
            
            const SizedBox(height: 24),
            
            // Section: Hubungi Kami
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppStyles.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cari jawaban atau hubungi kami',
              style: AppStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildChecklistItem(context, 'Cart bantuan ...'),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularTopics(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppStyles.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Topik Populer',
              style: AppStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildChecklistItem(context, 'Bagaimana cara mengganti kata sandi?'),
            _buildChecklistItem(context, 'Bagaimana cara membayar tagihan?'),
            _buildChecklistItem(context, 'Melibat Progress Tahfidz Anak'),
            _buildChecklistItem(context, 'Apa itu Mutabalah?'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppStyles.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hubungi Kami',
              style: AppStyles.bodyText(context).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactItem(context, Icons.phone, 'Telepon : 0812xxxxxx'),
            _buildContactItem(context, Icons.email, 'Email : info@ibsaihamra.sch.id'),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppStyles.primaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: Colors.transparent, // Awalnya transparan
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bodyText(context).copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppStyles.primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppStyles.bodyText(context).copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// Jika Anda masih ingin mempertahankan FAQ functionality, 
// bisa dibuat sebagai screen terpisah atau dengan toggle
class InteractiveChecklistItem extends StatefulWidget {
  final String text;
  final bool isInteractive;

  const InteractiveChecklistItem({
    super.key,
    required this.text,
    this.isInteractive = false,
  });

  @override
  State<InteractiveChecklistItem> createState() => _InteractiveChecklistItemState();
}

class _InteractiveChecklistItemState extends State<InteractiveChecklistItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isInteractive ? () {
        setState(() {
          _isChecked = !_isChecked;
        });
      } : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isChecked ? AppStyles.primaryColor : AppStyles.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
                color: _isChecked ? AppStyles.primaryColor : Colors.transparent,
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: _isChecked ? Colors.white : Colors.transparent,
              ),
            ),
            Expanded(
              child: Text(
                widget.text,
                style: AppStyles.bodyText(context).copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}