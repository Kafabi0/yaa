import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  // Keys untuk data dasar
  static const _keyEmail = 'email';
  static const _keyNik = 'nik';
  static const _keyPassword = 'password';
  static const _keyName = 'name';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyHospital = 'hospital';
  
  // Keys untuk data profil tambahan
  static const _keyPhone = 'phone';
  static const _keyBpjs = 'bpjs';
  static const _keyAddress = 'address';
  static const _keyProvince = 'province';
  static const _keyDistrict = 'district';
  static const _keyRegency = 'regency';
  static const _keyVillage = 'village';
  static const _keyRt = 'rt';
  static const _keyRw = 'rw';
  static const _keyBirthDate = 'birthDate';
  static const _keyFamilyCardNumber = 'familyCardNumber';
  static const _keyGender = 'gender';

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

  // Hospital methods
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

  // ================== METHODS UNTUK DATA PROFIL TAMBAHAN ==================

  // Simpan data profil lengkap
  static Future<void> saveProfileData({
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
    
    if (phone != null) await prefs.setString(_keyPhone, phone);
    if (bpjs != null) await prefs.setString(_keyBpjs, bpjs);
    if (address != null) await prefs.setString(_keyAddress, address);
    if (province != null) await prefs.setString(_keyProvince, province);
    if (district != null) await prefs.setString(_keyDistrict, district);
    if (regency != null) await prefs.setString(_keyRegency, regency);
    if (village != null) await prefs.setString(_keyVillage, village);
    if (rt != null) await prefs.setString(_keyRt, rt);
    if (rw != null) await prefs.setString(_keyRw, rw);
    if (birthDate != null) await prefs.setString(_keyBirthDate, birthDate);
    if (familyCardNumber != null) await prefs.setString(_keyFamilyCardNumber, familyCardNumber);
    if (gender != null) await prefs.setString(_keyGender, gender);
  }

  // Ambil data profil lengkap
  static Future<Map<String, String?>> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'phone': prefs.getString(_keyPhone),
      'bpjs': prefs.getString(_keyBpjs),
      'address': prefs.getString(_keyAddress),
      'province': prefs.getString(_keyProvince),
      'district': prefs.getString(_keyDistrict),
      'regency': prefs.getString(_keyRegency),
      'village': prefs.getString(_keyVillage),
      'rt': prefs.getString(_keyRt),
      'rw': prefs.getString(_keyRw),
      'birthDate': prefs.getString(_keyBirthDate),
      'familyCardNumber': prefs.getString(_keyFamilyCardNumber),
      'gender': prefs.getString(_keyGender),
    };
  }

  // Ambil semua data user + profil
  static Future<Map<String, String?>?> getCompleteUserData() async {
    final userData = await getUser();
    if (userData == null) return null;
    
    final profileData = await getProfileData();
    
    // Gabungkan kedua map
    return {...userData, ...profileData};
  }

  // Update specific field
  static Future<void> updateProfileField(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Methods untuk field individual (opsional, untuk kemudahan)
  static Future<void> setPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, phone);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhone);
  }

  static Future<void> setBpjs(String bpjs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBpjs, bpjs);
  }

  static Future<String?> getBpjs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBpjs);
  }

  // ... dst untuk field lainnya jika diperlukan

  // Clear all data (untuk logout lengkap atau reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}