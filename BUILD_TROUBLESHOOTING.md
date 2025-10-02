# Build Troubleshooting Guide - Alhamra Mobile

## Masalah: Gambar Tidak Muncul Saat Build Release

### 🔍 Penyebab Masalah

#### 1. **Missing Internet Permission**
**Masalah:** Aplikasi menggunakan `NetworkImage` dan `CachedNetworkImage` untuk load gambar dari internet, tetapi tidak ada permission `INTERNET` di AndroidManifest.xml.

**Dampak:** 
- Saat `flutter run` (debug mode), permission otomatis ditambahkan
- Saat `flutter build apk/appbundle` (release mode), gambar dari network tidak bisa dimuat

**Solusi:** ✅ Sudah ditambahkan di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### 2. **Cleartext Traffic (HTTP)**
**Masalah:** Android 9+ (API 28+) memblokir HTTP traffic secara default, hanya mengizinkan HTTPS.

**Solusi:** ✅ Sudah ditambahkan `usesCleartextTraffic="true"` di tag `<application>`:
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

**Note:** Untuk production, sebaiknya gunakan HTTPS untuk semua network requests.

#### 3. **Case Sensitivity pada Asset Names**
**Masalah:** Windows tidak case-sensitive, tapi Android build sangat strict.

**Contoh:**
- File: `Capture.PNG` (huruf besar)
- Code: `'assets/gambar/capture.png'` (huruf kecil)
- Result: ❌ Error saat build, ✅ OK saat run di Windows

**Solusi:** ✅ Pastikan nama file di code **persis sama** dengan nama file asli:
```dart
// Benar
static const String capture = 'assets/gambar/Capture.PNG';

// Salah
static const String capture = 'assets/gambar/capture.png';
```

### 📋 Checklist Sebelum Build

- [x] Internet permission sudah ditambahkan
- [x] Cleartext traffic diizinkan (jika menggunakan HTTP)
- [x] Nama file asset case-sensitive sudah benar
- [x] Semua asset terdaftar di `pubspec.yaml`
- [ ] Test build: `flutter build apk --debug` terlebih dahulu
- [ ] Test install APK di device fisik

### 🛠️ Command untuk Build

```bash
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Build debug APK (untuk testing)
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle (untuk Play Store)
flutter build appbundle --release
```

### 🔧 Troubleshooting Lainnya

#### Jika gambar masih tidak muncul:

1. **Check asset registration di pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/logo/
    - assets/gambar/
```

2. **Verify file exists:**
```bash
dir assets\gambar
dir assets\logo
```

3. **Check for typos in asset paths:**
- Gunakan `AssetPaths` class untuk konsistensi
- Hindari hardcode string path

4. **Clear cache dan rebuild:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

5. **Check Android logs:**
```bash
adb logcat | findstr "flutter"
```

### 📱 Testing di Device

1. Install APK:
```bash
flutter install
```

2. Atau manual install:
```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

3. Check logs saat app running:
```bash
adb logcat -s flutter
```

### ✅ Status Perbaikan

| Issue | Status | File Modified |
|-------|--------|---------------|
| Missing INTERNET permission | ✅ Fixed | `android/app/src/main/AndroidManifest.xml` |
| Cleartext traffic blocked | ✅ Fixed | `android/app/src/main/AndroidManifest.xml` |
| Case sensitivity assets | ✅ Fixed | `lib/app/constants/asset_paths.dart` |
| Duplicate asset declarations | ✅ Fixed | `lib/app/constants/asset_paths.dart` |

### 🎯 Next Steps

1. Test build dengan: `flutter build apk --release`
2. Install APK di device fisik
3. Verify semua gambar muncul dengan benar
4. Test dengan koneksi internet ON dan OFF
5. Test di berbagai versi Android (minimal API 21+)

---

**Last Updated:** 2025-10-02
**Tested On:** Windows Development Environment
**Target Platform:** Android
