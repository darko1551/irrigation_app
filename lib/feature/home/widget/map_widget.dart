import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/map/page/map_page.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;

  List<Marker> getMarkers() {
    final sensorProvider = Provider.of<SensorProvider>(context);
    List<Marker> markers = [];
    for (SensorResponse sensorResponse in sensorProvider.getSensors) {
      markers.add(Marker(
        point: LatLng(sensorResponse.latitude, sensorResponse.longitude),
        builder: (context) {
          return Icon(
            Icons.location_pin,
            color: Theme.of(context).indicatorColor,
            size: 30,
          );
        },
      ));
    }
    return markers;
  }

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);

    Rect rect = calculateBounds(sensorProvider.getSensors
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList());

    LatLngBounds bounds = LatLngBounds(LatLng(rect.topLeft.dx, rect.topLeft.dy),
        LatLng(rect.bottomRight.dx, rect.bottomRight.dy));

    return Consumer<SensorProvider>(
      builder: (context, value, child) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onTap: (tapPosition, point) => Get.to(() => const MapPage()),
            bounds: bounds,
          ),
          children: [
            TileLayer(
              //urlTemplate: 'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
              //https://apidocs.geoapify.com/docs/maps/map-tiles/#about
              urlTemplate: MediaQuery.of(context).platformBrightness ==
                      Brightness.dark
                  ? 'https://maps.geoapify.com/v1/tile/dark-matter-yellow-roads/{z}/{x}/{y}.png?&apiKey=9b38379eb2b14acbb41d6fe85542788f'
                  : 'https://maps.geoapify.com/v1/tile/osm-liberty/{z}/{x}/{y}.png?&apiKey=9b38379eb2b14acbb41d6fe85542788f',

              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: getMarkers(),
            ),
          ],
        );
      },
    );
  }

  Rect calculateBounds(List<LatLng> coordinates) {
    // Find minimum and maximum X and Y values
    double minX = coordinates.first.latitude;
    double maxX = coordinates.first.latitude;
    double minY = coordinates.first.longitude;
    double maxY = coordinates.first.longitude;

    for (LatLng point in coordinates) {
      if (point.latitude < minX) {
        minX = point.latitude;
      }
      if (point.latitude > maxX) {
        maxX = point.latitude;
      }
      if (point.longitude < minY) {
        minY = point.longitude;
      }
      if (point.longitude > maxY) {
        maxY = point.longitude;
      }
    }

    double width = maxX - minX;
    double height = maxY - minY;
    double offsetX = 0.15 * width;
    double offsetY = 0.15 * height;

    // Create a Rect object from the min and max values
    Rect boundingBox = Rect.fromLTRB(
      minX - offsetX, // left
      minY - offsetY, // top
      maxX + offsetX, // right
      maxY + offsetY, // bottom
    );

    return boundingBox;
  }
}
