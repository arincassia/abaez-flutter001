import 'package:abaez/domain/quote.dart';
import 'package:abaez/data/quote_repository.dart';
import 'package:abaez/constans.dart'; 

class QuoteService {
  final QuoteRepository _quoteRepository;

  QuoteService(this._quoteRepository);

  Future<List<Quote>> getQuotes({required int pageNumber, int pageSize = AppConstants.pageSize}) async {
    final quotes = await _quoteRepository.fetchQuotes();
    return quotes.where((quote) => quote.stockPrice > 0).toList();
   
  }

 Future<List<Quote>> getPaginatedQuotes({required int pageNumber, int pageSize = 5}) async {
  if (pageNumber < 1) {
    throw Exception(AppConstants.errorMessage); // Número de página inválido
  }
  if (pageSize <= 0) {
    throw Exception(AppConstants.errorMessage); // Tamaño de página inválido
  }

  // Llama directamente al repositorio para obtener las cotizaciones paginadas
  final quotes = await _quoteRepository.getPaginatedQuotes(
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  for (final quote in quotes) {
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        throw Exception(AppConstants.errorMessage);
      }
    }

  return quotes.where((quote) => quote.stockPrice > 0).toList();
}
}