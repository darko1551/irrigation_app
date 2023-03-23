import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/drawer_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("About application"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("  About application"),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Application version",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Expanded(child: Container()),
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return Text(snapshot.data!.version);
                        default:
                          return const CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
