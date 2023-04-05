import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/bluetooth/page/bluetooth_device_page.dart';
import 'package:irrigation/feature/bluetooth/widgets/bluetooth_list_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:irrigation/feature/home/widget/drawer_widget.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  late AppLocalizations localization;
  late FlutterBluePlus flutterBluePlus;
  bool scanning = false;

  @override
  void initState() {
    flutterBluePlus = FlutterBluePlus.instance;
    disabledBluetoothSnackbar();
    super.initState();
  }

  final noBluetoothSnackbar = SnackBar(
    content: Column(
      children: [
        Text(
          AppLocalizations.of(Get.context!)!.bluetoothDisabled,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(AppLocalizations.of(Get.context!)!.openBluetoothSettings),
      ],
    ),
    action: SnackBarAction(
      label: "Settings",
      onPressed: () {
        AppSettings.openBluetoothSettings();
      },
    ),
  );

  disabledBluetoothSnackbar() async {
    if (!await flutterBluePlus.isOn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(noBluetoothSnackbar);
      }
    }
  }

  scanDevices() async {
    setState(() {
      scanning = true;
    });
    flutterBluePlus
        .startScan(timeout: const Duration(seconds: 10))
        .whenComplete(() => setState(() {
              scanning = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Scaffold(
      //drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(localization.bluetoothScan),
        actions: [
          StreamBuilder(
            stream: flutterBluePlus.isScanning,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Container(
                    padding: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator());
              } else {
                return Container();
              }
            },
          ),
          TextButton(
            onPressed: !scanning
                ? () async {
                    if (await flutterBluePlus.isOn) {
                      scanDevices();
                    } else {
                      await disabledBluetoothSnackbar();
                    }
                  }
                : null,
            child: Text(localization.scan),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.instance.scanResults,
            initialData: const [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                      children: snapshot.data!.map((e) {
                    if (e.device.name.contains("VALVE")) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => Get.to(
                              () => BluetoothDevicePage(device: e.device)),
                          child: BluetoothListItemWidget(
                            device: e.device,
                            rssi: e.rssi,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList()),
                );
              } else {
                return Container();
              }
            },
          ),
        ]),
      ),
    );
  }
}
