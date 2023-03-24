import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/map_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization!.map),
      ),
      body: const MapWidget(
        fullScreen: true,
      ),
    );
  }
}
