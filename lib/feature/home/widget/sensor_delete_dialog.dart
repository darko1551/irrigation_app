import 'package:flutter/material.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class SensorDeleteDialog extends StatelessWidget {
  const SensorDeleteDialog({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete sensor"),
      content: Text("Are you sure you want to delete sensor: ${sensor.name}?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            Provider.of<SensorProvider>(context, listen: false)
                .removeSensor(sensor.sensorId);
            Navigator.of(context).pop();
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
