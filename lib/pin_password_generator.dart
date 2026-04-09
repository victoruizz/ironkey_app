import 'dart:math';

import 'package:ironkey/password_generator.dart';

class PinPasswordGenerator implements PasswordGenerator {
  @override
  String generate(int length) {
    const digits = '0123456789';

    final random = Random();

    return List.generate(
      length, 
      (_) => digits[random.nextInt(digits.length)]).join();
    
  }
}