import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/home/page/home_page.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SensorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NetworkProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Irregation',
      theme: ThemeData(
        hintColor: Colors.grey[700],
        dialogTheme: const DialogTheme(
          backgroundColor: Color.fromARGB(255, 247, 245, 245),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 17),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 0, 69, 146)),
        primaryColor: const Color.fromARGB(255, 0, 69, 146),
        cardColor: const Color.fromARGB(255, 247, 245, 245),
        indicatorColor: Colors.cyan,
        scaffoldBackgroundColor: const Color.fromARGB(255, 203, 218, 225),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 69, 146)),
        disabledColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 69, 146),
          foregroundColor: Color.fromARGB(255, 231, 231, 231),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 0, 69, 146),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        hintColor: Colors.grey[400],
        dialogTheme: const DialogTheme(
          backgroundColor: Color.fromARGB(255, 66, 66, 66),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 17),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 128, 191, 226)),
        primaryColor: const Color.fromARGB(255, 41, 41, 41),
        cardColor: const Color.fromARGB(255, 66, 66, 66),
        indicatorColor: Colors.cyan,
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 128, 191, 226)),
        disabledColor: const Color.fromARGB(255, 192, 190, 190),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 41, 41, 41),
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 128, 191, 224),
            ),
            foregroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 18, 18, 18),
            ),
          ),
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white)),
      ),
      home: const HomePage(),
    );
  }
}
