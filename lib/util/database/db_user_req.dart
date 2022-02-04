import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibansfer/util/src/iban_req.dart';
import 'package:ibansfer/util/src/user_req.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

class Database {
  static Future<void> addUser(UserReq data) async {
    DocumentReference documentReferencer = _mainCollection.doc(data.email);

    await _mainCollection.doc(data.email).collection("iban").add({});

    await documentReferencer.set(data.toJson());
  }

  static Future<bool> isUserExist(UserReq data) async {
    List<IbanReq> ibanResp = [];
    bool isExist = false;
    DocumentReference userDoc = _mainCollection.doc(data.email);

    var userObj = await userDoc.get();

    if (!userObj.exists) {
      return false;
    }

    return true;
  }
}
