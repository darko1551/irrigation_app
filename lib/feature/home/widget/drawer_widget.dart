import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/about/page/about_page.dart';
import 'package:irrigation/feature/home/page/home_page.dart';
import 'package:irrigation/feature/map/page/map_page.dart';
import 'package:irrigation/feature/sensor_add/page/sensor_add_page.dart';
import 'package:irrigation/feature/settings/page/settings_page.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Darko Debeljak",
                    style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const MapPage()),
              child: const DrawerElementWidget(
                  icon: Icon(Icons.map), text: "Map")),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const HomePage()),
              child: const DrawerElementWidget(
                  icon: Icon(Icons.sensors), text: "Sensors")),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => const SensorAddPage()),
              child: const DrawerElementWidget(
                  icon: Icon(Icons.add), text: "Add sensor")),
          const Divider(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.to(() => const SettingsPage()),
            child: const DrawerElementWidget(
                icon: Icon(Icons.settings), text: "Settings"),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.to(() => const AboutPage()),
            child: const DrawerElementWidget(
                icon: Icon(Icons.info_outline), text: "About application"),
          ),
          const Divider(
            thickness: 1,
          ),
          const DrawerElementWidget(
              icon: Icon(Icons.logout_outlined), text: "Log out"),
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
