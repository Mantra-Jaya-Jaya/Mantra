import 'package:flutter/material.dart';

class UbahPassword extends StatefulWidget {
  const UbahPassword({super.key});

  @override
  UbahPasswordState createState() => UbahPasswordState();
}

class UbahPasswordState extends State<UbahPassword> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isFormValid = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _oldPassController.addListener(_validateForm);
    _newPassController.addListener(_validateForm);
    _confirmPassController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _oldPassController.text.isNotEmpty &&
          _newPassController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAF510C),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 36),
        child: Column(
          children: [
            // Container Input Field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFEAEFEF),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildField("Password Lama", _oldPassController, _obscureOld, 
                      () => setState(() => _obscureOld = !_obscureOld)),
                  const SizedBox(height: 15),
                  _buildField("Password Baru", _newPassController, _obscureNew, 
                      () => setState(() => _obscureNew = !_obscureNew)),
                  const SizedBox(height: 15),
                  _buildField("Konfirmasi Password", _confirmPassController, _obscureConfirm, 
                      () => setState(() => _obscureConfirm = !_obscureConfirm)),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // Link Lupa Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Lupa Password",
                  style: TextStyle(color: Color(0xFFAF510C), fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),
            
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isFormValid 
                  ? () => Navigator.pop(context, true) 
                  : null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF510C),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Simpan Password",
                  style: TextStyle(
                    color: _isFormValid ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ================= SYARAT PASSWORD =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E7DD), // Warna krem kecoklatan lembut
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD8B08C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Syarat Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  _buildRequirementItem("1. Min. 8 karakter"),
                  _buildRequirementItem("2. Kombinasi huruf & angka"),
                  _buildRequirementItem("3. Tidak sama dengan password lama"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, bool obscure, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20),
              onPressed: toggle,
              color: const Color(0xFFAF510C),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFAF510C)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFAF510C), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}