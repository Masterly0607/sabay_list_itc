class AuthService {
  static String? _savedEmail;
  static String? _savedPassword;
  static String? _savedName;

  static void saveCredentials(String email, String password, String name) {
    _savedEmail = email;
    _savedPassword = password;
    _savedName = name;
  }

  static bool verifyCredentials(String email, String password) {
    return _savedEmail == email && _savedPassword == password;
  }

  static void clearCredentials() {
    _savedEmail = null;
    _savedPassword = null;
    _savedName = null;
  }

  static String? get currentUserEmail => _savedEmail;
  static String? get currentUserName => _savedName;
}
