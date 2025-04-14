import 'package:abaez/domain/quote.dart';


class QuoteRepository {
  Future<List<Quote>> fetchQuotes() async {
    // Simula un retraso de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Devuelve una lista inicial de cotizaciones
    return [
      Quote(companyName: 'Apple', stockPrice: 150.25, changePercentage: 2.5, lastUpdated: DateTime.now()),
      Quote(companyName: 'Google', stockPrice: 2800.50, changePercentage: -1.2, lastUpdated: DateTime.now()),
      Quote(companyName: 'Amazon', stockPrice: 3400.75, changePercentage: 0.8, lastUpdated: DateTime.now()),
      Quote(companyName: 'Microsoft', stockPrice: 299.99, changePercentage: 1.1,lastUpdated: DateTime.now()),
      Quote(companyName: 'Tesla', stockPrice: 720.30, changePercentage: -0.5, lastUpdated: DateTime.now()),
      Quote(companyName: 'Meta', stockPrice: 350.00, changePercentage: 3.0, lastUpdated: DateTime.now()),
      Quote(companyName: 'IBM', stockPrice: 140.00, changePercentage: 1.8, lastUpdated: DateTime.now()),      
      Quote(companyName: 'Adobe', stockPrice: 500.00, changePercentage: -1.0, lastUpdated: DateTime.now()),      
      Quote(companyName: 'Netflix', stockPrice: 600.00, changePercentage: -2.5, lastUpdated: DateTime.now()),
      Quote(companyName: 'Spotify', stockPrice: 150.00, changePercentage: 1.5, lastUpdated: DateTime.now()),

    ];
  }
}