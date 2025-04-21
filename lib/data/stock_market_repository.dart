class StockMarketRepository {
  Future<Map<String, double>> getStockPrices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'AAPL': 187.56,
      'MSFT': 322.10,
      'GOOGL': 134.67,
    };
  }
}
