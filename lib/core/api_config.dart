import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get beeceptorApiKey => dotenv.env['BEECEPTOR_API_KEY'] ?? '';
  static final String beeceptorBaseUrl = 'https://$beeceptorApiKey.proxy.beeceptor.com/api';
}
