import 'dart:async';

import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/tile_info_column_widget.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/feature/home/widget/tile_info_row_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValveListItem extends StatefulWidget {
  const ValveListItem({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  State<ValveListItem> createState() => _ValveListItemState();
}

class _ValveListItemState extends State<ValveListItem> {
  String _timeString = "";
  Timer? timer;
  late AppLocalizations localization;

  int? getLastActiveDifference() {
    if (widget.sensor.lastActive == null) {
      return null;
    } else {
      return DateTime.now().difference(widget.sensor.lastActive!).inHours;
    }
  }

  bool checkEnabled() {
    if (widget.sensor.lastActive == null) {
      return false;
    } else if (DateTime.now().difference(widget.sensor.lastActive!).inHours >
        24) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _timeString = "";
    timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;
    //bool disabled = checkEnabled() ? false : true;

    return Container(
      width: double.maxFinite,
      height: 85,
      padding: const EdgeInsets.only(top: 5, left: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              //STATUS ICON
              widget.sensor.state == null
                  ? Icon(
                      Icons.circle,
                      color: Theme.of(context).disabledColor,
                      size: 15,
                    )
                  : !widget.sensor.state!
                      ? Icon(
                          Icons.circle,
                          color: !checkEnabled()
                              ? Theme.of(context).disabledColor
                              : Colors.orange,
                          size: 15,
                        )
                      : Icon(
                          Icons.circle,
                          color: !checkEnabled()
                              ? Theme.of(context).disabledColor
                              : Colors.green,
                          size: 15,
                        ),
              //SENSOR NAME
              Expanded(
                child: Text(
                  "  ${widget.sensor.name}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  //HUMIDITY
                  TileInfoRowWidget(
                    text:
                        "${widget.sensor.sensorData.humidity == null ? "N/A" : widget.sensor.sensorData.humidity!.toStringAsFixed(2)} %",
                    icon: Icons.water_drop_outlined,
                    color: !checkEnabled()
                        ? Theme.of(context).disabledColor
                        : null,
                    size: 20,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //TEMPERATURE
                  TileInfoRowWidget(
                    text:
                        "${widget.sensor.sensorData.temperature == null ? "N/A" : widget.sensor.sensorData.temperature!.toStringAsFixed(2)} °C",
                    icon: Icons.thermostat_outlined,
                    color: !checkEnabled()
                        ? Theme.of(context).disabledColor
                        : null,
                    size: 20,
                  ),
                ],
              ),
              //SCHEDULE
              Row(
                children: [
                  SizedBox(
                    //padding: const EdgeInsets.only(top: 15),
                    width: size.width * 0.33,
                    child: TileInfoColumnWidget(
                      text: _timeString == ""
                          ? localization.noSchedule
                          : _timeString,
                      icon: Icons.date_range_outlined,
                      color: !checkEnabled()
                          ? Theme.of(context).disabledColor
                          : null,
                      size: 30,
                    ),
                  ),
                  //WATER USAGE
                  SizedBox(
                    //padding: const EdgeInsets.only(top: 15),
                    width: size.width * 0.33,
                    child: TileInfoColumnWidget(
                      text: widget.sensor.waterUsageLast != null
                          ? localization.liters(double.parse(
                              widget.sensor.waterUsageLast!.toStringAsFixed(1)))
                          : "N/A",
                      icon: Icons.water,
                      color: !checkEnabled()
                          ? Theme.of(context).disabledColor
                          : null,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),

      /*Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, top: 5),
            width: MediaQuery.of(context).size.width * 0.25,
            height: double.maxFinite,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //STATUS ICON
                    widget.sensor.state == null
                        ? Icon(
                            Icons.circle,
                            color: Theme.of(context).disabledColor,
                            size: 15,
                          )
                        : !widget.sensor.state!
                            ? Icon(
                                Icons.circle,
                                color: !checkEnabled()
                                    ? Theme.of(context).disabledColor
                                    : Colors.orange,
                                size: 15,
                              )
                            : Icon(
                                Icons.circle,
                                color: !checkEnabled()
                                    ? Theme.of(context).disabledColor
                                    : Colors.green,
                                size: 15,
                              ),
                    //SENSOR NAME
                    Expanded(
                      child: Text(
                        "  ${widget.sensor.name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //HUMIDITY
                TileInfoRowWidget(
                  text:
                      "${widget.sensor.sensorData.humidity == null ? "N/A" : widget.sensor.sensorData.humidity!.toStringAsFixed(2)} %",
                  icon: Icons.water_drop_outlined,
                  color:
                      !checkEnabled() ? Theme.of(context).disabledColor : null,
                  size: 20,
                ),
                const SizedBox(
                  height: 5,
                ),
                //TEMPERATURE
                TileInfoRowWidget(
                  text:
                      "${widget.sensor.sensorData.temperature == null ? "N/A" : widget.sensor.sensorData.temperature!.toStringAsFixed(2)} °C",
                  icon: Icons.thermostat_outlined,
                  color:
                      !checkEnabled() ? Theme.of(context).disabledColor : null,
                  size: 20,
                ),
              ],
            ),
          ),
          //SCHEDULE
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: size.width * 0.33,
            child: TileInfoColumnWidget(
              text: _timeString == "" ? localization.noSchedule : _timeString,
              icon: Icons.date_range_outlined,
              color: !checkEnabled() ? Theme.of(context).disabledColor : null,
              size: 30,
            ),
          ),
          //WATER USAGE
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: size.width * 0.33,
            child: TileInfoColumnWidget(
              text: widget.sensor.waterUsageLast != null
                  ? localization.liters(double.parse(
                      widget.sensor.waterUsageLast!.toStringAsFixed(1)))
                  : "N/A",
              icon: Icons.water,
              color: !checkEnabled() ? Theme.of(context).disabledColor : null,
              size: 30,
            ),
          )
        ],
      ),*/
    );
  }

  void _getTime() {
    List<DateTime> irrigarionSchedules = [];
    if (widget.sensor.irregationSchedules.isNotEmpty) {
      for (IrregationScheduleResponse schedule
          in widget.sensor.irregationSchedules) {
        if (schedule.activated) {
          DateTime dateFrom = schedule.dateFrom;
          TimeOfDay time = schedule.time;
          DateTime dateTo = schedule.dateTo;

          var dateTimeFrom = DateTime(dateFrom.year, dateFrom.month,
              dateFrom.day, time.hour, time.minute);
          var dateTimeTo = DateTime(
              dateTo.year, dateTo.month, dateTo.day, time.hour, time.minute);

          while (dateTimeFrom.compareTo(dateTimeTo) <= 0) {
            irrigarionSchedules.add(dateTimeFrom);
            dateTimeFrom = dateTimeFrom.add(const Duration(days: 1));
          }
        }
      }

      irrigarionSchedules.sort(((a, b) => a.compareTo(b)));
      if (irrigarionSchedules.isEmpty) {
        setState(() {
          _timeString = "";
        });
      }
      for (var date in irrigarionSchedules) {
        if ((DateTime.now()).compareTo(date) < 0) {
          var timeDifference = date.difference(DateTime.now());
          setState(
            () {
              if (timeDifference.inMinutes <= 1) {
                _timeString = localization.seconds(timeDifference.inSeconds);
              } else if (timeDifference.inHours <= 1) {
                _timeString = localization.minutes(timeDifference.inMinutes);
              } else if (timeDifference.inDays <= 1) {
                _timeString = localization.hours(timeDifference.inHours);
              } else {
                _timeString = localization.days(timeDifference.inDays);
              }
            },
          );
          break;
        } else {
          setState(() {
            _timeString = "";
          });
        }
      }
    } else {
      setState(() {
        _timeString = "";
      });
    }
  }
}
