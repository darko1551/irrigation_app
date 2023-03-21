import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/network_connectivity.dart';

class NetworkProvider extends ChangeNotifier {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  bool networkStatus = false;

  NetworkProvider() {
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      if (_source.keys.toList()[0] == ConnectivityResult.none) {
        networkStatus = false;
      } else {
        networkStatus = true;
      }
      notifyListeners();
    });
  }
}
