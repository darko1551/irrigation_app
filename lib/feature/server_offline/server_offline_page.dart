import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/login/login_page.dart';

class ServerOfflinePage extends StatefulWidget {
  const ServerOfflinePage({super.key});

  @override
  State<ServerOfflinePage> createState() => _ServerOfflinePageState();
}

class _ServerOfflinePageState extends State<ServerOfflinePage> {
  late AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.error),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization.serverNotOnline),
            TextButton(
                onPressed: () {
                  Get.offAll(() => const LoginPage());
                },
                child: Text(localization.tryAgain))
          ],
        ),
      ),
    );
  }
}
