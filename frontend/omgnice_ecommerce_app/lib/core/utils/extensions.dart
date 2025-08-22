extension StringExtensions on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    return this.length >= 8;
  }

  bool get isValidPhone {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(this);
  }
}