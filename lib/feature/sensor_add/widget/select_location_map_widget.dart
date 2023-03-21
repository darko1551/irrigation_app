import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

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

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              onTap: (tapPosition, point) {
                marker = Marker(
                    point: point,
                    builder: ((context) => Icon(
                          Icons.location_pin,
                          color: Theme.of(context).indicatorColor,
                          size: 35,
                        )));
                widget
                    .onChanged(lat_lng.LatLng(point.latitude, point.longitude));
                setState(() {});
              },
              center: lat_lng.LatLng(
                widget.latitude ?? 46.305746,
                widget.longitude ?? 16.3366066,
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
                markers: marker == null ? [] : [marker!],
              )
            ],
          ),
        ),
      ),
    );
  }
}
