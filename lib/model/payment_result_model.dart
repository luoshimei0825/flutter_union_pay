import 'dart:convert';

import 'package:flutter_union_pay/enum/union_pay_enum.dart';

class PaymentResult {
  int _status = 0;
  PaymentResultStatus get status => PaymentResultStatus.values[_status];
  PaymentResult.fromJson(String e) {
    dynamic json = jsonDecode(e);
    this._status = json['status'];
  }
}