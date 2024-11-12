import 'package:flutter/material.dart';

class CFGSize {
  static double bodyLRPadding = 25;
  static double bodyTBPadding = 10;
  static double buttonRadius = 8;
  static double tileRadius = 10;

  void init(BuildContext context) {
    bodyLRPadding = MediaQuery.of(context).size.width * 0.07;
    debugPrint('bodyLRPadding: $bodyLRPadding');
  }
}
