import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'panel.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color(0xFF181f29)));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IBANsfer',
      home: MainContent(),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF181f29)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://i.hizliresim.com/9c2k2do.png',
                  width: 120.0, height: 80.0),
              SizedBox(height: 20.0),
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
              ),
              SizedBox(height: 100.0),
              MaterialButton(
                height: 40.0,
                minWidth: 150.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MainPanel();
                  }));
                },
                padding: EdgeInsets.all(12),
                color: Color(0xFFf17c03),
                child: Text('Başla', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
