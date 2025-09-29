import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  // Keys global untuk status login
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyCurrentNik = 'current_nik';

  // ================== SELECTED HOSPITAL ==================
// static Future<void> setSelectedHospital(String nik, Map<String, dynamic> hospitalData) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('user_${nik}_selected_hospital_name', hospitalData['name']);
//   await prefs.setString('user_${nik}_selected_hospital_address', hospitalData['address']);
//   await prefs.setString('user_${nik}_selected_hospital_phone', hospitalData['phone']);
//   await prefs.setString('user_${nik}_selected_hospital_distance', hospitalData['distance']);
//   await prefs.setDouble('user_${nik}_selected_hospital_rating', hospitalData['rating']);
//   await prefs.setInt('user_${nik}_selected_hospital_reviewCount', hospitalData['reviewCount']);
//   await prefs.setBool('user_${nik}_selected_hospital_isOpen', hospitalData['isOpen']);
//   await prefs.setString('user_${nik}_selected_hospital_imagePath', hospitalData['imagePath']);
//   await prefs.setString('user_${nik}_selected_hospital_operatingHours', hospitalData['operatingHours']);
//   await prefs.setString('user_${nik}_selected_hospital_type', hospitalData['type']);
//   await prefs.setString('user_${nik}_selected_hospital_services', hospitalData['services'].join(','));
//   await prefs.setString('user_${nik}_selected_hospital_specialties', hospitalData['specialties'].join(','));
// }

// static Future<Map<String, dynamic>?> getSelectedHospital(String nik) async {
//   final prefs = await SharedPreferences.getInstance();
  
//   final name = prefs.getString('user_${nik}_selected_hospital_name');
//   if (name == null) return null;
  
//   return {
//     'name': name,
//     'address': prefs.getString('user_${nik}_selected_hospital_address') ?? '',
//     'phone': prefs.getString('user_${nik}_selected_hospital_phone') ?? '',
//     'distance': prefs.getString('user_${nik}_selected_hospital_distance') ?? '',
//     'rating': prefs.getDouble('user_${nik}_selected_hospital_rating') ?? 0.0,
//     'reviewCount': prefs.getInt('user_${nik}_selected_hospital_reviewCount') ?? 0,
//     'isOpen': prefs.getBool('user_${nik}_selected_hospital_isOpen') ?? false,
//     'imagePath': prefs.getString('user_${nik}_selected_hospital_imagePath') ?? '',
//     'operatingHours': prefs.getString('user_${nik}_selected_hospital_operatingHours') ?? '',
//     'type': prefs.getString('user_${nik}_selected_hospital_type') ?? '',
//     'services': prefs.getString('user_${nik}_selected_hospital_services')?.split(',') ?? [],
//     'specialties': prefs.getString('user_${nik}_selected_hospital_specialties')?.split(',') ?? [],
//   };
// }

  // ================== SAVE & GET USER BASIC DATA ==================
  static Future<void> saveUser({
    // required String email,
    required String whatsapp,
    required String nik,
    required String password,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan user dengan prefix NIK (unik per user)
    await prefs.setString('user_${nik}_whatsapp', whatsapp);
    await prefs.setString('user_${nik}_nik', nik);
    await prefs.setString('user_${nik}_password', password);
    await prefs.setString('user_${nik}_name', name);

    // Set user ini sebagai current login
    await prefs.setString(_keyCurrentNik, nik);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<Map<String, String?>?> getUser(String nik) async {
    final prefs = await SharedPreferences.getInstance();

    final whatsapp = prefs.getString('user_${nik}_whatsapp');
    final password = prefs.getString('user_${nik}_password');
    final name = prefs.getString('user_${nik}_name');

    if (whatsapp == null || password == null || name == null) return null;

    return {
      'whatsapp': whatsapp,
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
  // ================== AMBIL SEMUA USER ==================
static Future<List<Map<String, String>>> getAllUsers() async {
  final prefs = await SharedPreferences.getInstance();
  List<Map<String, String>> users = [];

  for (String key in prefs.getKeys()) {
    if (key.startsWith("user_") && key.endsWith("_nik")) {
      final nik = prefs.getString(key);
      if (nik != null) {
        final whatsapp = prefs.getString('user_${nik}_whatsapp') ?? '';
        final name = prefs.getString('user_${nik}_name') ?? '';
        users.add({"nik": nik, "whatsapp": whatsapp, "name": name});
      }
    }
  }

  return users;
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

  // ================== MULTI USER SUPPORT ==================
  static Future<Map<String, String?>?> getUserByWhatsappOrNik(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('user_') && key.endsWith('_whatsapp')) {
        final nik = key.split('_')[1];
        final user = await getUser(nik);

        if (user != null &&
            (user['whatsapp'] == value || user['nik'] == value)) {
          return user;
        }
      }
    }
    return null;
  }

  static Future<void> setCurrentUser(String nik) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentNik, nik);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // static Future<List<Map<String, String?>>> getAllUsers() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();

  //   final Set<String> niks = {};
  //   for (var key in keys) {
  //     if (key.startsWith('user_') && key.endsWith('_email')) {
  //       niks.add(key.split('_')[1]);
  //     }
  //   }

  //   final users = <Map<String, String?>>[];
  //   for (var nik in niks) {
  //     final user = await getUser(nik);
  //     if (user != null) users.add(user);
  //   }
  //   return users;
  // }

  static Future<void> removeUser(String nik) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('user_${nik}_')) {
        await prefs.remove(key);
      }
    }

    // Jika user yang dihapus adalah current, logout otomatis
    final currentNik = prefs.getString(_keyCurrentNik);
    if (currentNik == nik) {
      await logout();
    }
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
