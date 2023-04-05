import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:irrigation/constants/bluetooth_constants.dart';

class BluetoothDevicePage extends StatefulWidget {
  const BluetoothDevicePage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<BluetoothDevicePage> createState() => _BluetoothDevicePageState();
}

class _BluetoothDevicePageState extends State<BluetoothDevicePage> {
  bool used = false;
  late BluetoothDevice _device;
  bool connected = false;
  bool listenersAdded = false;
  late Stream<BluetoothDeviceState> bleConnectionStateStream;
  late StreamSubscription<BluetoothDeviceState> subscriptions;
  late StreamSubscription<List<int>> subscriptions2;
  var writeService = null;
  bool loading = false;
  bool txEnabled = false;
  bool accessGranted = false;

  @override
  void initState() {
    _device = widget.device;
    super.initState();
  }

  @override
  void dispose() {
    if (connected) {
      disconnect(set: false);
    }
    clear(set: false);
    super.dispose();
  }

  void connect() async {
    setState(() {
      loading = true;
    });
    await _device
        .connect()
        .timeout(const Duration(minutes: 2))
        .whenComplete(addListeners);
    setState(() {
      loading = false;
      used = true;
    });
  }

  clear({bool set = true}) {
    if (used) {
      listenersAdded = false;
      bleConnectionStateStream = const Stream.empty();
      subscriptions.cancel();
      subscriptions2.cancel();
      txEnabled = false;
      writeService = null;
      accessGranted = false;
      if (set) {
        setState(() {});
      }
    }
  }

  void disconnect({bool set = true}) async {
    if (set) {
      setState(() {
        loading = true;
      });
    }
    await _device.disconnect();
    if (set) {
      setState(() {
        loading = false;
      });
    }
  }

  addListeners() async {
    if (!listenersAdded) {
      bleConnectionStateStream = _device.state.asBroadcastStream();
      subscriptions = _device.state.listen(stateListener);
      listenersAdded = true;
    }
  }

  discoverServices() async {
    if (writeService == null) {
      print("DiscoverServices");

      List<BluetoothService?> services = await _device.discoverServices();
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
              setState(() {
                accessGranted = true;
              });
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
        setState(() {
          connected = false;
        });
        break;
      case BluetoothDeviceState.connecting:
        break;
      case BluetoothDeviceState.connected:
        print("DeviceState CONNECTED");
        setState(() {
          connected = true;
        });
        await discoverServices();
        authenticate;
        Timer(const Duration(seconds: 10), authenticate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_device.name),
        actions: [
          TextButton(
              onPressed: loading
                  ? null
                  : connected
                      ? disconnect
                      : connect,
              child: Text(!connected ? "Connect" : "Disconnect"))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading
              ? const LinearProgressIndicator(
                  color: Colors.red,
                )
              : Container(),
          Text(
            connected ? "Connected" : "Disconnected",
            style: const TextStyle(fontSize: 25),
          ),
          Text(
            !connected
                ? ""
                : accessGranted
                    ? "Access granted"
                    : "Access not granted",
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
                    onPressed: connected && accessGranted
                        ? () {
                            writeCommand("ab.openv\n");
                          }
                        : null,
                    child: const Text("Open")),
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                    onPressed: connected && accessGranted
                        ? () {
                            writeCommand("ab.closev\n");
                          }
                        : null,
                    child: const Text("Close"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
