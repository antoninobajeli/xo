import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:xo/observable_listeners/app_states.dart';
import 'secp256k1.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/export.dart";
import "package:pointycastle/ecc/api.dart";

const String sharedPreferenceRestApiSettingsKey='rest_api_settings';
const String defaultRestApiAddress="http://192.168.254.101:8008";


const String sharedPreferencePrivateKey='private_key';
const String sharedPreferencePublicKey='public_key';



enum UserSettingDetail {
  HIDE_MY_POSITION,
}



class Settings {
  static String serverHost="";
  static String privateKey;
  static String publicKey;
  static AsymmetricKeyPair<PublicKey, PrivateKey> keyPair;


  static final Settings _instance = new Settings.internal();
  factory Settings() => _instance;

  Settings.internal();

   static void loadPrefs() {
    var stateProvider = AppStateProvider();
    Future<SharedPreferences> prefsLoader = SharedPreferences.getInstance();

    prefsLoader.then((SharedPreferences sharePref) {
      serverHost = (sharePref.getString(sharedPreferenceRestApiSettingsKey)?? defaultRestApiAddress);
      stateProvider.notify(ObserverAppState.INITED);

      privateKey = (sharePref.getString(sharedPreferencePrivateKey)?? getPrivateKey(sharePref,sharedPreferencePrivateKey));
      publicKey = (sharePref.getString(sharedPreferencePublicKey)?? getPublicKey(sharePref,sharedPreferencePublicKey));

      print("privateKey $privateKey");

      print("publicKey $publicKey");

    });
  }

  static String getPrivateKey(SharedPreferences prefs,String _sharedPreferenceKey){

    ECPrivateKey _privateKey;
    if (keyPair == null) {
      keyPair = secp256k1KeyPair();
    }
    _privateKey = keyPair.privateKey;

    String hexPrivateKey=_privateKey.d.toRadixString(16);
    // in decimal
    print(_privateKey.d);
    // in hex
    print(hexPrivateKey);
    prefs.setString(_sharedPreferenceKey, hexPrivateKey);
    return hexPrivateKey;
  }


  static String getPublicKey(SharedPreferences prefs,String _sharedPreferenceKey){
    ECPublicKey _publicKey;
    if (keyPair == null) {
      keyPair = secp256k1KeyPair();
    }
    _publicKey = keyPair.publicKey;

    print("Encoded Public ${_publicKey.Q.getEncoded(false)}");

    print("_publicKey.Q.x ${_publicKey.Q.x.toBigInteger().toRadixString(16)}");
    print("_publicKey.Q.y ${_publicKey.Q.y.toBigInteger().toRadixString(16)}");
    String hexPublicKey=_publicKey.Q.x.toBigInteger().toRadixString(16)+_publicKey.Q.x.toBigInteger().toRadixString(16);

    prefs.setString(_sharedPreferenceKey, hexPublicKey);
    return hexPublicKey;
  }

  Future<String> getRestApiUrl(String settingsKey,String urlDefaultValue) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    String serverHost = (sharePref.getString(settingsKey)?? urlDefaultValue);
    return serverHost;
  }

}