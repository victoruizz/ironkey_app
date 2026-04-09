import 'dart:math';

import 'package:ironkey/password_generator.dart';

class StandardPasswordGenerator implements PasswordGenerator {
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;
  StandardPasswordGenerator({
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
  });
  @override
  String generate(int length) {
    final buffer = StringBuffer();
    if (includeUppercase) buffer.write('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (includeLowercase) buffer.write('abcdefghijklmnopqrstuvwxyz');
    if (includeNumbers) buffer.write('0123456789');
    if (includeSymbols) buffer.write('!@#\$%&*()_-+=<>?');
    final chars = buffer.toString();
    if (chars.isEmpty) return '';
    final random = Random();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
