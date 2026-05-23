import 'package:flutter/material.dart';

import '../../core/services/profile_service.dart';
import 'package:frontend/core/widgets/base_header_widget.dart';

class EditInformasiAkun extends StatefulWidget {
  final String namaAwal;
  final String teleponAwal;
  final String emailAwal;
  final String usernameAwal;

  const EditInformasiAkun({
    super.key,
    required this.namaAwal,
    required this.teleponAwal,
    required this.emailAwal,
    required this.usernameAwal,
  });

  @override
  State<EditInformasiAkun> createState() => _EditInformasiAkunState();
}

class _EditInformasiAkunState extends State<EditInformasiAkun> {
  // ================= CONTROLLER =================
  late TextEditingController namaController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController usernameController;

  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.namaAwal);
    phoneController = TextEditingController(text: widget.teleponAwal);
    emailController = TextEditingController(text: widget.emailAwal);
    usernameController = TextEditingController(text: widget.usernameAwal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseHeaderWidget(
        title: "Edit Informasi Akun",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),

          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // ================= CARD =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEFEF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // ================= NAMA =================
                  buildTextField(
                    icon: Icons.person_outline,
                    title: "Nama Lengkap",
                    controller: namaController,
                  ),

                  const SizedBox(height: 18),

                  // ================= TELEPON =================
                  buildTextField(
                    icon: Icons.phone,
                    title: "Nomor Telephone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 18),

                  // ================= EMAIL =================
                  buildTextField(
                    icon: Icons.email_outlined,
                    title: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 18),

                  // ================= USERNAME =================
                  buildTextField(
                    icon: Icons.key_outlined,
                    title: "Username",
                    controller: usernameController,
                  ),

                  const SizedBox(height: 30),

                  // ================= BUTTON SIMPAN =================
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            try {
                              await _profileService.updateAkun(
                                namaLengkap: namaController.text,
                                noTelp: phoneController.text,
                                email: emailController.text,
                              );
                              if (mounted) Navigator.pop(context, 'success');
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menyimpan perubahan'),
                                  ),
                                );
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF510C),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                            "Simpan Perubahan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
    );
  }

  // ================= WIDGET TEXTFIELD =================
  Widget buildTextField({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ICON
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD8B08C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon),
        ),

        const SizedBox(width: 12),

        // INPUT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFAF510C)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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
