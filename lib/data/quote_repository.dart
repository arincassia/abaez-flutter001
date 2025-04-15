import 'package:abaez/domain/quote.dart';
import 'dart:math';

class QuoteRepository {
  final random = Random();  
  final List<String> companyNames = [
    'Apple',
    'Google',
    'Amazon',
    'Microsoft',
    'Tesla',
    'Meta',
    'IBM',
    'Adobe',
    'Netflix',
    'Spotify',
    'Intel',
    'NVIDIA',
    'Samsung',
    'Oracle',
    'Cisco',
    'Salesforce',
    'Twitter',
    'Snapchat',
    'Zoom',
    'PayPal',
  ];

 
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
  Future<List<Quote>> getPaginatedQuotes({required int pageNumber, int pageSize = 5}) async {
  await Future.delayed(const Duration(seconds: 2)); 
  final offset = (pageNumber - 1) * pageSize;

  return List.generate(pageSize, (index) {
    final quoteNumber = offset + index + 1; 
    final companyName = companyNames[random.nextInt(companyNames.length)];
    final stockPrice = (random.nextDouble() * 3000 + 50).toStringAsFixed(2); 
    final changePercentage = (random.nextDouble() * 10 - 5).toStringAsFixed(2); 
    return Quote(
      companyName: '$companyName $quoteNumber',
      stockPrice: double.parse(stockPrice),
      changePercentage: double.parse(changePercentage),
      lastUpdated: DateTime.now(),
    );
  });
}
 
}