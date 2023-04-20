import 'dart:convert';

import '../constants/constants.dart';

class Invoice {
  String invoiceuid;
  Status status;
  String assignieUid;
  String title;
  Invoice({
    required this.invoiceuid,
    required this.status,
    required this.assignieUid,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'invoiceuid': invoiceuid});
    result.addAll({'status': status.toString()});
    result.addAll({'assignieUid': assignieUid});
    result.addAll({'title': title});

    return result;
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      invoiceuid: map['invoiceuid'] ?? '',
      status: Status.values.firstWhere((e) => e.toString() == map['status']),
      assignieUid: map['assignieUid'] ?? '',
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source));
}
