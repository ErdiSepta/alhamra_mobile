class SeederService {
  Future<void> seedAll() async {
    print('[Seeder] Starting to seed all data...');
    await seedBerita();
    await seedDummySantri();
    print('[Seeder] Seeding process finished.');
  }

  Future<void> seedDummySantri() async {
    try {
      print('[Seeder] Using static santri data - no seeding required.');
      // Static data is already available in SantriService
      print('[Seeder] Static santri data is ready.');
    } catch (e) {
      print('[Seeder] ERROR during seedDummySantri: $e');
    }
  }

  Future<void> seedBerita() async {
    try {
      print('[Seeder] Using static berita data - no seeding required.');
      // Static data is already available in BeritaService
      print('[Seeder] Static berita data is ready.');
    } catch (e) {
      print('[Seeder] ERROR during seedBerita: $e');
    }
  }
}