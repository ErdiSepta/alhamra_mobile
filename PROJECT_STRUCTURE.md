# 📁 Project Structure Documentation

## Overview
This Flutter project has been restructured to follow professional best practices with feature-based organization for better maintainability and scalability.

## 🏗️ New Directory Structure

```
lib/
├── main.dart                           # App entry point
├── app/                               # App-level configuration
│   ├── config/
│   │   ├── app_config.dart           # App configuration constants
│   │   ├── routes.dart               # Centralized route management
│   │   └── themes.dart               # App theme configuration
│   └── constants/
│       ├── app_constants.dart        # General app constants
│       ├── api_endpoints.dart        # API endpoint definitions
│       └── asset_paths.dart          # Asset path constants
├── core/                             # Core functionality shared across features
│   ├── services/                     # Business logic services
│   │   ├── auth_service.dart
│   │   ├── notification_service.dart
│   │   └── seeder_service.dart
│   ├── providers/                    # State management providers
│   │   └── auth_provider.dart
│   ├── utils/                        # Utility functions and helpers
│   │   └── app_styles.dart
│   └── models/                       # Data models
│       ├── bill.dart
│       ├── notification_model.dart
│       └── user_model.dart
└── features/                         # Feature-based organization
    ├── auth/                         # Authentication feature
    │   ├── screens/
    │   │   ├── login_screen.dart
    │   │   ├── splash_screen.dart
    │   │   ├── onboard_screen.dart
    │   │   └── index.dart            # Export file for easy imports
    │   └── widgets/
    ├── home/                         # Home/Dashboard feature
    │   ├── screens/
    │   │   ├── beranda_page.dart
    │   │   └── home_screen.dart
    │   └── widgets/
    ├── payment/                      # Payment feature
    │   ├── screens/
    │   │   ├── pembayaran_page.dart
    │   │   ├── pembayaran_flow_bsi.dart
    │   │   ├── standalone_pembayaran_page.dart
    │   │   ├── status_berhasil_page.dart
    │   │   ├── status_menunggu_page.dart
    │   │   └── status_page.dart
    │   └── widgets/
    │       └── bill_card.dart
    ├── topup/                        # Top-up feature
    │   ├── screens/
    │   │   ├── topup_page.dart
    │   │   ├── topup_confirm_page.dart
    │   │   └── topup_payment_page.dart
    │   └── widgets/
    ├── history/                      # Transaction history feature
    │   ├── screens/
    │   │   ├── riwayat_dompet_page.dart
    │   │   ├── riwayat_tagihan_page.dart
    │   │   └── riwayat_uang_saku_page.dart
    │   └── widgets/
    ├── notifications/                # Notifications feature
    │   ├── screens/
    │   │   ├── pemberitahuan_page.dart
    │   │   └── detail_pemberitahuan_page.dart
    │   └── widgets/
    │       └── notification_widgets.dart
    ├── profile/                      # User profile feature
    │   ├── screens/
    │   │   ├── profil_page.dart
    │   │   └── bantuan_screen.dart
    │   └── widgets/
    │       └── profile_list_tile.dart
    └── shared/                       # Shared widgets across features
        └── widgets/
            ├── custom_app_bar.dart
            ├── custom_button.dart
            ├── custom_textfield.dart
            └── index.dart            # Export file for easy imports
```

## 🎯 Benefits of This Structure

### 1. **Feature-Based Organization**
- Each feature is self-contained with its own screens and widgets
- Easy to locate and modify feature-specific code
- Better team collaboration (developers can work on different features independently)

### 2. **Separation of Concerns**
- **Core**: Shared business logic, services, and models
- **App**: Configuration and constants
- **Features**: Feature-specific UI and logic

### 3. **Scalability**
- Easy to add new features without affecting existing code
- Clear boundaries between different parts of the application
- Modular architecture supports future expansion

### 4. **Maintainability**
- Consistent import patterns
- Index files for cleaner imports
- Clear naming conventions

## 📝 Import Guidelines

### Importing from Core
```dart
import '../../../core/utils/app_styles.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/auth_provider.dart';
```

### Importing Shared Widgets
```dart
import '../../shared/widgets/custom_button.dart';
// or using index file:
import '../../shared/widgets/index.dart';
```

### Importing Between Features
```dart
import '../../payment/screens/status_berhasil_page.dart';
import '../../notifications/screens/pemberitahuan_page.dart';
```

## 🔧 Configuration Files

### Routes (app/config/routes.dart)
Centralized route management for better organization and maintenance.

### Constants (app/constants/)
- **app_constants.dart**: General app constants
- **asset_paths.dart**: Asset path management
- **api_endpoints.dart**: API endpoint definitions (for future use)

### Core Services (core/services/)
Business logic and external service integrations.

## 🚀 Getting Started with New Structure

1. **Adding a New Feature:**
   - Create folder in `features/`
   - Add `screens/` and `widgets/` subfolders
   - Create index files for exports

2. **Adding Shared Components:**
   - Place in `features/shared/widgets/`
   - Update index file

3. **Adding Core Functionality:**
   - Services go in `core/services/`
   - Models go in `core/models/`
   - Utilities go in `core/utils/`

## 📋 Migration Completed

✅ All files moved to appropriate directories
✅ Import statements updated automatically
✅ Route management centralized
✅ Configuration files created
✅ Index files for better imports
✅ Documentation created

The project is now ready for professional development with improved organization and maintainability!
