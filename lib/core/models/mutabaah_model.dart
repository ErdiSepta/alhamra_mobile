enum MutabaahStatus {
  dilaksanakan, // ✔
  tidakDilaksanakan, // -
  izin,
}

class MutabaahEntry {
  final String id;
  final String kegiatan;
  final MutabaahStatus status;
  final DateTime tanggal;
  final String keterangan;
  final String pencatat; // e.g., Musyrif/Wali Kelas

  MutabaahEntry({
    required this.id,
    required this.kegiatan,
    required this.status,
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
    final now = DateTime.now();
    return StudentMutabaahProfile(
      studentId: id,
      entries: [
        MutabaahEntry(
          id: 'PR/24.09/0081',
          kegiatan: 'Shalat Subuh Berjamaah dan Dzikir Pagi',
          status: MutabaahStatus.dilaksanakan,
          tanggal: now.subtract(const Duration(days: 1)),
          keterangan: 'Tepat waktu dan khusyuk.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0082',
          kegiatan: 'Shalat Dzuhur Berjamaah',
          status: MutabaahStatus.dilaksanakan,
          tanggal: now.subtract(const Duration(days: 1)),
          keterangan: 'Menjadi muadzin.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0083',
          kegiatan: 'Shalat Ashar Berjamaah',
          status: MutabaahStatus.tidakDilaksanakan,
          tanggal: now.subtract(const Duration(days: 1)),
          keterangan: 'Ketiduran di asrama tanpa udzur.',
          pencatat: 'Ustadz Ali',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0084',
          kegiatan: 'Halaqah Sore (Kajian Kitab)',
          status: MutabaahStatus.izin,
          tanggal: now.subtract(const Duration(days: 2)),
          keterangan: 'Izin sakit, ada surat dari klinik.',
          pencatat: 'Ustadz Umar',
        ),
        MutabaahEntry(
          id: 'PR/24.09/0085',
          kegiatan: 'Shalat Maghrib Berjamaah',
          status: MutabaahStatus.dilaksanakan,
          tanggal: now.subtract(const Duration(days: 2)),
          keterangan: 'Mengikuti shalat di shaf depan.',
          pencatat: 'Ustadz Umar',
        ),
      ],
    );
  }
}