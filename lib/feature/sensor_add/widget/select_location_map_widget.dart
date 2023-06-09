import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/map_constants.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectLocationMapWidget extends StatefulWidget {
  const SelectLocationMapWidget(
      {super.key, required this.onChanged, this.latitude, this.longitude});
  final ValueChanged<lat_lng.LatLng> onChanged;
  final double? latitude;
  final double? longitude;

  @override
  State<SelectLocationMapWidget> createState() =>
      _SelectLocationMapWidgetState();
}

class _SelectLocationMapWidgetState extends State<SelectLocationMapWidget> {
  Marker? marker;
  Marker? currentLocationMarker;
  late Future<Position?> currentPosition;
  bool satelite = false;
  late MapController _mapController;
  late AppLocalizations localization;

  @override
  void initState() {
    _mapController = MapController();
    currentPosition = _getCurrentPosition();
    if (widget.latitude != null && widget.longitude != null) {
      marker = Marker(
          point: lat_lng.LatLng(widget.latitude!, widget.longitude!),
          builder: ((context) => Icon(
                Icons.location_pin,
                color: Theme.of(context).indicatorColor,
                size: 35,
              )));
    }

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
          localization.warning, localization.turnOnLocationForBetterExperience);
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
            localization.warning, localization.locationPermissionDenied);
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(localization.warning,
          localization.locationPermissionPermanentlyDenied);
      return null;
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FutureBuilder(
              future: currentPosition,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    currentLocationMarker = Marker(
                        point: lat_lng.LatLng(
                            snapshot.data!.latitude, snapshot.data!.longitude),
                        builder: (context) => const Icon(
                              Icons.circle,
                              color: Colors.blue,
                            ));
                  }
                  return Stack(children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                          onTap: (tapPosition, point) {
                            marker = Marker(
                                point: point,
                                builder: ((context) => Icon(
                                      Icons.location_pin,
                                      color: Theme.of(context).indicatorColor,
                                      size: 35,
                                    )));
                            widget.onChanged(lat_lng.LatLng(
                                point.latitude, point.longitude));
                            //setState(() {});
                          },
                          center: lat_lng.LatLng(
                            widget.latitude ??
                                (snapshot.data == null
                                    ? 46.305746
                                    : snapshot.data!.latitude),
                            widget.longitude ??
                                (snapshot.data == null
                                    ? 16.3366066
                                    : snapshot.data!.longitude),
                          ),
                          zoom: 15,
                          maxZoom: 18.45,
                          minZoom: 2),
                      children: [
                        TileLayer(
                          urlTemplate: satelite
                              ? MapConstants.sateliteMap
                              : Provider.of<DarkThemeProvider>(context)
                                      .darkTheme
                                  ? MapConstants.darkMap
                                  : MapConstants.lightMap,
                        ),
                        MarkerLayer(
                            rotate: true,
                            markers: marker == null
                                ? currentLocationMarker == null
                                    ? []
                                    : [currentLocationMarker!]
                                : currentLocationMarker == null
                                    ? [marker!]
                                    : [marker!, currentLocationMarker!])
                      ],
                    ),
                    Positioned(
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
                  ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
