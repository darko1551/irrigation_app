import 'package:flutter/material.dart';

class DeviceInfoElementWidget extends StatelessWidget {
  const DeviceInfoElementWidget(
      {super.key, required this.text, required this.icon, required this.title});
  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
