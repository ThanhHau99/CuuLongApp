class Validation {
  static isEmailValid(String email) {
    final regexEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regexEmail.hasMatch(email);
  }

  static isPassValid(String pass) {
    return pass.length > 6;
  }

  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone);
  }

  static isName(String name) {
    return name != null;
  }

  static isnumberValid(String number) {
    final regexNumber = RegExp(r'^[0-9]+\.+[0-9]');
    return regexNumber.hasMatch(number);
  }
}
