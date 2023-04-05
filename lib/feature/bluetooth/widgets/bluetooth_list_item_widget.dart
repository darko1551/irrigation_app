import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothListItemWidget extends StatelessWidget {
  const BluetoothListItemWidget(
      {super.key, required this.device, required this.rssi});

  final BluetoothDevice device;
  final int rssi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            children: [
              Text(device.id.toString()),
              const SizedBox(
                width: 25,
              ),
              Text("RSSI: $rssi"),
            ],
          )
        ],
      ),
    );
  }
}
