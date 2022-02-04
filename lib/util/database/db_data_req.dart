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

  static Future<void> addIban(IbanReq data, String email) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(email).collection("iban").doc();

    await documentReferencer.set(data.toJson());

    return;
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

  static Future<void> deleteIban(
    String docId,
    String email,
  ) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(email).collection('iban').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Deleted'))
        .catchError((e) => print(e));
  }

  static Future<List<IbanReq>> getIbansByEmail(String email) async {
    List<IbanReq> ibanResp = [];
    CollectionReference ibanCollect =
        _mainCollection.doc(email).collection('iban');

    var ibanDocs = await ibanCollect.get();

    for (var item in ibanDocs.docs) {
      DocumentReference ibanRef =
          _mainCollection.doc(email).collection('iban').doc(item.id);
      var ibanDoc = await ibanRef.get();
      var ibanData = ibanDoc.data() as Map<String, dynamic>;
      if (ibanData.isNotEmpty) {
        IbanReq temp = IbanReq.fromJson(ibanData);
        temp.docId = ibanDoc.id;
        ibanResp.add(temp);
      }
    }
    return ibanResp;
  }

  static getUsersByEmail(String userEmail) {}
}
