import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/drawer_widget.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:irrigation/provider/localization_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool localizationCroatian =
        Provider.of<LocalizationProvider>(context).locale ==
            const Locale('hr', '');
    var localization = AppLocalizations.of(context);
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(localization!.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //THEME
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(localization.theme),
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
                  Text(
                    localization.nightMode,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
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

            //LANGUAGE
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(localization.language),
            ),
            Container(
              width: double.maxFinite,
              height: 80,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Provider.of<LocalizationProvider>(context,
                            listen: false)
                        .setLocale('hr'),
                    child: Text(
                      localization.croatian,
                      style: TextStyle(
                          color: localizationCroatian
                              ? Theme.of(context).iconTheme.color
                              : null,
                          fontSize: localizationCroatian ? 18 : 16,
                          fontWeight:
                              localizationCroatian ? FontWeight.bold : null),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 2,
                    indent: 55,
                    endIndent: 55,
                  ),
                  GestureDetector(
                    onTap: () => Provider.of<LocalizationProvider>(context,
                            listen: false)
                        .setLocale('en'),
                    child: Text(
                      localization.english,
                      style: TextStyle(
                          color: !localizationCroatian
                              ? Theme.of(context).iconTheme.color
                              : null,
                          fontSize: !localizationCroatian ? 18 : 16,
                          fontWeight:
                              !localizationCroatian ? FontWeight.bold : null),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
