import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lsm/core/theme/app_theme.dart';
import 'package:lsm/presentation/screens/dashboard/index.dart';
import 'package:lsm/presentation/screens/onboarding/index.dart';
import 'package:lsm/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isOnBoardingDone = prefs.getBool('isOnBoardingDone') ?? false;
  runApp(
      ProviderScope(
          child: LSMMaterialApp(
            isOnBoardingDone: isOnBoardingDone,
          )
      )
  );
}

// Returns Material App
class LSMMaterialApp extends ConsumerWidget {
  final bool isOnBoardingDone;

  const LSMMaterialApp({
    super.key,
    this.isOnBoardingDone = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final initialThemeAsync = ref.watch(initialThemeProvider);

    return initialThemeAsync.when(
      data: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        title: 'LSM',
        home: LSMApp(isOnBoardingDone: isOnBoardingDone),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error loading theme: $error'),
          ),
        ),
      ),
    );
  }
}

class LSMApp extends StatelessWidget {
  final bool isOnBoardingDone;

  const LSMApp({
    super.key,
    this.isOnBoardingDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isOnBoardingDone ? const DashboardScreen() : const OnBoarding(),
      ),
    );
  }
}