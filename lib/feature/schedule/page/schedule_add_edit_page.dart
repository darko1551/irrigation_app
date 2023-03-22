import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/request/irrigation_schedule_request.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class ScheduleAddEditPage extends StatefulWidget {
  const ScheduleAddEditPage({super.key, this.schedule, this.sensor});
  final IrregationScheduleResponse? schedule;
  final SensorResponse? sensor;

  @override
  State<ScheduleAddEditPage> createState() => _ScheduleAddEditPageState();
}

class _ScheduleAddEditPageState extends State<ScheduleAddEditPage> {
  late TextEditingController _durationController;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  TimeOfDay? _time;

  @override
  void initState() {
    _durationController = TextEditingController();
    if (widget.schedule != null) {
      _dateFrom = widget.schedule!.dateFrom;
      _dateTo = widget.schedule!.dateTo;
      _time = widget.schedule!.time;
      _durationController.text = widget.schedule!.duration.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  bool checkParameters(bool displayMessages) {
    if (_dateFrom == null ||
        _dateTo == null ||
        _time == null ||
        _durationController.text.isEmpty) {
      if (displayMessages) {
        Get.snackbar("Warning", "Not all parameters inserted!",
            backgroundColor: Theme.of(context).cardColor);
      }
      return false;
    }
    if (_dateFrom!.compareTo(_dateTo!) > 0) {
      if (displayMessages) {
        Get.snackbar("Warning", "Date to is before Date from!",
            backgroundColor: Theme.of(context).cardColor);
      }
      return false;
    }

    if (double.tryParse(_durationController.text) == null) {
      if (displayMessages) {
        Get.snackbar("Warning", "Duration must be integer!",
            backgroundColor: Theme.of(context).cardColor);
      }
      return false;
    }
    return true;
  }

  Future<bool> addSchedule() async {
    bool success = false;
    bool validParameters = checkParameters(true);
    if (validParameters) {
      IrrigationScheduleRequest scheduleRequest = IrrigationScheduleRequest(
          dateFrom: _dateFrom!,
          dateTo: _dateTo!,
          time: _time!,
          doNotIrrigate: true,
          duration: double.parse(_durationController.text));
      try {
        await Provider.of<SensorProvider>(context, listen: false)
            .addSchedule(widget.sensor!.sensorId, scheduleRequest);
        success = true;
        Get.snackbar("Success", "Schedule added successfully",
            backgroundColor: Theme.of(context).cardColor);
      } catch (e) {
        Get.snackbar("Warning", e.toString(),
            backgroundColor: Theme.of(context).cardColor);
      }
    }
    return success;
  }

  Future<bool> editSchedule() async {
    bool success = false;
    bool validParameters = checkParameters(true);
    if (validParameters) {
      IrrigationScheduleRequest scheduleRequest = IrrigationScheduleRequest(
          dateFrom: _dateFrom!,
          dateTo: _dateTo!,
          time: _time!,
          doNotIrrigate: true,
          duration: double.parse(_durationController.text));
      try {
        await Provider.of<SensorProvider>(context, listen: false)
            .editSchedule(widget.schedule!.id, scheduleRequest);
        success = true;
        Get.snackbar("Success", "Schedule edited successfully",
            backgroundColor: Theme.of(context).cardColor);
      } catch (e) {
        Get.snackbar("Warning", e.toString(),
            backgroundColor: Theme.of(context).cardColor);
      }
    }
    return success;
  }

  Future<bool> removeSchedule() async {
    bool success = false;
    try {
      await Provider.of<SensorProvider>(context, listen: false)
          .removeSchedule(widget.schedule!.id);
      success = true;
      Get.snackbar("Success", "Schedule removed successfully");
    } catch (e) {
      Get.snackbar("Warning", e.toString());
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    bool networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? "Add schedule" : "Edit schedule"),
        actions: [
          widget.schedule != null
              ? IconButton(
                  onPressed: networkStatus
                      ? () {
                          removeSchedule();
                          Get.back();
                        }
                      : null,
                  icon: const Icon(Icons.delete_outline),
                )
              : Container(),
          IconButton(
              onPressed: networkStatus
                  ? () async {
                      //widget.schedule != null ? addSchedule():;
                      bool success;
                      if (widget.schedule != null) {
                        success = await editSchedule();
                      } else {
                        success = await addSchedule();
                      }
                      if (success) {
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  : null,
              icon: const Icon(Icons.check))
        ],
      ),
      body: networkStatus
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //DATE FROM

                  const Text("Date from"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Text(
                          _dateFrom == null
                              ? "Insert date"
                              : "${_dateFrom!.day}.${_dateFrom!.month}.${_dateFrom!.year}.",
                          style: TextStyle(
                              fontSize: 18,
                              color: _dateFrom == null
                                  ? Theme.of(context).hintColor
                                  : null),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () async {
                              _dateFrom = await showDatePicker(
                                  context: context,
                                  initialDate: _dateFrom ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              setState(() {});
                            },
                            icon: const Icon(Icons.date_range))
                      ],
                    ),
                  ),

                  //DATE TO
                  const SizedBox(height: 20),
                  const Text("Date to"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Text(
                          _dateTo == null
                              ? "Insert date"
                              : "${_dateTo!.day}.${_dateTo!.month}.${_dateTo!.year}.",
                          style: TextStyle(
                              fontSize: 18,
                              color: _dateTo == null
                                  ? Theme.of(context).hintColor
                                  : null),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () async {
                              _dateTo = await showDatePicker(
                                  context: context,
                                  initialDate: _dateTo ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              setState(() {});
                            },
                            icon: const Icon(Icons.date_range))
                      ],
                    ),
                  ),

                  //START TIME
                  const SizedBox(height: 20),
                  const Text("Time"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Text(
                          _time == null
                              ? "Insert time"
                              : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: 18,
                              color: _time == null
                                  ? Theme.of(context).hintColor
                                  : null),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () async {
                              _time = await showTimePicker(
                                  context: context,
                                  initialTime: _time ?? TimeOfDay.now());
                              setState(() {});
                            },
                            icon: const Icon(Icons.watch_later_outlined)),
                      ],
                    ),
                  ),

                  //DURATION
                  const SizedBox(height: 20),
                  const Text("Duration (min)"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      controller: _durationController,
                      decoration: const InputDecoration(
                          hintText: "Insert duration",
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            )
          : const NoInternetWidget(),
    );
  }
}
