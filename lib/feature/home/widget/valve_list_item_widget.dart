import 'dart:async';

import 'package:flutter/material.dart';
import 'package:irrigation/feature/home/widget/tile_info_column_widget.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/feature/home/widget/tile_info_row_widget.dart';

class ValveListItem extends StatefulWidget {
  const ValveListItem({super.key, required this.sensor});

  final SensorResponse sensor;

  @override
  State<ValveListItem> createState() => _ValveListItemState();
}

class _ValveListItemState extends State<ValveListItem> {
  String _timeString = "";
  Timer? timer;

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
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool disabled = checkEnabled() ? false : true;

    return Container(
      width: double.maxFinite,
      height: 85,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
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
                    !widget.sensor.state
                        ? Icon(
                            Icons.circle,
                            color: disabled
                                ? Theme.of(context).disabledColor
                                : Colors.orange,
                            size: 15,
                          )
                        : Icon(
                            Icons.circle,
                            color: disabled
                                ? Theme.of(context).disabledColor
                                : Colors.green,
                            size: 15,
                          ),
                    Text(
                      "  ${widget.sensor.name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TileInfoRowWidget(
                  text: "${widget.sensor.sensorData.humidity ?? "N/A"} %",
                  icon: Icons.water_drop_outlined,
                  color: disabled ? Theme.of(context).disabledColor : null,
                  size: 20,
                ),
                const SizedBox(
                  height: 5,
                ),
                TileInfoRowWidget(
                  text: "${widget.sensor.sensorData.temperature ?? "N/A"} °C",
                  icon: Icons.thermostat_outlined,
                  color: disabled ? Theme.of(context).disabledColor : null,
                  size: 20,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: size.width * 0.33,
            child: TileInfoColumnWidget(
              text: _timeString == "" ? "No schedule" : _timeString,
              icon: Icons.date_range_outlined,
              color: disabled ? Theme.of(context).disabledColor : null,
              size: 30,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: size.width * 0.33,
            child: TileInfoColumnWidget(
              text: "${widget.sensor.waterUsageLast ?? "N/A"} liters",
              icon: Icons.water,
              color: disabled ? Theme.of(context).disabledColor : null,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  void _getTime() {
    List<DateTime> irrigarionSchedules = [];

    if (widget.sensor.irregationSchedules.isNotEmpty) {
      DateTime dateFrom = widget.sensor.irregationSchedules[0].dateFrom;
      TimeOfDay time = widget.sensor.irregationSchedules[0].time;
      DateTime dateTo = widget.sensor.irregationSchedules[0].dateTo;

      var dateTimeFrom = DateTime(
          dateFrom.year, dateFrom.month, dateFrom.day, time.hour, time.minute);
      var dateTimeTo = DateTime(
          dateTo.year, dateTo.month, dateTo.day, time.hour, time.minute);

      while (dateTimeFrom.compareTo(dateTimeTo) <= 0) {
        irrigarionSchedules.add(dateTimeFrom);
        dateTimeFrom = dateTimeFrom.add(const Duration(days: 1));
      }

      for (var date in irrigarionSchedules) {
        if ((DateTime.now()).compareTo(date) < 0) {
          var timeDifference = date.difference(DateTime.now());
          setState(
            () {
              if (timeDifference.inMinutes <= 1) {
                _timeString = "${timeDifference.inSeconds.toString()} seconds";
              } else if (timeDifference.inHours <= 1) {
                _timeString = "${timeDifference.inMinutes.toString()} minutes";
              } else if (timeDifference.inDays <= 1) {
                _timeString = "${timeDifference.inHours.toString()} hours";
              } else {
                _timeString = "${timeDifference.inDays.toString()} days";
              }
            },
          );
          break;
        }
      }
    }
  }
}
