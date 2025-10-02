# Fix: Navbar Masih Muncul Setelah Logout

## 🐛 Masalah

Setelah user melakukan logout, bottom navigation bar (navbar) masih terlihat di halaman login. User juga masih bisa mengakses menu Beranda dan halaman lainnya meskipun sudah logout.

## 🔍 Penyebab

### 1. **PersistentTabView Navigation Stack**
Aplikasi menggunakan `PersistentTabView` dari package `persistent_bottom_nav_bar` yang membuat navbar tetap ada di semua screen yang berada dalam navigation stack-nya.

### 2. **Navigator Context Issue**
Saat logout menggunakan `Navigator.of(context)` biasa, hanya menghapus route di dalam tab context, bukan root navigator. Ini menyebabkan `PersistentTabView` tetap aktif.

### 3. **MaterialPageRoute vs Named Routes**
Menggunakan `MaterialPageRoute` langsung tidak membersihkan navigation stack dengan sempurna seperti named routes.

## ✅ Solusi yang Diterapkan

### 1. **Gunakan Root Navigator**
```dart
// ❌ SEBELUM (Salah)
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const LoginScreen()),
  (Route<dynamic> route) => false,
);

// ✅ SESUDAH (Benar)
Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
  '/login',
  (Route<dynamic> route) => false,
);
```

**Penjelasan:**
- `rootNavigator: true` - Memastikan menggunakan root navigator, bukan tab navigator
- `pushNamedAndRemoveUntil` - Menghapus SEMUA route sebelumnya dan push route baru
- `'/login'` - Menggunakan named route yang terdaftar di `routes.dart`
- `(Route<dynamic> route) => false` - Predicate yang menghapus semua route

### 2. **Named Routes**
Named routes memastikan navigasi yang konsisten dan clean:

```dart
// lib/app/config/routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String onboard = '/onboard';
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboard: (context) => const OnboardScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
  };
}
```

### 3. **Cleanup Unused Imports**
Menghapus import `LoginScreen` yang tidak diperlukan lagi karena menggunakan named routes.

## 📝 Files Modified

### 1. `lib/features/profile/screens/profile_page.dart`
```dart
// Logout function
if (confirm == true) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  await authProvider.logout();
  if (context.mounted) {
    // Use named route to ensure clean navigation
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
```

**Changes:**
- ✅ Added `rootNavigator: true`
- ✅ Changed to `pushNamedAndRemoveUntil`
- ✅ Use named route `'/login'`
- ✅ Removed unused import

### 2. `lib/features/profile/screens/profil_page.dart`
```dart
ProfileListTile(
  icon: Icons.exit_to_app,
  title: 'Logout',
  color: Colors.redAccent,
  onTap: () {
    Provider.of<AuthProvider>(context, listen: false).logout();
    // Use named route to ensure clean navigation
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  },
),
```

**Changes:**
- ✅ Added `rootNavigator: true`
- ✅ Changed to `pushNamedAndRemoveUntil`
- ✅ Use named route `'/login'`
- ✅ Removed unused import

## 🧪 Testing

### Test Case 1: Logout dari Profile Page
1. Login ke aplikasi
2. Navigate ke tab "Akun" (Profile)
3. Tap tombol "Logout"
4. Confirm logout
5. **Expected:** Kembali ke Login Screen tanpa navbar
6. **Expected:** Tidak bisa back ke halaman sebelumnya

### Test Case 2: Logout dari Profil Page (Old)
1. Login ke aplikasi
2. Navigate ke profil page lama (jika masih ada)
3. Tap "Logout"
4. **Expected:** Kembali ke Login Screen tanpa navbar

### Test Case 3: Back Button After Logout
1. Setelah logout
2. Press back button di device
3. **Expected:** App exit atau tetap di login screen
4. **Expected:** TIDAK kembali ke halaman yang memerlukan auth

## 🎯 Verification Checklist

- [x] Navbar tidak muncul di login screen setelah logout
- [x] User tidak bisa access menu Beranda setelah logout
- [x] Back button tidak bisa kembali ke authenticated pages
- [x] Navigation stack benar-benar dibersihkan
- [x] No memory leaks dari navigation
- [x] Unused imports dihapus

## 📚 Best Practices

### 1. **Selalu Gunakan Root Navigator untuk Logout**
```dart
Navigator.of(context, rootNavigator: true)
```

### 2. **Gunakan Named Routes**
Lebih maintainable dan type-safe:
```dart
Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
```

### 3. **Clear All Routes on Logout**
```dart
(Route<dynamic> route) => false  // Removes ALL routes
```

### 4. **Check Context Mounted**
```dart
if (context.mounted) {
  Navigator.of(context, rootNavigator: true)...
}
```

## 🔄 Alternative Solutions (Not Used)

### Option 1: SystemNavigator.pop()
```dart
SystemNavigator.pop(); // Exit app completely
```
**Pros:** Completely exits app
**Cons:** Bad UX, user has to reopen app

### Option 2: Restart App
```dart
Phoenix.rebirth(context); // Requires phoenix package
```
**Pros:** Complete reset
**Cons:** Overkill, requires additional package

### Option 3: Custom Navigator Key
```dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
```
**Pros:** More control
**Cons:** More complex setup

## 🚀 Result

✅ **Problem Solved!**
- Navbar tidak lagi muncul setelah logout
- User tidak bisa access authenticated pages setelah logout
- Navigation stack dibersihkan dengan sempurna
- Code lebih clean dengan named routes

---

**Last Updated:** 2025-10-02
**Issue:** Navbar still visible after logout
**Status:** ✅ RESOLVED
**Solution:** Use `rootNavigator: true` with `pushNamedAndRemoveUntil`
