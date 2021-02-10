import 'dart:io';

import 'package:intl/intl.dart';

extension StringExtension on String {
  bool get _isNumber => RegExp(r'^[0-9]*$').hasMatch(this);
  String currencyFormat({String currencyName}) => double.tryParse(this) == null ? this :
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: currencyName).format(double.tryParse(this));
}