import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetEnvConfig {
  GetEnvConfig._();
  static final String keyEnvironmentFile = '.env';
  static final String apiKey = dotenv.get('API_KEY');
  static final String baseUrl = dotenv.get('BASE_URL');
}
