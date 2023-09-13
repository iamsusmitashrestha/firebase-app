class ValidatorService {
  static String? validateFullName(String? fullName) {
    RegExp regex = RegExp(r"^[A-Z][a-z]*\s[A-Z][a-z]*$");

    if (fullName == null || fullName.isEmpty) {
      return "Please enter full name";
    }
    if (!regex.hasMatch(fullName)) return "Invalid full name";
    return null;
  }

  static String? validateEmail(String? email) {
    RegExp regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email == null || email.isEmpty) {
      return "Please enter email";
    }
    if (!regex.hasMatch(email)) return "Invalid email";
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter password";
    }

    if (password.length < 8) {
      return "Password must have 8 characters";
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return "Password must have uppercase";
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return "Password must have digits";
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return "Password must have lowercase";
    }
    if (!password.contains(RegExp(r'[#?!@$%^&*-]'))) {
      return "Password must have special characters";
    }
    return null;
  }
}
