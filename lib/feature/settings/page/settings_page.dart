import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/drawer_widget.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("  Theme"),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(Icons.mode_night_rounded),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Night mod",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Expanded(child: Container()),
                  Switch(
                    value: Provider.of<DarkThemeProvider>(context).darkTheme,
                    onChanged: (value) {
                      Provider.of<DarkThemeProvider>(context, listen: false)
                          .darkTheme = value;
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
