import 'dart:math';

// Enum for the type of activity
enum AktivitasType {
  pelanggaran,
  perizinan,
  kesehatan,
}

// Model for a single activity entry
class AktivitasEntry {
  final String id;
  final String judul;
  final String keterangan;
  final String pencatat;
  final DateTime tanggal;
  final AktivitasType tipe;

  AktivitasEntry({
    required this.id,
    required this.judul,
    required this.keterangan,
    required this.pencatat,
    required this.tanggal,
    required this.tipe,
  });
}

// Model for a student's complete activity profile
class StudentAktivitasProfile {
  final String studentId;
  final List<AktivitasEntry> entries;

  StudentAktivitasProfile({
    required this.studentId,
    required this.entries,
  });

  // Factory to create mock data for a student
  factory StudentAktivitasProfile.createMock(String studentId) {
    final random = Random(int.parse(studentId));
    final now = DateTime.now();
    final List<AktivitasEntry> mockEntries = [];

    final List<String> pelanggaranJudul = [
      'Terlambat apel pagi',
      'Tidak memakai seragam lengkap',
      'Meninggalkan kelas tanpa izin',
      'Membuat kegaduhan di asrama'
    ];
    final List<String> perizinanJudul = [
      'Izin pulang (acara keluarga)',
      'Izin tidak ikut kegiatan (sakit)',
      'Izin keluar untuk membeli keperluan'
    ];
    final List<String> kesehatanJudul = [
      'Pemeriksaan rutin di klinik',
      'Sakit (demam dan batuk)',
      'Konsultasi kesehatan'
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
}