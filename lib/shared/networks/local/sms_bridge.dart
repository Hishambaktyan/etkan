import 'package:flutter/services.dart';

class SmsBridge {
  static const MethodChannel _channel = MethodChannel('sms_sender');

  static Future<bool> sendSms({
    required String phone,
    required String message,
  }) async {
    final result = await _channel.invokeMethod<bool>('sendSms', {
      'phone': phone,
      'message': message,
    });
    return result ?? false;
  }
}