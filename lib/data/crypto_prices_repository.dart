class CryptoPricesRepository {
  Future<Map<String, double>> getCryptoPrices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'Bitcoin': 67421.33,
      'Ethereum': 3450.10,
    };
  }
}
