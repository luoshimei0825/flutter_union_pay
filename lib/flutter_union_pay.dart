import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_union_pay/enum/union_pay_enum.dart';

import 'model/payment_result_model.dart';

class FlutterUnionPay {
  static const _METHOD_CHANNEL_NAME = 'flutter_union_pay';
  static const _MESSAGE_CHANNEL_NAME = 'flutter_union_pay.message';

  static const MethodChannel _channel = const MethodChannel(_METHOD_CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('version');
    return version;
  }

  static Future<bool> get isPaymentAppInstalled async {
    return await _channel.invokeMethod('isPaymentAppInstalled');
  }

  /// 支付
  /// @param tn 订单号
  /// @param mode 环境
  /// @param scheme ios scheme, 需在info.plist中添加
  static Future<bool> pay({
    @required String tn,
    @required PaymentMode mode,
    String scheme,
  }) async {
    return await _channel.invokeMethod('pay', {
      'tn': tn,
      'mode': _getModeString(mode),
      'scheme': scheme,
    });
  }

  /// 监听支付状态
  static void listen(Function(PaymentResult result) onListener) {
    var channel = BasicMessageChannel(_MESSAGE_CHANNEL_NAME, StringCodec());
    channel.setMessageHandler((message) => onListener(PaymentResult.fromJson(message)));
  }

  static String _getModeString(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.product:
        return "00";
        break;
      case PaymentMode.development:
        return "01";
        break;
    }
    return "00";
  }
}
