enum FlavorType {
  free,
  paid,
  debugging,
}

class FlavorValues {
  final String titleApp;

  const FlavorValues({
    this.titleApp = "FLYPE",
  });
}

class FlavorConfig {
  final FlavorType flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.debugging,
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}