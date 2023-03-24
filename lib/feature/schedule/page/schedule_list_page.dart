import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/schedule/page/schedule_add_edit_page.dart';
import 'package:irrigation/feature/schedule/widget/schedule_list_item.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key, required this.sensor});
  final SensorResponse sensor;

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  bool state = true;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    bool networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;

    List<IrregationScheduleResponse> schedules = Provider.of<SensorProvider>(
            context)
        .getSensors
        .singleWhere((element) => element.sensorId == widget.sensor.sensorId)
        .irregationSchedules;
    return Scaffold(
      appBar: AppBar(
        title: Text("${localization!.schedulesFor} ${widget.sensor.name}"),
        actions: [
          IconButton(
              onPressed: networkStatus
                  ? () {
                      Get.to(() => ScheduleAddEditPage(sensor: widget.sensor));
                    }
                  : null,
              icon: const Icon(Icons.add))
        ],
      ),
      body: networkStatus
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () => Get.to(() => ScheduleAddEditPage(
                            schedule: schedules[index],
                            sensor: widget.sensor,
                          )),
                      child: ScheduleListitem(
                          sensor: widget.sensor, schedule: schedules[index]),
                    ),
                  );
                },
              ))
          : const NoInternetWidget(),
    );
  }
}
