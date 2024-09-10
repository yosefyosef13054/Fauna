enum ObserverState {
  INIT,
  TOGGLE,
  UPDATEBREEDER,
  UPDATEBREEDERFROMBREEDER,
  UPDATEPROFILE,
  NOTIFICATION,
  UPDATECHATLIST,
  UPDATECOUNTER,
  UPDATECOUNTERNOTIFICATION
}

abstract class StateListener {
  void onStateChanged(ObserverState state, Map<String, dynamic> dict);
}

//Singleton reusable class
class StateProvider {
  List<StateListener> observers;

  static final StateProvider _instance = new StateProvider.internal();
  factory StateProvider() => _instance;

  StateProvider.internal() {
    observers = new List<StateListener>();
    initState();
  }

  void initState() async {
    notify(ObserverState.INIT, null);
  }

  void subscribe(StateListener listener) {
    observers.add(listener);
  }

  void notify(dynamic state, Map<String, dynamic> dict) {
    observers.forEach((StateListener obj) => obj.onStateChanged(state, dict));
  }

  void dispose(StateListener thisObserver) {
    for (var obj in observers) {
      if (obj == thisObserver) {
        observers.remove(obj);
      }
    }
  }
}
