import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScheduleListitem extends StatefulWidget {
  const ScheduleListitem(
      {super.key, required this.schedule, required this.sensor});
  final SensorResponse sensor;
  final IrregationScheduleResponse schedule;

  @override
  State<ScheduleListitem> createState() => _ScheduleListitemState();
}

class _ScheduleListitemState extends State<ScheduleListitem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    bool state = Provider.of<SensorProvider>(context, listen: true)
        .getSensors
        .singleWhere((element) => element.sensorId == widget.sensor.sensorId)
        .irregationSchedules
        .singleWhere((element) => element.id == widget.schedule.id)
        .doNotIrregate;
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localization!.dateFrom),
              Text(
                "${widget.schedule.dateFrom.day}.${widget.schedule.dateFrom.month}.${widget.schedule.dateFrom.year}.",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Text(localization.dateTo),
              Text(
                "${widget.schedule.dateTo.day}.${widget.schedule.dateTo.month}.${widget.schedule.dateTo.year}.",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localization.time),
              Text(
                '${widget.schedule.time.hour.toString().padLeft(2, '0')}:${widget.schedule.time.minute.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Container(),
              ),
              Text(localization.duration),
              Text(
                '${widget.schedule.duration} min',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Expanded(child: Container()),
          Switch(
            value: state,
            onChanged: (bool value) async {
              try {
                await Provider.of<SensorProvider>(context, listen: false)
                    .scheduleActivation(widget.schedule.id, value);
              } catch (e) {
                Get.snackbar(localization.warning, e.toString(),
                    backgroundColor: Theme.of(context).cardColor);
              }
            },
          )
        ],
      ),
    );
  }
}
