import 'package:flutter/material.dart';

class AppConstant {
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale("en", "US");
  static const ES_LOCALE = Locale("es", "ES");
  static const DE_LOCALE = Locale("de", "DE");
  static const LANG_PATH = "assets/lang";

  static const List<Locale> SUPPORTED_LOCALE = [
    AppConstant.EN_LOCALE,
    AppConstant.TR_LOCALE,
    AppConstant.DE_LOCALE,
    AppConstant.ES_LOCALE,
  ];
}
