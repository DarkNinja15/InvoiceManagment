import 'dart:convert';

import '../constants/constants.dart';

class MiniInvoice {
  String miniInvoiceUid;
  String invoiceUid;
  String assignieUid;
  Status status;
  String title;
  MiniInvoice({
    required this.miniInvoiceUid,
    required this.invoiceUid,
    required this.assignieUid,
    required this.status,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'miniInvoiceUid': miniInvoiceUid});
    result.addAll({'invoiceUid': invoiceUid});
    result.addAll({'assignieUid': assignieUid});
    result.addAll({'status': status.toString()});
    result.addAll({'title': title});

    return result;
  }

  factory MiniInvoice.fromMap(Map<String, dynamic> map) {
    return MiniInvoice(
      miniInvoiceUid: map['miniInvoiceUid'] ?? '',
      invoiceUid: map['invoiceUid'] ?? '',
      assignieUid: map['assignieUid'] ?? '',
      status: Status.values.firstWhere((e) => e.toString() == map['status']),
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MiniInvoice.fromJson(String source) =>
      MiniInvoice.fromMap(json.decode(source));
}
