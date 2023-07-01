class NavigationState {
  static final NavigationState _instance = NavigationState._internal();

  factory NavigationState() {
    return _instance;
  }

  NavigationState._internal();

  int currentIndex = 0;
}
