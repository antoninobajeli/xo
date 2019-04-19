import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ApiServices {

  static Future<bool> checkConnection() async {
    ConnectivityResult connectivityResult = await (new Connectivity()
        .checkConnectivity());
    debugPrint(connectivityResult.toString());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }
}