import 'package:dio/dio.dart';
import 'package:irrigation/api/apis.dart';
import 'package:irrigation/models/request/irrigation_schedule_request.dart';
import 'package:irrigation/models/request/sensor_request.dart';
import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/models/response/user_response.dart';
import 'package:irrigation/models/update/sensor_update.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

//@RestApi(baseUrl: "http://10.10.10.86:5108/api/SensorData/")
@RestApi(baseUrl: "https://10.10.10.86:443/Irregation/api/SensorData")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.getSensors)
  Future<List<SensorResponse>> getSensors(@Path() int userId);

  @DELETE(Apis.deleteSensor)
  Future<void> deleteSensor(@Path() int userId, int sensorId);

  @POST(Apis.addSensor)
  Future<int> addSensor(@Body() SensorRequest sensor);

  @PUT(Apis.updateSensor)
  Future<int> updateSensor(
      @Path() int userId, int sensorId, @Body() SensorUpdate sensor);

  @GET(Apis.getSchedules)
  Future<List<IrregationScheduleResponse>> getSchedules(
      @Path() int userId, int sensorId);

  @PUT(Apis.activationActivationUpdate)
  Future<int> activationActivationUpdate(
      @Path() int userId, int scheduleId, @Body() bool status);

  @POST(Apis.addSchedule)
  Future<int> addSchedule(@Path() int userId, int sensorId,
      @Body() IrrigationScheduleRequest scheduleRequest);

  @DELETE(Apis.deleteSchedule)
  Future<void> deleteSchedule(@Path() int userId, int scheduleId);

  @PUT(Apis.updateSchedule)
  Future<int> updateSchedule(@Path() int userId, int scheduleid,
      @Body() IrrigationScheduleRequest scheduleRequest);

  @GET(Apis.getUsers)
  Future<List<UserResponse>> getUsers();
}
