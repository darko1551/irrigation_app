import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/bluetooth/page/bluetooth_scan_page.dart';
import 'package:irrigation/provider/bluetooth_provider.dart';
import 'package:irrigation/feature/login/login_page.dart';
import 'package:irrigation/provider/dark_theme_provider.dart';
import 'package:irrigation/provider/localization_provider.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:irrigation/provider/user_provider.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  UserProvider userProviderr = UserProvider();
  await userProviderr.initClientCredentials();

  HttpOverrides.global = MyHttpOverrides();
  LocalizationProvider pro = LocalizationProvider();
  await pro.initLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => userProviderr,
        ),
        ChangeNotifierProxyProvider<UserProvider, SensorProvider>(
            create: (_) => SensorProvider(),
            update: (_, userProvider, sensorProvider) {
              return sensorProvider!..userProvider = userProviderr;
            }),
        ChangeNotifierProvider(
          create: (_) => NetworkProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DarkThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => pro,
        ),
        ChangeNotifierProvider(
          create: (_) => BluetoothProvider(),
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
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hr', ''),
      ],
      theme:
          Styles.themeData(Provider.of<DarkThemeProvider>(context).darkTheme),
      //theme: Styles.themeData(true),
      locale: Provider.of<LocalizationProvider>(context).locale,
      home: const LoginPage(),
    );
  }
}
