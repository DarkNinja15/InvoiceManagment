import 'package:flutter/material.dart';
import 'package:invoice_intern/constants/constants.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: pinkColor1,
      ),
    );
  }
}