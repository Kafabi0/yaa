import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _keyEmail = 'email';
  static const _keyNik = 'nik';
  static const _keyPassword = 'password';
  static const _keyName = 'name';
  static const _keyIsLoggedIn = 'is_logged_in';

  // Simpan data user (pada saat registrasi / login)
  static Future<void> saveUser({
    required String email,
    required String nik,
    required String password,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyNik, nik);
    await prefs.setString(_keyPassword, password);
    await prefs.setString(_keyName, name);
    await prefs.setBool(_keyIsLoggedIn, true); // simpan status login
  }

  // Ambil data user
  static Future<Map<String, String?>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final nik = prefs.getString(_keyNik);
    final password = prefs.getString(_keyPassword);
    final name = prefs.getString(_keyName);

    if (email == null || nik == null || password == null || name == null) {
      return null; // belum ada user terdaftar
    }

    return {
      'email': email,
      'nik': nik,
      'password': password,
      'name': name,
    };
  }

  // Cek apakah user sedang login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
  static const _keyHospital = 'hospital';

static Future<void> setHospital(String hospital) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyHospital, hospital);
}

static Future<String?> getHospital() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_keyHospital);
}


  // Logout (hapus status login saja, data tetap ada)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
