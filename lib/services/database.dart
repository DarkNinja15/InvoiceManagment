import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:invoice_intern/models/invoice_model.dart';
import 'package:invoice_intern/models/user_model.dart' as us;

import '../constants/constants.dart';
import '../models/mini_invoice_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(us.User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Stream<List<us.User>> get allusers {
    return _firestore
        .collection('users')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => us.User(
                  email: (documentSnapshot.data()!
                      as Map<String, dynamic>)['email'],
                  uid:
                      (documentSnapshot.data()! as Map<String, dynamic>)['uid'],
                  name: (documentSnapshot.data()!
                      as Map<String, dynamic>)['name'],
                ))
            .toList());
  }

  Stream<List<Invoice>> get invoice {
    return _firestore
        .collection('invoices')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Invoice(
                  title: (documentSnapshot.data()!
                      as Map<String, dynamic>)['title'],
                  invoiceuid: (documentSnapshot.data()!
                      as Map<String, dynamic>)['invoiceUid'],
                  assignieUid: (documentSnapshot.data()!
                      as Map<String, dynamic>)['assignieUid'],
                  status: Status.values.firstWhere((e) =>
                      e.toString() ==
                      (documentSnapshot.data()!
                          as Map<String, dynamic>)['status']),
                ))
            .toList());
  }

  Stream<List<MiniInvoice>> get miniinvoice {
    return _firestore
        .collection('miniinvoices')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => MiniInvoice(
                  title: (documentSnapshot.data()!
                      as Map<String, dynamic>)['title'],
                  miniInvoiceUid: (documentSnapshot.data()!
                      as Map<String, dynamic>)['miniInvoiceUid'],
                  assignieUid: (documentSnapshot.data()!
                      as Map<String, dynamic>)['assignieUid'],
                  status: Status.values.firstWhere((e) =>
                      e.toString() ==
                      (documentSnapshot.data()!
                          as Map<String, dynamic>)['status']),
                  invoiceUid: (documentSnapshot.data()!
                      as Map<String, dynamic>)['invoiceUid'],
                ))
            .toList());
  }

  Future<bool> addInvoice(String invoiceName, String invoiceUid,
      String assignieUid, List<MiniInvoice> miniInvoices, Status status) async {
    try {
      await _firestore.collection('invoices').doc(invoiceUid).set({
        'title': invoiceName,
        'invoiceUid': invoiceUid,
        'assignieUid': assignieUid,
        'status': status.toString(),
      });
      for (var miniInvoice in miniInvoices) {
        await _firestore
            .collection('miniinvoices')
            .doc(miniInvoice.miniInvoiceUid)
            .set(miniInvoice.toMap());
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
