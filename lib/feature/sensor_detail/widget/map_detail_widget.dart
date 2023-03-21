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
              markers: [
                Marker(
                  point: lat_lng.LatLng(
                    sensorProvided.latitude,
                    sensorProvided.longitude,
                  ),
                  builder: (context) => Icon(
                    Icons.location_pin,
                    color: Theme.of(context).indicatorColor,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
