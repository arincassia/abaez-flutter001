class AgroCommoditiesRepository {
  Future<Map<String, double>> getCommoditiesPrices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'Soja': 512.75,
      'Maíz': 318.90,
      'Trigo': 440.60,
    };
  }
}
