import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/home/page/home_page.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:irrigation/theme/styles.dart';
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
        ChangeNotifierProvider(
          create: (_) => DarkThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    Provider.of<DarkThemeProvider>(context, listen: false).darkTheme =
        await Provider.of<DarkThemeProvider>(context, listen: false)
            .darkThemePreference
            .getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Irregation',
      theme: Styles.themeData(
          Provider.of<DarkThemeProvider>(context).darkTheme, context),
      home: const HomePage(),
    );
  }
}
