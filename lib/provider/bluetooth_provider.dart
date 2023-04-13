import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/bluetooth_constants.dart';

class BluetoothProvider extends ChangeNotifier {
  late BluetoothDevice device;

  bool used = false;

  bool connected = false;
  bool listenersAdded = false;
  late Stream<BluetoothDeviceState> bleConnectionStateStream;
  late StreamSubscription<BluetoothDeviceState> subscriptions;
  late StreamSubscription<List<int>> subscriptions2;
  var writeService = null;
  bool loading = false;
  bool txEnabled = false;
  bool accessGranted = false;

  initDevice(BluetoothDevice newDevice) {
    device = newDevice;
  }

  void connect() async {
    loading = true;
    notifyListeners();

    await device
        .connect()
        .timeout(const Duration(minutes: 2))
        .whenComplete(addListeners);

    loading = false;
    used = true;
    notifyListeners();
  }

  void disconnect({bool set = true}) async {
    if (set) {
      loading = true;
      notifyListeners();
    }

    await device.disconnect();

    if (set) {
      loading = false;
      notifyListeners();
    }
  }

  addListeners() async {
    if (!listenersAdded) {
      bleConnectionStateStream = device.state.asBroadcastStream();
      subscriptions = device.state.listen(stateListener);
      listenersAdded = true;
    }
  }

  discoverServices() async {
    if (writeService == null) {
      print("DiscoverServices");

      List<BluetoothService?> services = await device.discoverServices();
      for (var service in services) {
        if (service!.uuid.toString() == BluetoothConstants.RX_SERVICE_UUID) {
          enableTXNotification(service);
          writeService = service;
        }
      }
    } else {
      print("DiscoverServices - already discovered");
    }
  }

  enableTXNotification(BluetoothService service) async {
    service.characteristics.forEach((characteristic) async {
      if (characteristic.uuid.toString() == BluetoothConstants.TX_CHAR_UUID) {
        await characteristic.setNotifyValue(true);
        if (!txEnabled) {
          txEnabled = true;
          subscriptions2 = characteristic.value.listen((event) {
            //Data from device
            String message = utf8.decode(event);

            if (message.contains("Access granted")) {
              accessGranted = true;
              notifyListeners();
            }
            if (message.contains("Default scheduler s")) {
              Get.snackbar(AppLocalizations.of(Get.context!)!.notice,
                  AppLocalizations.of(Get.context!)!.defaultSchedulerSet,
                  backgroundColor: Theme.of(Get.context!).cardColor);
            }
            print("Ble Value: " + utf8.decode(event));
          });
        }
      }
    });
  }

  writeCommand(String command) {
    print("BaseBluetooth -> writeCommand: " + command);
    if (writeService != null) {
      writeService!.characteristics.forEach((characteristic) async {
        if (characteristic.uuid.toString() == BluetoothConstants.RX_CHAR_UUID) {
          try {
            List<int> encodedCommand = utf8.encode(command);
            List<List<int>> splitCommands = splitByteArray(encodedCommand, 19);
            await sendCommandToDevice(splitCommands, characteristic);
          } catch (e) {
            print(e);
          }
        }
      });
    }
  }

  sendCommandToDevice(List<List<int>> command,
      BluetoothCharacteristic writeCharacteristic) async {
    print("SendCommandToDevice => commands: " + command.length.toString());
    for (List<int> c in command) {
      try {
        await writeCharacteristic.write(c);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> stateListener(event) async {
    var bleDeviceState = event;
    print("DeviceState:" + event.toString());

    switch (event) {
      case BluetoothDeviceState.disconnected:
        clear();

        connected = false;
        notifyListeners();

        break;
      case BluetoothDeviceState.connecting:
        break;
      case BluetoothDeviceState.connected:
        print("DeviceState CONNECTED");
        connected = true;
        notifyListeners();
        await discoverServices();
        authenticate;
        Timer(const Duration(seconds: 10), connected ? authenticate : () {});
        break;
      case BluetoothDeviceState.disconnecting:
        break;
    }
  }

  List<List<int>> splitByteArray(List<int> encodedCommand, int i) {
    List<List<int>> chunks = [];
    int chunkSize = i;
    for (var i = 0; i < encodedCommand.length; i += chunkSize) {
      chunks.add(encodedCommand.sublist(
          i,
          i + chunkSize > encodedCommand.length
              ? encodedCommand.length
              : i + chunkSize));
    }
    return chunks;
  }

  authenticate() {
    writeCommand("iot\n");
  }

  clear({bool set = true}) {
    if (used) {
      connected = false;
      accessGranted = false;
      listenersAdded = false;
      bleConnectionStateStream = const Stream.empty();
      subscriptions.cancel();
      subscriptions2.cancel();
      txEnabled = false;
      writeService = null;
      if (set) {
        notifyListeners();
      }
    }
  }
}
