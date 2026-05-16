import 'package:flutter/material.dart';

class EditAlamat extends StatefulWidget {
  final String labelAwal;
  final String namaAwal;
  final String teleponAwal;
  final String alamatAwal;

  const EditAlamat({
    super.key,
    required this.labelAwal,
    required this.namaAwal,
    required this.teleponAwal,
    required this.alamatAwal,
  });

  @override
  EditAlamatState createState() => EditAlamatState();
}

class EditAlamatState extends State<EditAlamat> {
  late TextEditingController _labelController;
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill dengan data yang sudah ada
    _labelController = TextEditingController(text: widget.labelAwal);
    _namaController = TextEditingController(text: widget.namaAwal);
    _teleponController = TextEditingController(text: widget.teleponAwal);
    _alamatController = TextEditingController(text: widget.alamatAwal);

    _labelController.addListener(_validateForm);
    _namaController.addListener(_validateForm);
    _teleponController.addListener(_validateForm);
    _alamatController.addListener(_validateForm);

    // Sudah ada isi, langsung valid dari awal
    _isFormValid = true;
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

  void _simpan() {
    // Langsung pop dengan data — dialog sukses ditampilkan di profil.dart
    Navigator.pop(context, {
      'label': _labelController.text.trim(),
      'nama': _namaController.text.trim(),
      'telepon': _teleponController.text.trim(),
      'alamat': _alamatController.text.trim(),
    });
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
          "Edit Alamat",
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
                onPressed: _isFormValid ? _simpan : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF510C),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Simpan Perubahan",
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
          decoration: BoxDecoration(
            color: const Color(0xFFD8B08C),
            borderRadius: BorderRadius.circular(8),
          ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFFAF510C)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFFAF510C)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}