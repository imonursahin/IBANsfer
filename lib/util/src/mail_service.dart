import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';

class MailService {
  sendMail(String email, String randomNumber) async {
    String username = 'ibansfer@gmail.com';
    String password = 'pass';
/*   String domainSmtp = 'smtp.gmail.com';
 */
    //also use for gmail smtp
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    //user for your own domain
/*   final smtpServer =
      SmtpServer(domainSmtp, username: username, password: password, port: 587); */

    final message = Message()
      ..from = Address(username, 'İBANsfer')
      ..recipients.add(email)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'İBANsfer Doğrulama Kodu 🙂'
      ..text =
          'Doğrulama kodunu ilgili alana girerek hesabınıza giriş yapabilirsiniz. \n' +
              randomNumber +
              '\n\n\n İBANsfer \n';

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
}
