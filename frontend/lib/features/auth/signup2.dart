import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/api_error.dart';
import 'services/auth_service.dart';
import 'package:frontend/features/auth/login.dart';

class Signup2 extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  const Signup2({super.key, required this.email, required this.username, required this.password});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  bool _isFormValid = false;
  bool _isLoading = false;
  late final AuthService _authService;

  String? _namaError;
  String? _alamatError;
  String? _telpError;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ApiClient().dio, const FlutterSecureStorage());
    _namaController.addListener(_validateForm);
    _alamatController.addListener(_validateForm);
    _telpController.addListener(_validateForm);
  }

  void _validateForm() {
    final nama = _namaController.text;
    final alamat = _alamatController.text;
    final telp = _telpController.text;

    setState(() {
      if (nama.isNotEmpty && nama.trim().isEmpty) {
        _namaError = "Nama tidak boleh kosong";
      } else {
        _namaError = null;
      }

      if (alamat.isNotEmpty && alamat.trim().isEmpty) {
        _alamatError = "Alamat tidak boleh kosong";
      } else {
        _alamatError = null;
      }

      if (telp.isNotEmpty && (!RegExp(r'^[0-9]+$').hasMatch(telp) || telp.length < 10)) {
        _telpError = "Nomor telepon harus angka & minimal 10 digit";
      } else {
        _telpError = null;
      }

      _isFormValid = nama.trim().isNotEmpty && _namaError == null &&
                     alamat.trim().isNotEmpty && _alamatError == null &&
                     telp.isNotEmpty && _telpError == null;
    });
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    try {
      await _authService.register(
        username: widget.username,
        email: widget.email,
        password: widget.password,
        konfirmasiPassword: widget.password,
        namaLengkap: _namaController.text,
        noTelp: _telpController.text,
      );
      if (!mounted) return;
      _showSuccessDialog(context);
    } on DioException catch (e) {
      final apiError = ApiError.fromDioException(e);
      _showError(apiError.userMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB45309),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Image.asset(
                      'assets/images/logo_putih_notext.png',
                      width: 80,
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepItem(
                                  Icons.check,
                                  "Create Account",
                                  true,
                                ),
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: const Color(0xFFB45309),
                                ),
                                _buildStepItem(
                                  null,
                                  "Fill Your Identity",
                                  true,
                                  number: "2",
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _buildTextField(
                              controller: _namaController,
                              label: 'Nama',
                              hint: 'Nama Lengkap',
                              errorText: _namaError,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _alamatController,
                              label: 'Alamat',
                              hint: 'Alamat Lengkap',
                              maxLines: 3,
                              errorText: _alamatError,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _telpController,
                              label: 'Nomor Telepon',
                              hint: '08xxxx',
                              errorText: _telpError,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFB45309),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color(0xFFB45309),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isFormValid && !_isLoading ? _handleRegister : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isFormValid
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFFCBD5E1),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading ? const SizedBox(height:24, width:24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Log in",
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem(
    IconData? icon,
    String label,
    bool isActive, {
    String? number,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFB45309),
          child: icon != null
              ? Icon(icon, size: 20, color: Colors.white)
              : Text(number!, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB45309),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB45309)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB45309)),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User wajib klik tombol OK
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon Person/User sesuai desain di gambar
                const Icon(
                  Icons.person_outline,
                  size: 60,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(height: 15),

                // Judul Notifikasi
                const Text(
                  'Pendaftaran Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 10),

                // Pesan Sub-judul
                const Text(
                  'Akun siap digunakan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),

                // Keterangan Tambahan
                const Text(
                  'Silahkan lakukan login dengan akun Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 25),

                // Tombol OK untuk ke Login
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // 1. Tutup dialognya dulu
                      Navigator.of(context).pop();

                      // 2. Pindah ke halaman Login dan hapus history navigasi pendaftaran
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45309),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
