import 'package:flutter/material.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectionInfoWidget extends StatelessWidget {
  const ConnectionInfoWidget(
      {super.key, required this.enabled, required this.sensor});

  final SensorResponse sensor;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: enabled ? Colors.green : Colors.red,
                  size: 15,
                ),
                Text(
                  enabled
                      ? " ${localization!.online}"
                      : " ${localization!.offline}",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: !enabled
                      ? Colors.grey
                      : sensor.state
                          ? Colors.green
                          : Colors.orange,
                  size: 15,
                ),
              ],
            ),
            Text(
              sensor.state ? " ${localization.open}" : " ${localization.close}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          sensor.lastActive == null
              ? localization.unknown
              : DateFormat('dd.MM.yyyy hh:mm').format(sensor.lastActive!),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(
          height: 15,
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
