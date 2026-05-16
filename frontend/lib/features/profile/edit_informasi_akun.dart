import 'package:flutter/material.dart';
import 'package:frontend/features/profile/edit_informasi_akun.dart';

class EditInformasiAkun extends StatefulWidget {
  const EditInformasiAkun({super.key});

  @override
  State<EditInformasiAkun> createState() => _EditInformasiAkunState();
}

class _EditInformasiAkunState extends State<EditInformasiAkun> {
  // ================= CONTROLLER =================
  final TextEditingController namaController = TextEditingController(
    text: "Aarav Lysander",
  );

  final TextEditingController phoneController = TextEditingController(
    text: "+62 89000000000",
  );

  final TextEditingController emailController = TextEditingController(
    text: "lysander@gmail.com",
  );

  final TextEditingController usernameController = TextEditingController(
    text: "@aarav_",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                color: const Color(0xFFAF510C),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "Informasi Akun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

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
                      onPressed: () {
                        // 2. Tunggu sebentar atau langsung kembali ke halaman sebelumnya (Profil)
                        Navigator.pop(context, 'success');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF510C),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
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
