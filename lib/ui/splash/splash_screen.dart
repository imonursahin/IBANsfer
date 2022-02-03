import 'package:flutter/material.dart';
import 'package:ibansfer/ui/login/login.dart';
import 'package:ibansfer/ui/panel/panel.dart';
import 'package:ibansfer/util/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLogin()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                decoration: BoxDecoration(color: AppColors.mainColor),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage(
                            'assets/appicon.png',
                          ),
                          width: 150.0,
                          height: 150.0),
                      SizedBox(height: 12.0),
                      Text(
                        "IBANsfer",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFFf0b90b),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Color(0xFF323c45),
                        indent: 150,
                        endIndent: 150,
                        thickness: 1.3,
                      ),
                      Text(
                        "iban paylaşmanın en kolay hali",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFf1c740),
                          fontWeight: FontWeight.w100,
                        ),
                      )
                    ]))));
  }
}
