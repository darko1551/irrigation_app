import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/sensor_add/widget/select_location_map_widget.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/models/update/sensor_update.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SensorEditPage extends StatefulWidget {
  const SensorEditPage({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  State<SensorEditPage> createState() => _SensorEditPageState();
}

class _SensorEditPageState extends State<SensorEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _hThresholdController;
  String _latitude = "";
  String _longitude = "";
  late AppLocalizations localization;

  Future<bool> editSensor() async {
    bool success = false;
    String _name = _nameController.text;
    String _hTreshold = _hThresholdController.text;

    if (_name.isEmpty ||
        _hTreshold.isEmpty ||
        _latitude.isEmpty ||
        _longitude.isEmpty) {
      Get.snackbar(localization.warning, localization.notAllParametersInserted,
          backgroundColor: Theme.of(context).cardColor);
    } else if (double.tryParse(_hTreshold) == null &&
        _hThresholdController.text.isNotEmpty) {
      Get.snackbar(
          localization.warning, localization.humidityThresholdMustbeNumber,
          backgroundColor: Theme.of(context).cardColor);
    } else {
      try {
        await Provider.of<SensorProvider>(context, listen: false).editSensor(
            widget.sensor.sensorId,
            SensorUpdate(
                name: _name,
                latitude: double.parse(_latitude),
                longitude: double.parse(_longitude),
                humidityThreshold: double.parse(_hTreshold)));
        success = true;
        if (mounted) {
          Get.snackbar(
              localization.success, localization.sensorEditedSuccessfully,
              backgroundColor: Theme.of(context).cardColor);
        }
      } catch (e) {
        Get.snackbar(localization.warning, e.toString(),
            backgroundColor: Theme.of(context).cardColor);
      }
    }
    return success;
  }

  @override
  void initState() {
    _nameController = TextEditingController()..text = widget.sensor.name;
    _hThresholdController = TextEditingController()
      ..text = widget.sensor.humidityThreshold.toString();
    _latitude = widget.sensor.latitude.toString();
    _longitude = widget.sensor.longitude.toString();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    bool networkStatus = Provider.of<NetworkProvider>(context).networkStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text("${localization.editing}${widget.sensor.name}"),
        actions: [
          IconButton(
            onPressed: networkStatus
                ? () async {
                    bool success = await editSensor();
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
                  Text(localization.name),
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: localization.insertName,
                      ),
                    ),
                  ),

                  //HUMIDITYTHRESHOLD
                  const SizedBox(
                    height: 20,
                  ),
                  Text(localization.humidityThreshold),
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: localization.insertHumidityThreshold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Text(localization.location),
                  const SizedBox(height: 8),
                  SelectLocationMapWidget(
                      latitude: widget.sensor.latitude,
                      longitude: widget.sensor.longitude,
                      onChanged: (retrievedCoordinates) {
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
