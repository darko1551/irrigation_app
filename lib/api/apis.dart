class Apis {
  static const String getSensors = '/sensors/{userId}';
  static const String getSensorByMac = '/sensors/{userId}/{mac}';
  static const String addSensor = '/sensors';
  static const String updateSensor = '/sensors/{userId}/{sensorId}';
  static const String deleteSensor = '/sensors/{userId}/{sensorId}';
  static const String getSchedules = '/schedules/{userId}/{sensorId}';
  static const String addSchedule = '/schedules/{userId}/{sensorId}';
  static const String deleteSchedule = '/schedules/{userId}/{scheduleId}';
  static const String updateSchedule = '/schedules/{userId}/{scheduleId}';
  static const String activationActivationUpdate =
      '/schedules/activation/{userId}/{scheduleId}';
  static const String getUsers = '/users';
}
