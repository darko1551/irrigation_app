import 'package:flutter/material.dart';
import 'package:irrigation/feature/sensor_add/page/qr_scaner_page.dart';
import 'package:irrigation/feature/sensor_add/widget/select_location_map_widget.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/request/sensor_request.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class SensorAddPage extends StatefulWidget {
  const SensorAddPage({super.key});

  @override
  State<SensorAddPage> createState() => _SensorAddPageState();
}

class _SensorAddPageState extends State<SensorAddPage> {
  late TextEditingController _nameController;
  late TextEditingController _macController;
  late TextEditingController _hThresholdController;
  String _latitude = "";
  String _longitude = "";

  @override
  void initState() {
    _nameController = TextEditingController();
    _macController = TextEditingController();
    _hThresholdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _macController.dispose();
    _hThresholdController.dispose();
    super.dispose();
  }

  Future<bool> addSensor() async {
    bool success = false;
    int? newId;
    String _name = _nameController.text;
    String _mac = _macController.text;
    String _hTreshold = _hThresholdController.text;

    if (_name.isEmpty ||
        _mac.isEmpty ||
        _hTreshold.isEmpty ||
        _latitude.isEmpty ||
        _longitude.isEmpty) {
      Get.snackbar("Warning", "Not all parameters inserted!",
          backgroundColor: Theme.of(context).cardColor);
    } else if (double.tryParse(_hTreshold) == null &&
        _hThresholdController.text.isNotEmpty) {
      Get.snackbar("Warning", "Humidity threshold must be a number!",
          backgroundColor: Theme.of(context).cardColor);
    } else {
      try {
        newId = await Provider.of<SensorProvider>(context, listen: false)
            .addSensor(SensorRequest(
                name: _name,
                latitude: double.parse(_latitude),
                longitude: double.parse(_longitude),
                mac: _mac,
                humidityThreshold: double.parse(_hTreshold)));
        success = true;

        Get.snackbar("Success", "Sensor added successfully",
            backgroundColor: Theme.of(context).cardColor);
      } catch (e) {
        Get.snackbar("Warning", e.toString());
      }
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    bool networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Sensor"),
        actions: [
          IconButton(
            onPressed: networkStatus
                ? () async {
                    bool success = await addSensor();
                    if (success) {
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: networkStatus
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //NAME
                  const Text("Name"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Insert name",
                      ),
                    ),
                  ),

                  //MAC
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Mac"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _macController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Insert device MAC",
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            var barcode =
                                await Get.to(() => const QrCameraScannerPage());
                            _macController.text = barcode;
                          },
                          icon: const Icon(Icons.qr_code_outlined),
                        )
                      ],
                    ),
                  ),

                  //HUMIDITYTHRESHOLD
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Humidity threshold"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _hThresholdController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Insert humidity threshold value",
                      ),
                    ),
                  ),

                  //MAP
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Location"),
                  const SizedBox(height: 8),
                  SelectLocationMapWidget(onChanged: (retrievedCoordinates) {
                    _latitude = retrievedCoordinates.latitude.toString();
                    _longitude = retrievedCoordinates.longitude.toString();
                    setState(() {});
                  }),
                  Text("$_latitude, $_longitude")
                ],
              ),
            )
          : const NoInternetWidget(),
    );
  }
}
