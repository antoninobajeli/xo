import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:xo/observable_listeners/app_states.dart';


const String sharedPreferenceServerHost='server_host';
const String defaultServerHostVal="hppt://localhost";


const String sharedPreferencePrivateKey='private_key';
const String sharedPreferencePublicKey='public_key';



enum UserSettingDetail {
  HIDE_MY_POSITION,
}



class Settings {
  static String serverHost="";

  static final Settings _instance = new Settings.internal();
  factory Settings() => _instance;

  Settings.internal();

  static void loadPrefs() {
    var stateProvider = AppStateProvider();
    Future<SharedPreferences> prefsLoader = SharedPreferences.getInstance();
    prefsLoader.then((SharedPreferences sharPref) {
      serverHost = (sharPref.getString(sharedPreferenceServerHost)?? defaultServerHostVal);
      stateProvider.notify(ObserverAppState.INITED);
    });
  }


  Future<String> getServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serverHost = (prefs.getString('serverHost') ?? defaultServerHost);
    return serverHost;
  }
}