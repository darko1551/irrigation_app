import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/sensor_detail/widget/actions_widget.dart';
import 'package:irrigation/feature/sensor_detail/widget/connection_info_widget.dart';
import 'package:irrigation/feature/sensor_detail/widget/device_info_widget.dart';
import 'package:irrigation/feature/sensor_detail/widget/map_detail_widget.dart';
import 'package:irrigation/feature/sensor_edit/page/sensor_edit_page.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class SensorDetailPage extends StatefulWidget {
  const SensorDetailPage({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {
  bool checkEnabled(SensorResponse sensor) {
    if (sensor.lastActive == null) {
      return false;
    } else if (DateTime.now().difference(sensor.lastActive!).inHours > 24) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SensorResponse? sensorProvided;
    bool networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;

    sensorProvided =
        Provider.of<SensorProvider>(context).getSensor(widget.sensor.mac);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: networkStatus
                  ? () {
                      Provider.of<SensorProvider>(context, listen: false)
                          .removeSensor(widget.sensor.sensorId);
                      Get.back();
                      Get.snackbar("Success", "Sensor removed!",
                          backgroundColor: Theme.of(context).cardColor);
                    }
                  : null,
              icon: const Icon(Icons.delete_outline)),
          IconButton(
            onPressed: networkStatus
                ? () {
                    Get.to(() => SensorEditPage(sensor: sensorProvided!))
                        ?.then((value) => setState(() {}));
                  }
                : null,
            icon: const Icon(Icons.edit),
          ),
        ],
        title: Text(sensorProvided!.name),
      ),
      body: networkStatus
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    //CONNECTION
                    ConnectionInfoWidget(
                        enabled: checkEnabled(sensorProvided),
                        sensor: sensorProvided),
                    //ACTIONS
                    const Text("Device actions"),
                    const SizedBox(height: 8),
                    ActionsWidget(
                        enabled: checkEnabled(sensorProvided),
                        sensor: widget.sensor),
                    const SizedBox(
                      height: 20,
                    ),
                    //MAP
                    const Text("Device location"),
                    const SizedBox(height: 8),
                    MapDetailWidget(sensor: widget.sensor),
                    const SizedBox(height: 8),
                    const SizedBox(
                      height: 20,
                    ),
                    //DEVICE INFO
                    const Text("Device info"),
                    const SizedBox(height: 8),
                    DeviceInfoWidget(sensor: widget.sensor),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            )
          : const NoInternetWidget(),
    );
  }
}
