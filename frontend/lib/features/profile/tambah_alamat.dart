import 'package:flutter/material.dart';

class AlamatBaru extends StatefulWidget {
  const AlamatBaru({super.key});

  @override
  AlamatBaruState createState() => AlamatBaruState();
}

class AlamatBaruState extends State<AlamatBaru> {
  // Controller untuk memantau isi textfield
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Listener untuk validasi real-time
    _labelController.addListener(_validateForm);
    _namaController.addListener(_validateForm);
    _teleponController.addListener(_validateForm);
    _alamatController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _labelController.text.isNotEmpty &&
          _namaController.text.isNotEmpty &&
          _teleponController.text.isNotEmpty &&
          _alamatController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x33AF510C),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFFAF510C), size: 42),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Alamat berhasil\ndisimpan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFAF510C), fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Alamat baru Anda telah\nberhasil ditambahkan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context, 'success'); // Kembali ke Profil dengan status success
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF510C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          "Alamat Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Label Alamat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildField("Contoh: Rumah / Kantor", _labelController),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEFEF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildInputRow(Icons.person_outline, "Nama Penerima", _namaController, "Aarav"),
                  const SizedBox(height: 15),
                  _buildInputRow(Icons.phone_outlined, "No. Telepon", _teleponController, "+62..."),
                  const SizedBox(height: 15),
                  _buildInputRow(Icons.location_on_outlined, "Alamat Lengkap", _alamatController, "Detail alamat...", maxLines: 3),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFormValid ? () {
                  Navigator.pop(context, 'success');
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF510C),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Simpan Alamat",
                  style: TextStyle(
                    color: _isFormValid ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFAF510C)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFAF510C), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildInputRow(IconData icon, String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFD8B08C), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 5),
              TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hint,
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Color(0xFFAF510C))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Color(0xFFAF510C))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}