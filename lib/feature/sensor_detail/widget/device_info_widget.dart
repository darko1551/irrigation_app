import 'package:flutter/material.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'device_info_element_widget.dart';

class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    SensorResponse? sensorProvided =
        Provider.of<SensorProvider>(context).getSensor(sensor.mac);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.maxFinite,
      child: Column(
        children: [
          DeviceInfoElementWidget(
            icon: Icons.label,
            text: sensor.mac,
            title: localization!.mac,
          ),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
            icon: Icons.thermostat,
            text: "${sensorProvided!.sensorData.temperature ?? "N/A"} °C",
            title: localization.temperature,
          ),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.water_drop,
              text: "${sensorProvided.sensorData.humidity ?? "N/A"} %",
              title: localization.humidity),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.waterfall_chart_rounded,
              text: "${sensorProvided.humidityThreshold} %",
              title: localization.humidityThreshold),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.data_usage,
              text:
                  "${sensorProvided.waterUsageLast != null ? sensorProvided.waterUsageLast!.toStringAsFixed(1) : "N/A"} l",
              title: localization.waterUsageLast),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.circle_outlined,
              text:
                  "${sensorProvided.waterUsageAllTime != null ? sensorProvided.waterUsageAllTime!.toStringAsFixed(1) : "N/A"} l",
              title: localization.waterUsageAll),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.location_on_outlined,
              text: "${sensorProvided.latitude}  ${sensorProvided.longitude}",
              title: localization.location),
        ],
      ),
    );
  }
}
