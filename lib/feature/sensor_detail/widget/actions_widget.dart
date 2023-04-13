import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/schedule/page/schedule_list_page.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({super.key, required this.enabled, required this.sensor});

  final SensorResponse sensor;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: //!enabled
                    //? null
                    //:
                    () async {
                  try {
                    await Provider.of<SensorProvider>(context, listen: false)
                        .openValve(sensor.uuid);
                    Get.snackbar(localization.notice, localization.openNotice,
                        backgroundColor: Theme.of(Get.context!).cardColor);
                  } catch (e) {
                    Get.snackbar(localization.error, e.toString(),
                        backgroundColor: Theme.of(Get.context!).cardColor);
                  }
                },
                child: Text(localization!.open),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: //!enabled
                    //? null
                    //:
                    () async {
                  try {
                    await Provider.of<SensorProvider>(context, listen: false)
                        .closeValve(sensor.uuid);
                    Get.snackbar(localization.notice, localization.closeNotice,
                        backgroundColor: Theme.of(Get.context!).cardColor);
                  } catch (e) {
                    Get.snackbar(localization.error, e.toString(),
                        backgroundColor: Theme.of(Get.context!).cardColor);
                  }
                },
                child: Text(localization.close),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Get.to(() => ScheduleListPage(
                    sensor: sensor,
                  ));
            },
            child: Text(localization.schedules),
          ),
        ],
      ),
    );
  }
}
