import 'package:flutter/material.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

import 'device_info_element_widget.dart';

class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  Widget build(BuildContext context) {
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
            title: "Mac",
          ),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
            icon: Icons.thermostat,
            text: "${sensor.sensorData.temperature ?? "N/A"} °C",
            title: "Temperature",
          ),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.water_drop,
              text: "${sensor.sensorData.humidity ?? "N/A"} %",
              title: "Humidity"),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.waterfall_chart_rounded,
              text: "${sensorProvided!.humidityThreshold} %",
              title: "Humidity threshuld"),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.data_usage,
              text: "${sensor.waterUsageLast ?? "N/A"} l",
              title: "Water usage - last"),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.circle_outlined,
              text: "${sensor.waterUsageAllTime ?? "N/A"} l",
              title: "Water usage - All time"),
          const SizedBox(
            height: 8,
          ),
          DeviceInfoElementWidget(
              icon: Icons.location_on_outlined,
              text: "${sensorProvided.latitude}  ${sensorProvided.longitude}",
              title: "Location"),
        ],
      ),
    );
  }
}
