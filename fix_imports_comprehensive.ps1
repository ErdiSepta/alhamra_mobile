# Comprehensive import fix script
$files = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix core imports
    $content = $content -replace "import 'package:alhamra_1/utils/app_styles\.dart';", "import '../../../core/utils/app_styles.dart';"
    $content = $content -replace "import 'package:alhamra_1/services/", "import '../../../core/services/"
    $content = $content -replace "import 'package:alhamra_1/providers/", "import '../../../core/providers/"
    $content = $content -replace "import 'package:alhamra_1/models/", "import '../../../core/models/"
    
    # Fix relative path imports based on file location
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\lib\", "")
    
    # Fix imports for shared widgets
    $content = $content -replace "import '\.\.\/utils\/app_styles\.dart';", "import '../../../core/utils/app_styles.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/shared\/widgets\/profile_list_tile\.dart';", "import '../widgets/profile_list_tile.dart';"
    
    # Fix screen-to-screen imports
    $content = $content -replace "import '\.\.\/\.\.\/login_screen\.dart';", "import '../../auth/screens/login_screen.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/topup_payment_page\.dart';", "import '../topup_payment_page.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/topup_confirm_page\.dart';", "import '../topup_confirm_page.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/status_menunggu_page\.dart';", "import '../../payment/screens/status_menunggu_page.dart';"
    
    # Fix specific file patterns
    if ($file.Name -eq "custom_button.dart" -or $file.Name -eq "custom_textfield.dart") {
        $content = $content -replace "import '\.\.\/utils\/app_styles\.dart';", "import '../../../core/utils/app_styles.dart';"
    }
    
    if ($file.Name -eq "profil_page.dart") {
        $content = $content -replace "import '\.\.\/\.\.\/shared\/widgets\/profile_list_tile\.dart';", "import '../widgets/profile_list_tile.dart';"
        $content = $content -replace "import '\.\.\/\.\.\/login_screen\.dart';", "import '../../auth/screens/login_screen.dart';"
    }
    
    if ($file.Name -eq "topup_confirm_page.dart") {
        $content = $content -replace "import '\.\.\/\.\.\/topup_payment_page\.dart';", "import 'topup_payment_page.dart';"
    }
    
    if ($file.Name -eq "topup_page.dart") {
        $content = $content -replace "import '\.\.\/\.\.\/topup_confirm_page\.dart';", "import 'topup_confirm_page.dart';"
    }
    
    if ($file.Name -eq "topup_payment_page.dart") {
        $content = $content -replace "import '\.\.\/\.\.\/status_menunggu_page\.dart';", "import '../../payment/screens/status_menunggu_page.dart';"
    }
    
    # Only write if content changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Fixed: $($file.Name)"
    }
}
