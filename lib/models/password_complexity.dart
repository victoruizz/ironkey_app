enum PasswordComplexity { low, medium, high }

extension PasswordComplexityExtension on PasswordComplexity {
  String get title {
    switch (this) {
      case PasswordComplexity.low:
        return 'Baixa';
      case PasswordComplexity.medium:
        return 'Média';
      case PasswordComplexity.high:
        return 'Alta';
    }
  }

  int get minLength {
    switch (this) {
      case PasswordComplexity.low:
        return 4;
      case PasswordComplexity.medium:
        return 8;
      case PasswordComplexity.high:
        return 16;
    }
  }

  int get maxLength {
    switch (this) {
      case PasswordComplexity.low:
        return 6;
      case PasswordComplexity.medium:
        return 12;
      case PasswordComplexity.high:
        return 32;
    }
  }
}