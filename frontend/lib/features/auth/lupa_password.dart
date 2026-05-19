import 'package:flutter/material.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  bool _isFormValid = false;
  bool _isSent = false;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isFormValid = _emailController.text.trim().isNotEmpty &&
            _emailController.text.contains('@');
      });
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _kirimEmail() async {
    setState(() => _isLoading = true);
    // Simulasi delay — nanti ganti dengan call API
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isSent = true;
    });
    // Animasi ulang untuk halaman sukses
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAF510C),
      body: SafeArea(
        child: Stack(
          children: [
            // ===== BACKGROUND DEKORATIF =====
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // ===== KONTEN UTAMA =====
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _isSent ? _buildSuksesView() : _buildFormView(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FORM VIEW (Langkah 1 & 2) =====
  Widget _buildFormView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== TOMBOL BACK (Di dalam kotak putih) =====
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFAF510C),
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Back",
                    style: TextStyle(
                      color: Color(0xFFAF510C),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Judul
          const Text(
            "Lupa Password?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFAF510C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Jangan khawatir, kami akan mengirimkan\npetunjuknya ke email Anda segera.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFAF510C),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Input Email (Dengan Border Oranye Tipis)
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              // Border default saat tidak fokus (Oranye tipis)
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFAF510C), width: 1.0),
              ),
              // Border saat kolom di-klik/fokus
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFAF510C), width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Kirimkan (Gaya Outlined / Border Oranye)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: _isFormValid && !_isLoading ? _kirimEmail : null,
              style: OutlinedButton.styleFrom(
                // Warna background tombol saat aktif / disabled
                backgroundColor: _isFormValid && !_isLoading ? Colors.white : Colors.grey.shade100,
                // Border warna oranye saat tombol aktif
                side: BorderSide(
                  color: _isFormValid && !_isLoading ? const Color(0xFFAF510C) : Colors.grey.shade300,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Color(0xFFAF510C),
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Kirimkan",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAF510C),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== SUKSES VIEW (Langkah 4) =====
  Widget _buildSuksesView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          // Icon sukses
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFAEDE4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              color: Color(0xFFAF510C),
              size: 48,
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "We've sent it!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Check your email for the instruction!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Back to Login
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF510C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Back to Login Page",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}