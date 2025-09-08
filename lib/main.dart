import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/seeder_service.dart';
import 'core/providers/auth_provider.dart';
import 'core/utils/app_styles.dart';
import 'app/config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppStyles.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  
  await SeederService().seedAll();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Alhamra App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppStyles.primaryColor),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
          primaryColor: AppStyles.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: AppStyles.primaryColor,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppStyles.primaryColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
