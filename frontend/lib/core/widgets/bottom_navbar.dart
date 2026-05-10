import 'package:flutter/material.dart';

// Model untuk menampung data menu
class NavMenuModel {
  final String label;
  final IconData icon;
  final int index;

  NavMenuModel({required this.label, required this.icon, required this.index});
}

// Logika untuk mengatur posisi Notch secara dinamis
class DynamicFabLocation extends FloatingActionButtonLocation {
  final double xOffset;
  const DynamicFabLocation(this.xOffset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    double y = scaffoldGeometry.contentBottom - (fabHeight / 2);
    return Offset(xOffset, y);
  }
}

// Komponen Widget Utama
class CustomDynamicNavbar extends StatelessWidget {
  final int currentIndex;
  final List<NavMenuModel> menus;
  final Function(int) onTap;

  const CustomDynamicNavbar({
    super.key,
    required this.currentIndex,
    required this.menus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFAD510D),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: menus.map((menu) {
            bool isActive = currentIndex == menu.index;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(menu.index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Jika aktif, beri ruang kosong karena ikon ada di FAB (di atasnya)
                    if (isActive) const SizedBox(height: 28),
                    if (!isActive)
                      Icon(menu.icon, color: Colors.white60, size: 24),
                    Text(
                      menu.label,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white60,
                        fontSize: 11,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
