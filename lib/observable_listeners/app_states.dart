
enum ObserverAppState { INITING, INITED, CONNECTING, CONNECTED, DISCONNECTED}


abstract class AppStateListener {
  void onStateChanged(ObserverAppState state);
}


class AppStateProvider {
  List<AppStateListener> observers;
  static final AppStateProvider _instance = new AppStateProvider.internal();
  factory AppStateProvider() => _instance;

  AppStateProvider.internal() {
    observers = new List<AppStateListener>();
    initState();
  }

  void initState() async {
    notify(ObserverAppState.INITING);
  }

  void subscribe(AppStateListener listener) {
    observers.add(listener);
  }
  void notify(dynamic state) {
    observers.forEach((AppStateListener obj) => obj.onStateChanged(state));
  }
  void dispose(AppStateListener thisObserver) {
    for (var obj in observers) {
      if (obj == thisObserver) {
        observers.remove(obj);
      }}}
}