import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/map_constants.dart';
import 'package:irrigation/feature/map/page/map_page.dart';
import 'package:irrigation/feature/sensor_detail/page/sensor_detail_page.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, this.fullScreen = false});
  final bool fullScreen;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;
  bool satelite = false;
  late LatLng currentLocation;
  List<Marker> markers = [];
  Timer? timer;

  bool checkEnabled(SensorResponse sensor) {
    if (sensor.lastActive == null) {
      return false;
    } else if (DateTime.now().difference(sensor.lastActive!).inHours > 24) {
      return false;
    } else {
      return true;
    }
  }

  bool checkUsed(SensorResponse sensor) {
    if (sensor.state == null) {
      return false;
    } else {
      return true;
    }
  }

  List<Marker> getMarkers() {
    List<Marker> markers = [];
    if (mounted) {
      final sensorProvider =
          Provider.of<SensorProvider>(context, listen: false);
      for (SensorResponse sensorResponse in sensorProvider.getSensors) {
        markers.add(Marker(
          point: LatLng(sensorResponse.latitude, sensorResponse.longitude),
          builder: (context) {
            return GestureDetector(
                onTap: widget.fullScreen
                    ? () =>
                        Get.to(() => SensorDetailPage(sensor: sensorResponse))
                    : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Theme.of(context).indicatorColor,
                      size: !widget.fullScreen ? 30 : 40,
                    ),
                    Positioned(
                      left: 20,
                      child: Icon(
                        Icons.circle,
                        size: 15,
                        color: !checkEnabled(sensorResponse)
                            ? Colors.grey
                            : checkUsed(sensorResponse)
                                ? sensorResponse.state!
                                    ? Colors.green
                                    : Colors.orange
                                : Colors.grey,
                      ),
                    ),
                  ],
                ));
          },
        ));
      }
    }

    return markers;
  }

  @override
  void initState() {
    _mapController = MapController();
    markers = getMarkers();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        Provider.of<SensorProvider>(context, listen: false).refreshList();

        markers.clear();
        markers = getMarkers();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    LatLngBounds? bounds;

    if (sensorProvider.getSensors.isNotEmpty) {
      Rect rect = calculateBounds(sensorProvider.getSensors
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList());

      bounds = LatLngBounds(LatLng(rect.topLeft.dx, rect.topLeft.dy),
          LatLng(rect.bottomRight.dx, rect.bottomRight.dy));
    }

    return Consumer<SensorProvider>(
      builder: (context, value, child) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                maxZoom: 18.45,
                minZoom: 2,
                onTap: (tapPosition, point) => Get.to(() => const MapPage()),
                bounds: bounds,
              ),
              children: [
                TileLayer(
                  //urlTemplate: 'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
                  //https://apidocs.geoapify.com/docs/maps/map-tiles/#about
                  urlTemplate: satelite
                      ? MapConstants.sateliteMap
                      : Provider.of<DarkThemeProvider>(context).darkTheme
                          ? MapConstants.darkMap
                          : MapConstants.lightMap,
                ),
                MarkerLayer(
                  rotate: true,
                  markers: markers,
                ),
              ],
            ),
            widget.fullScreen
                ? Positioned(
                    bottom: 30,
                    right: 15,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _mapController.move(_mapController.center,
                                  _mapController.zoom + 1);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              _mapController.move(_mapController.center,
                                  _mapController.zoom - 1);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: IconButton(
                            icon: const Icon(Icons.layers),
                            onPressed: () {
                              satelite = !satelite;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
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
