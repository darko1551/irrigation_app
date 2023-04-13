import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:irrigation/provider/bluetooth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BluetoothDevicePage extends StatefulWidget {
  const BluetoothDevicePage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<BluetoothDevicePage> createState() => _BluetoothDevicePageState();
}

class _BluetoothDevicePageState extends State<BluetoothDevicePage> {
  late BluetoothDevice _device;
  late AppLocalizations localization;

  BluetoothProvider bluetoothProvider =
      Provider.of<BluetoothProvider>(Get.context!, listen: false);

  @override
  void initState() {
    _device = widget.device;
    bluetoothProvider.initDevice(_device);
    super.initState();
  }

  @override
  void dispose() {
    if (bluetoothProvider.connected) {
      bluetoothProvider.disconnect(set: false);
    }
    bluetoothProvider.clear(set: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_device.name),
        actions: [
          TextButton(
              onPressed: bluetoothProvider.loading
                  ? null
                  : bluetoothProvider.connected
                      ? bluetoothProvider.disconnect
                      : bluetoothProvider.connect,
              child: Text(!Provider.of<BluetoothProvider>(context, listen: true)
                      .connected
                  ? localization.connect
                  : localization.disconnect))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          Provider.of<BluetoothProvider>(context, listen: true).loading
              ? const LinearProgressIndicator(
                  color: Colors.red,
                )
              : Container(),
          Text(
            Provider.of<BluetoothProvider>(context, listen: true).connected
                ? localization.connected
                : localization.disconnected,
            style: const TextStyle(fontSize: 25),
          ),
          Text(
            !Provider.of<BluetoothProvider>(context, listen: true).connected
                ? ""
                : Provider.of<BluetoothProvider>(context, listen: true)
                        .accessGranted
                    ? localization.accessGranted
                    : localization.accessDenied,
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: bluetoothProvider.connected &&
                            bluetoothProvider.accessGranted
                        ? () {
                            bluetoothProvider.writeCommand("ab.openv\n");
                          }
                        : null,
                    child: Text(localization.open)),
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                    onPressed: bluetoothProvider.connected &&
                            bluetoothProvider.accessGranted
                        ? () {
                            bluetoothProvider.writeCommand("ab.closev\n");
                          }
                        : null,
                    child: Text(localization.close)),
              ],
            ),
          ),
          Expanded(child: Container()),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              onPressed:
                  bluetoothProvider.connected && bluetoothProvider.accessGranted
                      ? () {
                          bluetoothProvider.writeCommand("ab.sds\n");
                        }
                      : null,
              child: Text(localization.setDefaultScheduler),
            ),
          ),
        ],
      ),
    );
  }
}
