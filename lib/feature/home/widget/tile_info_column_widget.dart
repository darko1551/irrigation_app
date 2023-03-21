import 'package:flutter/material.dart';

class TileInfoColumnWidget extends StatelessWidget {
  const TileInfoColumnWidget(
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
    return Column(
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
