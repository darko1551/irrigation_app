import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_sharp,
            size: 60,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            localization!.noInternetConnection,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
