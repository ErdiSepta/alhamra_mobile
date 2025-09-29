class MutabaahEntry {
  final String id;
  final String kegiatan;
  final DateTime tanggal;
  final String keterangan;
  final String pencatat; // e.g., Musyrif/Wali Kelas

  MutabaahEntry({
    required this.id,
    required this.kegiatan,
    required this.tanggal,
    required this.keterangan,
    required this.pencatat,
  });
}

class StudentMutabaahProfile {
  final String studentId;
  final List<MutabaahEntry> entries;

  StudentMutabaahProfile({
    required this.studentId,
    required this.entries,
  });

  factory StudentMutabaahProfile.createMock(String id) {
    return StudentMutabaahProfile(
      studentId: id,
      entries: [
        MutabaahEntry(
          id: 'PR/24.09/0081',
          kegiatan: 'Shalat Subuh Berjamaah dan Dzikir Pagi',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Tepat waktu dan khusyuk.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0082',
          kegiatan: 'Shalat Subuh Berjamaah dan Dzikir Pagi',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Terlambat bangun.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0083',
          kegiatan: 'Shalat Dzuhur Berjamaah',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Menjadi muadzin.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0084',
          kegiatan: 'Shalat Ashar Berjamaah',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Izin sakit, ada surat dari klinik.',
          pencatat: 'Ustadz Umar',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0085',
          kegiatan: 'Shalat Maghrib Berjamaah',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Mengikuti shalat di shaf depan.',
          pencatat: 'Ustadz Umar',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0086',
          kegiatan: 'Halaqah Sore (Kajian Kitab)',
          tanggal: DateTime(2024, 9, 4),
          keterangan: 'Aktif bertanya.',
          pencatat: 'Ustadz Umar',
        ),
      ],
    );
  }
}