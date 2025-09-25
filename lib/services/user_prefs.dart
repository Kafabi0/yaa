import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  // Keys global untuk status login
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyCurrentNik = 'current_nik';

  // ================== SAVE & GET USER BASIC DATA ==================
  static Future<void> saveUser({
    required String email,
    required String nik,
    required String password,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan user dengan prefix NIK (unik per user)
    await prefs.setString('user_${nik}_email', email);
    await prefs.setString('user_${nik}_nik', nik);
    await prefs.setString('user_${nik}_password', password);
    await prefs.setString('user_${nik}_name', name);

    // Set user ini sebagai current login
    await prefs.setString(_keyCurrentNik, nik);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<Map<String, String?>?> getUser(String nik) async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('user_${nik}_email');
    final password = prefs.getString('user_${nik}_password');
    final name = prefs.getString('user_${nik}_name');

    if (email == null || password == null || name == null) return null;

    return {
      'email': email,
      'nik': nik,
      'password': password,
      'name': name,
    };
  }

  static Future<Map<String, String?>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString(_keyCurrentNik);
    if (nik == null) return null;
    return getUser(nik);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ================== HOSPITAL ==================
  static Future<void> setHospital(String nik, String hospital) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${nik}_hospital', hospital);
  }

  static Future<String?> getHospital(String nik) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_${nik}_hospital');
  }

  // ================== PROFILE DATA ==================
  static Future<void> saveProfileData(
    String nik, {
    String? phone,
    String? bpjs,
    String? address,
    String? province,
    String? district,
    String? regency,
    String? village,
    String? rt,
    String? rw,
    String? birthDate,
    String? familyCardNumber,
    String? gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (phone != null) await prefs.setString('user_${nik}_phone', phone);
    if (bpjs != null) await prefs.setString('user_${nik}_bpjs', bpjs);
    if (address != null) await prefs.setString('user_${nik}_address', address);
    if (province != null) await prefs.setString('user_${nik}_province', province);
    if (district != null) await prefs.setString('user_${nik}_district', district);
    if (regency != null) await prefs.setString('user_${nik}_regency', regency);
    if (village != null) await prefs.setString('user_${nik}_village', village);
    if (rt != null) await prefs.setString('user_${nik}_rt', rt);
    if (rw != null) await prefs.setString('user_${nik}_rw', rw);
    if (birthDate != null) await prefs.setString('user_${nik}_birthDate', birthDate);
    if (familyCardNumber != null) await prefs.setString('user_${nik}_familyCardNumber', familyCardNumber);
    if (gender != null) await prefs.setString('user_${nik}_gender', gender);
  }

  static Future<Map<String, String?>> getProfileData(String nik) async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'phone': prefs.getString('user_${nik}_phone'),
      'bpjs': prefs.getString('user_${nik}_bpjs'),
      'address': prefs.getString('user_${nik}_address'),
      'province': prefs.getString('user_${nik}_province'),
      'district': prefs.getString('user_${nik}_district'),
      'regency': prefs.getString('user_${nik}_regency'),
      'village': prefs.getString('user_${nik}_village'),
      'rt': prefs.getString('user_${nik}_rt'),
      'rw': prefs.getString('user_${nik}_rw'),
      'birthDate': prefs.getString('user_${nik}_birthDate'),
      'familyCardNumber': prefs.getString('user_${nik}_familyCardNumber'),
      'gender': prefs.getString('user_${nik}_gender'),
    };
  }

  static Future<Map<String, String?>?> getCompleteUserData(String nik) async {
    final userData = await getUser(nik);
    if (userData == null) return null;

    final profileData = await getProfileData(nik);
    return {...userData, ...profileData};
  }

  static Future<void> updateProfileField(String nik, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${nik}_$key', value);
  }

  // ================== LOGOUT & CLEAR ==================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyCurrentNik);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
