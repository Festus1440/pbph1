import 'dart:io';

import 'package:intl/intl.dart';

extension StringExtension on String {
  bool get isNumber => RegExp(r'^[0-9]*$').hasMatch(this);
  String currencyFormat({String currencyName}) => !this.isNumber ? this :
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: currencyName).format(double.tryParse(this));
}