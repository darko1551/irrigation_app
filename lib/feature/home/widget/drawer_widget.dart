import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/about/page/about_page.dart';
import 'package:irrigation/feature/bluetooth/page/bluetooth_scan_page.dart';
import 'package:irrigation/feature/home/page/home_page.dart';
import 'package:irrigation/feature/login/login_page.dart';
import 'package:irrigation/feature/map/page/map_page.dart';
import 'package:irrigation/feature/sensor_add/page/sensor_add_page.dart';
import 'package:irrigation/feature/settings/page/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:irrigation/provider/user_provider.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: double.maxFinite,
            height: 150,
            color: Theme.of(context).secondaryHeaderColor,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).cardColor,
                    size: 50,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Provider.of<UserProvider>(context).user.name} ${Provider.of<UserProvider>(context).user.surname}",
                        style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        Provider.of<UserProvider>(context).user.email,
                        style: TextStyle(
                            color: Theme.of(context).cardColor, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const MapPage()),
              child: DrawerElementWidget(
                  icon: const Icon(Icons.map), text: localization!.map)),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const HomePage()),
              child: DrawerElementWidget(
                  icon: const Icon(Icons.sensors), text: localization.sensors)),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const SensorAddPage()),
              child: DrawerElementWidget(
                  icon: const Icon(Icons.add), text: localization.addSensor)),
          const Divider(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.offAll(() => const BluetoothScanPage()),
            child: DrawerElementWidget(
                icon: const Icon(Icons.bluetooth),
                text: localization.bluetoothScan),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.offAll(() => const SettingsPage()),
            child: DrawerElementWidget(
                icon: const Icon(Icons.settings), text: localization.settings),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.offAll(() => const AboutPage()),
            child: DrawerElementWidget(
                icon: const Icon(Icons.info_outline),
                text: localization.aboutApplication),
          ),
          const Divider(
            thickness: 1,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await Provider.of<UserProvider>(context, listen: false)
                  .setClientCredentials(null);
              Get.offAll(() => const LoginPage());
            },
            child: DrawerElementWidget(
                icon: const Icon(Icons.logout_outlined),
                text: localization.logOut),
          ),
        ],
      ),
    );
  }
}

class DrawerElementWidget extends StatelessWidget {
  const DrawerElementWidget(
      {super.key, required this.icon, required this.text});
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: double.maxFinite,
      height: 80,
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 20,
          ),
          Text(text)
        ],
      ),
    );
  }
}
