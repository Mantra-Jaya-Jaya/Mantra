import 'package:flutter/material.dart';

class BaseHeaderWidget extends StatelessWidget {
  final String title;
  final bool showBackButton; // Tambahkan parameter untuk tombol kembali
  final bool hasRadius; // Tambahkan parameter untuk kelengkungan bawah

  const BaseHeaderWidget({
    super.key,
    required this.title,
    this.showBackButton =
        false, // Default-nya tidak muncul (seperti halaman pesanan)
    this.hasRadius = false, // Default-nya kotak datar
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Jika ada tombol back, padding atas disesuaikan agar sejajar
      padding: EdgeInsets.fromLTRB(20, showBackButton ? 50 : 60, 20, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFAD510D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(hasRadius ? 30 : 0),
          bottomRight: Radius.circular(hasRadius ? 30 : 0),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
