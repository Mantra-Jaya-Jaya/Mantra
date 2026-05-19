import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/base_header_widget.dart';

import 'services/profile_service.dart';

class EditAlamat extends StatefulWidget {
  final int idAlamat;
  final String labelAwal;
  final String namaAwal;
  final String teleponAwal;
  final String alamatAwal;

  const EditAlamat({
    super.key,
    required this.idAlamat,
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

  final ProfileService _profileService = ProfileService();
  bool _isFormValid = false;
  bool _isLoading = false;

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
      _isFormValid =
          _labelController.text.isNotEmpty &&
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseHeaderWidget(
        title: 'Edit Alamat',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),

          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Label Alamat",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                  _buildInputRow(
                    Icons.person_outline,
                    "Nama Penerima",
                    _namaController,
                    "Aarav",
                  ),
                  const SizedBox(height: 15),
                  _buildInputRow(
                    Icons.phone_outlined,
                    "No. Telepon",
                    _teleponController,
                    "+62...",
                  ),
                  const SizedBox(height: 15),
                  _buildInputRow(
                    Icons.location_on_outlined,
                    "Alamat Lengkap",
                    _alamatController,
                    "Detail alamat...",
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            // Tombol Simpan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_isLoading
                      ? () async {
                          setState(() => _isLoading = true);
                          try {
                            await _profileService.updateAlamat(
                              widget.idAlamat,
                              label: _labelController.text,
                              nama: _namaController.text,
                              telepon: _teleponController.text,
                              alamatLengkap: _alamatController.text,
                            );
                            if (mounted) Navigator.pop(context, true);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal menyimpan alamat'),
                                ),
                              );
                              setState(() => _isLoading = false);
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAF510C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildInputRow(
    IconData icon,
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
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
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
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
