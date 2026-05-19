import 'package:flutter/material.dart';

class BaseHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  static const double defaultHeight = 80;

  final String title;
  final double height;
  final bool hasRadius;

  final Widget? leading;
  final List<Widget>? actions;

  const BaseHeaderWidget({
    super.key,
    required this.title,
    this.height = defaultHeight,
    this.hasRadius = false,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFAD510D),
      elevation: 0,
      toolbarHeight: height,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(hasRadius ? 20 : 0),
          bottomRight: Radius.circular(hasRadius ? 20 : 0),
        ),
      ),

      leading: leading,

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      actions: actions,
    );
  }
}
