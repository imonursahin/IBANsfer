import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'iban_scanner_home_screen.dart';

class MainPanel extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MainPanel> {
  final List<String> userName = <String>[];
  final List<String> bankName = <String>[];
  final List<String> iban = <String>[];

  TextEditingController userController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();

  _shareData(int index) {
    Share.share(
        'IBANsfer aracılığı ile gönderildi. \n Banka: ${bankName[index]} \n Alıcı Adı: ${userName[index]} \n IBAN: ${iban[index]} ');
  }

  void addItemToList() {
    setState(() {
      userName.insert(0, userController.text);
      bankName.insert(0, nameController.text);
      iban.insert(0, ibanController.text);
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF29313c),
          elevation: 25,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Row(
            children: [
              Icon(Icons.add, color: Colors.white),
              new Text("iban bilgisi ekle"),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.cancel,
                ),
                iconSize: 25,
                color: Colors.red,
                onPressed: () {
                  nameController.clear();
                  ibanController.clear();
                  userController.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.white),
          content: Container(
            height: 200.0,
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: Colors.white),
                  maxLength: 20,
                  controller: nameController,
                  autofocus: true,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    border: OutlineInputBorder(),
                    labelText: 'Banka',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        nameController.clear();
                      },
                      icon: Icon(Icons.clear, size: 10, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: TextStyle(color: Colors.white),
                  maxLength: 50,
                  controller: userController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    border: OutlineInputBorder(),
                    labelText: 'Alıcı Adı',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        userController.clear();
                      },
                      icon: Icon(Icons.clear, size: 10, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: TextStyle(color: Colors.white),
                  maxLength: 40,
                  controller: ibanController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    border: OutlineInputBorder(),
                    labelText: 'IBAN',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        ibanController.clear();
                      },
                      icon: Icon(Icons.clear, size: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new RaisedButton(
              child: Text('İptal', style: TextStyle(color: Colors.white)),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () {
                nameController.clear();
                ibanController.clear();
                userController.clear();
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            new RaisedButton(
              child: Text('Ekle', style: TextStyle(color: Colors.white)),
              color: Color(0xFFf17c03),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () {
                addItemToList();
                Navigator.pop(context);
                nameController.clear();
                ibanController.clear();
                userController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF29313c),
          title: Text("IBANsfer"),
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFF29313c),
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    title: Row(
                      children: [
                        Icon(Icons.info, color: Colors.white),
                        SizedBox(width: 10.0),
                        new Text(
                          "IBANsfer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    content: new Text(
                      "\n IBAN bilgilerinizi tek bir yerden erişebilmenize ve yönetmenize olanak sağlayan ücretsiz ve güvenli bir uygulamadır. \n\n - iban numarası ekleme, silme ve paylaşma. \n\n - iban tarama. \n\n\n\n\n ibansfer@gmail.com",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      // ignore: deprecated_member_use
                      new FlatButton(
                        child: new Text(
                          "Kapat",
                          style: TextStyle(
                            color: Color(0xFFf17c03),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              Icons.info_outline_rounded,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return IbanScannerHomeScreen();
                      }),
                    );
                  },
                  child: Icon(Icons.document_scanner),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFf17c03),
          foregroundColor: Colors.white,
          icon: Icon(
            Icons.add,
            size: 20,
          ),
          label: Text(
            'Ekle',
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            _showDialog(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF181f29)),
          child: Column(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: bankName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SafeArea(
                          child: Container(
                              height: 92,
                              margin: EdgeInsets.all(1),
                              child: Card(
                                margin: EdgeInsets.all(9),
                                elevation: 20,
                                color: Color(0xFF1c252e),
                                child: Center(
                                  child: ListTile(
                                    leading: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            size: 25,
                                          ),
                                          color: Color(0xFFf17c03),
                                          onPressed: () {
                                            _shareData(index);
                                          },
                                        ),
                                        Text(
                                          "Hızlı Paylaş",
                                          style: new TextStyle(
                                            fontSize: 7.2,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      "${bankName[index]}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          size: 40,
                                        ),
                                        color: Colors.white,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AlertDialog(
                                                  backgroundColor:
                                                      Color(0xFF29313c),
                                                  elevation: 25,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  title: Row(
                                                    children: [
                                                      new Text(
                                                          "${bankName[index]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Spacer(),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                        ),
                                                        iconSize: 25,
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  content: new Text(
                                                      " ${userName[index]} \n\n ${iban[index]} ",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  actions: <Widget>[
                                                    // ignore: deprecated_member_use
                                                    new RaisedButton(
                                                      child: Text('Sil',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      color: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      16.0))),
                                                      onPressed: () {},
                                                    ),
                                                    // ignore: deprecated_member_use
                                                    new RaisedButton(
                                                      child: Text('Paylaş',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      color: Color(0xFFf17c03),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      16.0))),
                                                      onPressed: () {
                                                        _shareData(index);
                                                      },
                                                    ),
                                                  ]);
                                            },
                                          );
                                        }),
                                  ),
                                ),
                              )));
                    }))
          ]),
        ));
  }
}
