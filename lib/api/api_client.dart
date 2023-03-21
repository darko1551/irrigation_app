import 'package:dio/dio.dart';
import 'package:irrigation/api/apis.dart';
import 'package:irrigation/models/request/irrigation_schedule_request.dart';
import 'package:irrigation/models/request/sensor_request.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/models/update/sensor_update.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

//@RestApi(baseUrl: "http://10.10.10.86:5108/api/SensorData/")
@RestApi(baseUrl: "https://10.10.10.86:443/Irregation/api/SensorData")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.sensors)
  Future<List<SensorResponse>> getSensors();

  @DELETE(Apis.sensorsDelete)
  Future<void> deleteSensor(@Path() int id);

  @POST(Apis.sensors)
  Future<int> addSensor(@Body() SensorRequest sensor);

  @PUT(Apis.sensorsEdit)
  Future<int> editSensor(@Path() int id, @Body() SensorUpdate sensor);

  @GET(Apis.schedules)
  Future<List<IrregationScheduleResponse>> getSchedules(@Path() int id);

  @PUT(Apis.schedulesActivation)
  Future<int> scheduleActivation(@Path() int id, @Body() bool status);

  @POST(Apis.schedulesAdd)
  Future<int> addSchedule(
      @Path() int sensorId, @Body() IrrigationScheduleRequest scheduleRequest);

  @DELETE(Apis.schedules)
  Future<void> deleteSchedule(@Path() int id);

  @PUT(Apis.schedules)
  Future<int> editSchedule(
      @Path() int id, @Body() IrrigationScheduleRequest scheduleRequest);
}
