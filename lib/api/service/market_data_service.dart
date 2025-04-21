import 'package:abaez/data/agro_commodities_repository.dart';
import 'package:abaez/data/crypto_prices_repository.dart';
import 'package:abaez/data/stock_market_repository.dart';

class MarketDataService {
  //Composición
  final CryptoPricesRepository cryptoRepo;
  final AgroCommoditiesRepository agroRepo;
  final StockMarketRepository stockRepo;

  MarketDataService({
    required this.cryptoRepo,
    required this.agroRepo,
    required this.stockRepo,
  });

  Future<Map<String, dynamic>> getAllMarketData() async {
    final crypto = await cryptoRepo.getCryptoPrices();
    final agro = await agroRepo.getCommoditiesPrices();
    final stocks = await stockRepo.getStockPrices();

    return {
      'Criptomonedas': crypto,
      'Agro': agro,
      'Acciones': stocks,
    };
  }
}
