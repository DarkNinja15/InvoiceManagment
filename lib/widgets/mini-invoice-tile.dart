// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:invoice_intern/constants/constants.dart';

Widget miniCard(String title, String assigneeName, Status status) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      tileColor: pinkColor1.withOpacity(0.5),
      title: Text(
        title,
        style: savedStyle.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Assigned to: $assigneeName',
        overflow: TextOverflow.ellipsis,
        style: savedStyle.copyWith(color: Colors.grey),
      ),
      trailing: Text(
        status.toString().substring(7),
        style: savedStyle,
      ),
    ),
  );
}
