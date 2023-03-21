import 'package:flutter/material.dart';

class TileInfoRowWidget extends StatelessWidget {
  const TileInfoRowWidget(
      {super.key,
      required this.text,
      required this.icon,
      this.color,
      required this.size});

  final String text;
  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: size,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text),
      ],
    );
  }
}
