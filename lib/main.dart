import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/splash/splash_screen.dart';
import 'util/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppColors.mainColor));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IBANsfer',
      home: SplashScreen(),
    );
  }
}
