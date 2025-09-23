enum TahfidzStatus {
  murojaah,
  mumtaz,
  jayyidJiddan,
  lancar,
  pentashihan,
  kurangLancar,
}

class TahfidzEntry {
  final String surahName;
  final TahfidzStatus status;
  final String id;
  final int jumlahBaris;
  final String keterangan;
  final String ustadPembimbing;
  final DateTime tanggal;

  TahfidzEntry({
    required this.surahName,
    required this.status,
    required this.id,
    required this.jumlahBaris,
    required this.keterangan,
    required this.ustadPembimbing,
    required this.tanggal,
  });
}

class StudentTahfidzProfile {
  final String studentId;
  final List<TahfidzEntry> entries;

  StudentTahfidzProfile({
    required this.studentId,
    required this.entries,
  });

  factory StudentTahfidzProfile.createMock(String id) {
    final now = DateTime.now();
    return StudentTahfidzProfile(
      studentId: id,
      entries: [
        TahfidzEntry(
          surahName: 'Al-Ma’idah',
          status: TahfidzStatus.murojaah,
          id: 'TQ/24.01.0421',
          jumlahBaris: 15,
          keterangan: 'Mengulang hafalan juz 6',
          ustadPembimbing: 'Ustadz Abdullah',
          tanggal: now.subtract(const Duration(days: 1)),
        ),
        TahfidzEntry(
          surahName: 'An-Nisa',
          status: TahfidzStatus.mumtaz,
          id: 'TQ/24.01.0422',
          jumlahBaris: 20,
          keterangan: 'Setoran baru halaman 50',
          ustadPembimbing: 'Ustadz Abdullah',
          tanggal: now.subtract(const Duration(days: 2)),
        ),
        TahfidzEntry(
          surahName: 'Ali ‘Imran',
          status: TahfidzStatus.jayyidJiddan,
          id: 'TQ/24.01.0423',
          jumlahBaris: 10,
          keterangan: 'Hafalan lancar dengan sedikit catatan',
          ustadPembimbing: 'Ustadz Ibrahim',
          tanggal: now.subtract(const Duration(days: 4)),
        ),
        TahfidzEntry(
          surahName: 'Al-Baqarah',
          status: TahfidzStatus.kurangLancar,
          id: 'TQ/24.01.0424',
          jumlahBaris: 5,
          keterangan: 'Perlu banyak pengulangan, masih terbata-bata',
          ustadPembimbing: 'Ustadz Abdullah',
          tanggal: now.subtract(const Duration(days: 5)),
        ),
        TahfidzEntry(
          surahName: 'Yusuf',
          status: TahfidzStatus.pentashihan,
          id: 'TQ/24.01.0425',
          jumlahBaris: 0,
          keterangan: 'Proses perbaikan makhraj dan tajwid',
          ustadPembimbing: 'Ustadz Ibrahim',
          tanggal: now.subtract(const Duration(days: 7)),
        ),
        TahfidzEntry(
          surahName: 'Ar-Ra\'d',
          status: TahfidzStatus.lancar,
          id: 'TQ/24.01.0426',
          jumlahBaris: 12,
          keterangan: 'Setoran lancar tanpa pengulangan',
          ustadPembimbing: 'Ustadz Abdullah',
          tanggal: now.subtract(const Duration(days: 10)),
        ),
      ],
    );
  }
}
