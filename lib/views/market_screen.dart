import 'package:abaez/api/service/market_data_service.dart';
import 'package:abaez/data/agro_commodities_repository.dart';
import 'package:abaez/data/crypto_prices_repository.dart';
import 'package:abaez/data/stock_market_repository.dart';
import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  final MarketDataService service = MarketDataService(
    cryptoRepo: CryptoPricesRepository(),
    agroRepo: AgroCommoditiesRepository(),
    stockRepo: StockMarketRepository(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones del Mercado'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: service.getAllMarketData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text('Ocurrió un error 😕'));
          }

          final data = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16),
            children: data.entries.map((category) {
              final sectionData = category.value as Map<String, double>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.key,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...sectionData.entries.map(
                    (entry) => Text('${entry.key}: \$${entry.value.toStringAsFixed(2)}'),
                  ),
                  SizedBox(height: 24),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}