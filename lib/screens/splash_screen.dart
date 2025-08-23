import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Use a post-frame callback to perform navigation after the build is complete.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authProvider.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (authProvider.status == AuthStatus.unauthenticated) {
            Navigator.pushReplacementNamed(context, '/onboard');
          }
        });

        // While authenticating, show the splash screen UI.
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo/alhamra_splashscreen.png', width: 400),
                const SizedBox(height: 48),
                LoadingAnimationWidget.dotsTriangle(
                  color: const Color(0xFF00BFA5),
                  size: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
