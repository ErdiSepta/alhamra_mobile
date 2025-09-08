# PowerShell script to update import statements in all Dart files
$files = Get-ChildItem -Path "lib\features" -Recurse -Filter "*.dart"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Update common import patterns
    $content = $content -replace "import 'package:alhamra_1/utils/app_styles\.dart';", "import '../../../core/utils/app_styles.dart';"
    $content = $content -replace "import 'package:alhamra_1/services/", "import '../../../core/services/"
    $content = $content -replace "import 'package:alhamra_1/providers/", "import '../../../core/providers/"
    $content = $content -replace "import 'package:alhamra_1/models/", "import '../../../core/models/"
    $content = $content -replace "import 'package:alhamra_1/widgets/", "import '../../shared/widgets/"
    $content = $content -replace "import 'package:alhamra_1/screens/", "import '../../"
    
    # Fix relative paths based on file location
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\lib\features\", "")
    $depth = ($relativePath.Split('\').Length - 2)
    $backPath = "../" * ($depth + 2)
    
    # Update specific screen imports
    $content = $content -replace "import '\.\.\/\.\.\/topup_page\.dart';", "import '../../topup/screens/topup_page.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/standalone_pembayaran_page\.dart';", "import '../../payment/screens/standalone_pembayaran_page.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/pemberitahuan_page\.dart';", "import '../../notifications/screens/pemberitahuan_page.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/status_berhasil_page\.dart';", "import '../../payment/screens/status_berhasil_page.dart';"
    
    Set-Content -Path $file.FullName -Value $content
    Write-Host "Updated: $($file.Name)"
}
