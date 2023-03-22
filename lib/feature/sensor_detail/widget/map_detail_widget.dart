import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:provider/provider.dart';

class MapDetailWidget extends StatefulWidget {
  const MapDetailWidget({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  State<MapDetailWidget> createState() => _MapDetailWidgetState();
}

class _MapDetailWidgetState extends State<MapDetailWidget> {
  List<Marker> markers = [];

  List<Marker> getMarkers() {
    List<Marker> _markers = [];
    if (mounted) {
      SensorResponse? sensorProvided =
          Provider.of<SensorProvider>(context, listen: false)
              .getSensor(widget.sensor.mac);

      _markers.add(Marker(
          point: lat_lng.LatLng(
            sensorProvided!.latitude,
            sensorProvided.longitude,
          ),
          builder: (context) => Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Theme.of(context).indicatorColor,
                    size: 40,
                  ),
                  Positioned(
                    left: 20,
                    child: Icon(
                      Icons.circle,
                      size: 15,
                      color: !checkEnabled(sensorProvided)
                          ? Colors.grey
                          : sensorProvided.state
                              ? Colors.green
                              : Colors.orange,
                    ),
                  ),
                ],
              )));
    }
    return _markers;
  }

  @override
  void initState() {
    markers = getMarkers();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        Provider.of<SensorProvider>(context, listen: false).refreshList();
        markers.clear();
        markers = getMarkers();
        setState(() {});
      }
    });
    super.initState();
  }

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
    SensorResponse? sensorProvided =
        Provider.of<SensorProvider>(context).getSensor(widget.sensor.mac);

    return Container(
      padding: const EdgeInsets.all(1),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            keepAlive: false,
            center: lat_lng.LatLng(
              sensorProvided!.latitude,
              sensorProvided.longitude,
            ),
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: MediaQuery.of(context).platformBrightness ==
                      Brightness.dark
                  ? 'https://maps.geoapify.com/v1/tile/dark-matter-yellow-roads/{z}/{x}/{y}.png?&apiKey=9b38379eb2b14acbb41d6fe85542788f'
                  : 'https://maps.geoapify.com/v1/tile/osm-liberty/{z}/{x}/{y}.png?&apiKey=9b38379eb2b14acbb41d6fe85542788f',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              rotate: true,
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}
