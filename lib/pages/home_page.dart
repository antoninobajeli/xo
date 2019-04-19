import 'package:flutter/material.dart';
import 'package:xo/observable_listeners/app_states.dart';
import 'package:xo/globals.dart';
import 'package:xo/api_services.dart';
import 'package:xo/settings.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> implements AppStateListener{
  bool _isServerAvailable=false;
  bool _isConnecting=false;
  bool _isIniting=false;

  var stateProvider = AppStateProvider();


  _MyHomePageState(){
    stateProvider.subscribe(this);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateProvider.notify(ObserverAppState.INITING);
    Settings.loadPrefs();

  }


  @override
  void onStateChanged(ObserverAppState state) {
    // TODO: implement onStateChanged
    switch (state) {
      case ObserverAppState.INITING:
        _isIniting=true;
        break;
      case ObserverAppState.INITED:
        setState(() {
          _isIniting=false;
          _isConnecting=true;
        });
        ApiServices.checkConnection().then((connected) {
          (connected)
              ?stateProvider.notify(ObserverAppState.CONNECTED)
              :stateProvider.notify(ObserverAppState.DISCONNECTED);
        });
        _isIniting=false;
        break;
      case ObserverAppState.DISCONNECTED:
        _isServerAvailable=false;
        break;
      case ObserverAppState.CONNECTING:break;
      case ObserverAppState.CONNECTED:
        setState(() {
          _isServerAvailable=true;
        });

        break;
    }
  }

  _incrementCounter(){

  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: AppBar(

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              (_isServerAvailable)
                  ?'Connected to '+Settings.serverHost
                  :'Server unreachable',
            ),
            Text(
              'List of games',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: (_isServerAvailable)
          ?FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Create New',
        child: Icon(Icons.add),
      )
          :Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
