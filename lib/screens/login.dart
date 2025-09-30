import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inocare/screens/home_page_member.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../main.dart';

// =================================== LOGIN ===================================
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static String? registertedWhatsapp;
  static String? registeredNik;
  static String? registeredPassword;
  static String? registeredName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentNik = prefs.getString('current_nik');

    if (currentNik != null) {
      setState(() {
        registertedWhatsapp = prefs.getString('user_${currentNik}_whatsapp');
        registeredNik = prefs.getString('user_${currentNik}_nik');
        registeredPassword = prefs.getString('user_${currentNik}_password');
        registeredName = prefs.getString('user_${currentNik}_name');
      });
    }
  }

  @override
  void dispose() {
    _whatsappController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showOTPModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OTPModal(
          onOTPVerified: () async {
            await UserPrefs.saveUser(
              whatsapp: registertedWhatsapp!,
              nik: registeredNik!,
              password: registeredPassword!,
              name: registeredName!,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePageMember()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFF7F50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 100),
          bottomRight: Radius.elliptical(200, 100),
        ),
      ),
      child: const Center(
        child: Text(
          'Digital Hospital',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 2,
            fontFamily: 'KolkerBrush',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Text(
            'MASUK',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          _buildTextField(
            controller: _whatsappController,
            hintText: 'whatsapp/NIK',
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
          ),
          const SizedBox(height: 40),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool isNik = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNik ? TextInputType.number : TextInputType.text,
        inputFormatters: isNik
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ]
            : [],
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: () async {
          final whatsappOrNik = _whatsappController.text.trim();
          final password = _passwordController.text.trim();

          if (whatsappOrNik.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Whatsapp/NIK dan Password harus diisi!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final prefs = await SharedPreferences.getInstance();
          String? currentNik;

          for (String key in prefs.getKeys()) {
            if (key.startsWith("user_") && key.endsWith("_nik")) {
              final nik = prefs.getString(key);
              if (nik != null) {
                final whatsapp = prefs.getString('user_${nik}_whatsapp');
                final pass = prefs.getString('user_${nik}_password');

                if ((whatsappOrNik == nik || whatsappOrNik == whatsapp) &&
                    password == pass) {
                  currentNik = nik;
                  break;
                }
              }
            }
          }

          if (currentNik != null) {
            await prefs.setString('current_nik', currentNik);
            
            setState(() {
              registertedWhatsapp = prefs.getString('user_${currentNik}_whatsapp');
              registeredNik = currentNik;
              registeredPassword = prefs.getString('user_${currentNik}_password');
              registeredName = prefs.getString('user_${currentNik}_name');
            });
            
            _showOTPModal();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Whatsapp/NIK atau Password salah!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Masuk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum Punya Akun? ',
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: const Text(
            'Daftar disini',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class OTPModal extends StatefulWidget {
  final VoidCallback onOTPVerified;

  const OTPModal({Key? key, required this.onOTPVerified}) : super(key: key);

  @override
  State<OTPModal> createState() => _OTPModalState();
}

class _OTPModalState extends State<OTPModal> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;
  int _countdown = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
      _isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOTPChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      _verifyOTP(otp);
    }
  }

  void _verifyOTP(String otp) {
    if (otp == "123456") {
      Navigator.pop(context);
      widget.onOTPVerified();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP tidak valid. Silakan coba lagi.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _resendOTP() {
    if (_isResendEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP telah dikirim ulang ke WhatsApp Anda.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Verifikasi OTP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 20, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF25D366).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, size: 40, color: Color(0xFF25D366)),
            ),
            SizedBox(height: 16),
            Text(
              'Kode verifikasi telah dikirim melalui WhatsApp ke nomor terdaftar Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _otpControllers[index].text.isEmpty
                          ? Colors.grey[300]!
                          : Color(0xFFFF8C00),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (value) => _onOTPChanged(value, index),
                  ),
                );
              }),
            ),
            SizedBox(height: 24),
            if (!_isResendEnabled)
              Text(
                'Kirim ulang kode dalam $_countdown detik',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              )
            else
              GestureDetector(
                onTap: _resendOTP,
                child: Text(
                  'Kirim Ulang Kode OTP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF8C00),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String otp = _otpControllers
                      .map((controller) => controller.text)
                      .join();
                  if (otp.length == 6) {
                    _verifyOTP(otp);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Silakan masukkan kode OTP lengkap.'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8C00),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Verifikasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Gunakan kode "123456" untuk testing',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================== REGISTER ===================================
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFF7F50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 100),
          bottomRight: Radius.elliptical(200, 100),
        ),
      ),
      child: const Center(
        child: Text(
          'Digital Hospital',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 2,
            fontFamily: 'KolkerBrush',
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Text(
            'DAFTAR',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          _buildTextField(controller: _nameController, hintText: 'Nama'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _nikController,
            hintText: 'NIK',
            isNik: true,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _whatsappController,
            hintText: 'No Whatsapp',
          ),
          const SizedBox(height: 40),
          _buildRegisterButton(),
          const SizedBox(height: 20),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isNik = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNik ? TextInputType.number : TextInputType.text,
        inputFormatters: isNik
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ]
            : [],
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_nameController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nama harus diisi'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (_nikController.text.length != 16) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('NIK harus tepat 16 digit'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (_whatsappController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No WhatsApp harus diisi'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final prefs = await SharedPreferences.getInstance();
          final existingNik = prefs.getString('user_${_nikController.text.trim()}_nik');
          
          if (existingNik != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('NIK sudah terdaftar!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivationPage(
                whatsapp: _whatsappController.text.trim(),
                nik: _nikController.text.trim(),
                name: _nameController.text.trim(),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Daftar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah Punya Akun? ',
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Masuk disini',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// =================================== AKTIVASI ===================================
class ActivationPage extends StatefulWidget {
  final String whatsapp;
  final String nik;
  final String name;

  const ActivationPage({
    Key? key,
    required this.whatsapp,
    required this.nik,
    required this.name,
  }) : super(key: key);

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData(
    String whatsapp,
    String nik,
    String password,
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('user_${nik}_whatsapp', whatsapp);
    await prefs.setString('user_${nik}_nik', nik);
    await prefs.setString('user_${nik}_password', password);
    await prefs.setString('user_${nik}_name', name);
    await prefs.setString('current_nik', nik);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            _buildActivationForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFF7F50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 100),
          bottomRight: Radius.elliptical(200, 100),
        ),
      ),
      child: const Center(
        child: Text(
          'Digital Hospital',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 2,
            fontFamily: 'KolkerBrush',
          ),
        ),
      ),
    );
  }

  Widget _buildActivationForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Text(
            'AKTIVASI AKUN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          _buildTextField(controller: _tokenController, hintText: 'Token'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _confirmPasswordController,
            hintText: 'Konfirmasi Password',
            isPassword: true,
          ),
          const SizedBox(height: 40),
          _buildActivationButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildActivationButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_tokenController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Token harus diisi'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (_passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password harus diisi'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password tidak cocok'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          await _saveUserData(
            widget.whatsapp,
            widget.nik,
            _passwordController.text,
            widget.name,
          );

          _LoginPageState.registertedWhatsapp = widget.whatsapp;
          _LoginPageState.registeredNik = widget.nik;
          _LoginPageState.registeredPassword = _passwordController.text;
          _LoginPageState.registeredName = widget.name;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun berhasil diaktivasi! Silakan login.'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Aktivasi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}