import 'package:flutter/material.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SensorDeleteDialog extends StatelessWidget {
  const SensorDeleteDialog({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(localization!.deleteSensor),
      content: Text("${localization.deleteSensorConfirmation} ${sensor.name}?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localization.no),
        ),
        TextButton(
          onPressed: () {
            Provider.of<SensorProvider>(context, listen: false)
                .removeSensor(sensor.sensorId);
            Navigator.of(context).pop();
          },
          child: Text(localization.yes),
        ),
      ],
    );
  }
}
