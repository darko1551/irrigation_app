class ExceptionStrings {
  static const String sensorDoesNotExist = "Sensor does not exist";
  static const String userDoesNotExist = "User does not exist";
  static const String sensorMacAlreadyExists =
      "Sensor with specified mac already exists";
  static const String sensorNameAlreadyExists =
      "Sensor with specified name already exists";
  static const String macNotValid = "Mac address is not valid";
  static const String scheduleAlreadyExists =
      "Schedule with same parameters already exists";
  static const String scheduleDoesNotExist = "Schedule does not exist";
  static const String scheduleOverlap = "Schedule overlap";
  static const String somethingWentWrong = "Something went wrong";

  static List<String> exceptionStringList = [
    sensorDoesNotExist,
    userDoesNotExist,
    sensorMacAlreadyExists,
    sensorNameAlreadyExists,
    macNotValid,
    scheduleAlreadyExists,
    scheduleDoesNotExist,
    scheduleOverlap,
    somethingWentWrong
  ];
  static const String serverError = "Server error";
}
