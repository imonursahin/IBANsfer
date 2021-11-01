import 'package:flutter/material.dart';
import 'package:ibansfer/panel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'auCode.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({Key? key}) : super(key: key);

  @override
  _MainLoginState createState() => _MainLoginState();
}

TextEditingController emailController = new TextEditingController();
TextEditingController auCodeController = new TextEditingController();

class _MainLoginState extends State<MainLogin> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF181f29)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              "Giriş yapmak için mail adresinizi yazın.",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFf1c740),
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 75.0),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: emailController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Mail Adresiniz',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(height: 75.0),
            MaterialButton(
              height: 40.0,
              minWidth: 150.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                sendMail();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                        backgroundColor: Color(0xFF29313c),
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        actions: <Widget>[
                          Container(
                            width: 180.0,
                            child: TextField(
                              autofocus: true,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
/*                                   enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ), */
                                  labelText: 'Doğrulama Kodu',
                                  labelStyle: TextStyle(
                                    color: Colors.blueGrey,
                                  )),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return MainPanel();
                                }),
                              );
                            },
                            padding: EdgeInsets.all(12),
                            color: Color(0xFFf17c03),
                            child: Text('Doğrula',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ]);
                  },
                );
              },
              padding: EdgeInsets.all(12),
              color: Color(0xFFf17c03),
              child: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

sendMail() async {
  String username = 'your mail';
  String password = 'your pass';
/*   String domainSmtp = 'smtp.gmail.com';
 */
  //also use for gmail smtp
  // ignore: deprecated_member_use
  final smtpServer = gmail(username, password);

  //user for your own domain
/*   final smtpServer =
      SmtpServer(domainSmtp, username: username, password: password, port: 587); */

  final message = Message()
    ..from = Address(username, 'IBANsfer')
    ..recipients.add(emailController.text)
    //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'IBANsfer Doğrulama Kodu 🙂'
    ..text =
        'Doğrulama kodunu ilgili alana girerek hesabınıza giriş yapabilirsiniz. \n' +
            get6DigitNumber() +
            '\n\n\n IBANsfer \n';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
