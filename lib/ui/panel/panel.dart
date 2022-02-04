import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibansfer/ui/login/login.dart';
import 'package:ibansfer/util/database/db_data_req.dart';
import 'package:ibansfer/util/src/iban_req.dart';
import 'package:ibansfer/util/src/user_req.dart';
import 'package:ibansfer/util/theme/app_colors.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_iban_scanner_screen.dart';

class MainPanel extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MainPanel> {
  List<IbanReq> ibanList = [];
  List<UserReq> userList = [];

  bool isLoading = false;
  String userEmail = "";
  List<CameraDescription>? cameras;

  String messageCheck = "";
  Color messageColor = Colors.white;

  TextEditingController ibanCheck = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();

  _shareData(int index) {
    Share.share(
        'Finansfer aracılığı ile gönderildi. \n Banka: ${ibanList[index].bankName} \n Alıcı Adı: ${ibanList[index].ibanOwner} \n IBAN: ${ibanList[index].ibanNumber} ');
  }

  @override
  void initState() {
    super.initState();
    _initCameras();

    getDatabaseIbans();
  }

  @override
  void dispose() {
    ibanController.dispose();
    super.dispose();
  }

  void _initCameras() async {
    cameras = await availableCameras();
  }

  getDatabaseIbans() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userEmail = preferences.getString("userEmail")!;
    ibanList = await Database.getIbansByEmail(userEmail);

    setState(() {
      isLoading = false;
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        FocusNode focusNode = FocusNode();

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
                  controller: nameController,
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
                      onPressed: () => {
                        focusNode.unfocus(),
                        focusNode.canRequestFocus = false,
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IBANScannerView(
                              cameras: cameras!,
                              onScannerResult: (iban) {
                                ibanController.text = iban;
                                Navigator.pop(context);
                              },
                              allowImagePicker: false,
                              allowCameraSwitch: false,
                            ),
                          ),
                        ),
                        Future.delayed(
                          Duration(milliseconds: 100),
                          () {
                            focusNode.canRequestFocus = true;
                          },
                        ),
                      },
                      icon: Icon(Icons.camera_sharp,
                          size: 20, color: Colors.white),
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
              onPressed: () async {
                if (nameController.text != "" &&
                    ibanController.text != "" &&
                    userController.text != "") {
                  ibanList.add(IbanReq(
                      bankName: nameController.text,
                      ibanNumber: ibanController.text,
                      ibanOwner: userController.text));
                  await Database.addIban(
                      IbanReq(
                          bankName: nameController.text,
                          ibanNumber: ibanController.text,
                          ibanOwner: userController.text),
                      userEmail);
                  getDatabaseIbans();
                  setState(() {});
                  nameController.clear();
                  ibanController.clear();
                  userController.clear();
                  Navigator.pop(context);
                } else {}
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
                        SizedBox(width: 10.0),
                        new Text(
                          "IBANsfer 💳",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    content: new Text(
                      "\n IBAN bilgilerinizi tek bir yerden erişebilmenize ve yönetmenize olanak sağlayan ücretsiz ve güvenli bir uygulamadır. 🆓 ✅ 😍 \n\n\n  📩  ibansfer@gmail.com",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      // ignore: deprecated_member_use

                      new FlatButton(
                        child: new Text(
                          "Kapat",
                          style: TextStyle(
                            color: AppColors.btnOrange,
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
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
                                  "İban kontrol",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                  ),
                                  iconSize: 25,
                                  color: Colors.red,
                                  onPressed: () {
                                    ibanCheck.clear();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            content: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: ibanCheck,
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
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    ibanCheck.clear();
                                  },
                                  icon: Icon(Icons.clear,
                                      size: 10, color: Colors.white),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(messageCheck,
                                    style: TextStyle(
                                      color: messageColor,
                                      fontSize: 12.0,
                                    )),
                              ),
                              // ignore: deprecated_member_use
                              new RaisedButton(
                                onPressed: () {
                                  ibanChecks(setState);
                                },
                                child: Text(
                                  'Kontrol Et',
                                  style: TextStyle(fontSize: 13),
                                ),
                                textColor: Colors.white,
                                color: AppColors.btnOrange,
                                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                  child: Icon(Icons.check_circle, color: Colors.green),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.btnOrange,
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
          decoration: BoxDecoration(color: AppColors.mainColor),
          child: Column(children: <Widget>[
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppColors.btnOrange,
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: ibanList.length,
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
                                          "${ibanList[index].bankName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              size: 40,
                                            ),
                                            color: Colors.white,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Color(0xFF29313c),
                                                      elevation: 25,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      title: Row(
                                                        children: [
                                                          new Text(
                                                              "${ibanList[index].bankName}",
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
                                                          " ${ibanList[index].ibanOwner} \n\n ${ibanList[index].ibanNumber} ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      actions: <Widget>[
                                                        // ignore: deprecated_member_use
                                                        new RaisedButton(
                                                          child: Text('Sil',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          color: Colors.red,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16.0))),
                                                          onPressed: () async {
                                                            await Database
                                                                .deleteIban(
                                                                    ibanList[
                                                                            index]
                                                                        .docId!,
                                                                    userEmail);
                                                            getDatabaseIbans();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        // ignore: deprecated_member_use
                                                        new RaisedButton(
                                                          child: Text('Paylaş',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          color:
                                                              Color(0xFFf17c03),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
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

  ibanChecks(setState) {
    String iban = ibanCheck.text.toString().replaceAll(' ', '');
    print(iban);
    var wrongIban = "x Hatalı ! IBAN adresi, Türkiye [TR] için geçerli değil. ";
    var correctIban =
        " √ IBAN, Türkiye [TR] için geçerli. \n √ IBAN, Türkiye [TR] için doğru uzunluğuna sahip. \n √ IBAN, Türkiye [TR] için standart IBAN karakteri biçimindedir.";
    var notIban = "İban adresi girmediniz.";

    if (iban.length == 26 &&
        iban[0].toUpperCase() == "T" &&
        iban[1].toUpperCase() == "R" &&
        num.tryParse(iban.substring(2)) != null) {
      setState(() {
        messageCheck = correctIban;
        messageColor = Colors.green;
      });
    } else if (ibanCheck.text.isEmpty) {
      setState(() {
        messageCheck = notIban;
        messageColor = Colors.grey;
      });
    } else {
      setState(() {
        messageCheck = wrongIban;
        messageColor = Colors.red;
      });
    }
  }
}
