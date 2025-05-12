import 'package:dart_mappable/dart_mappable.dart';

part 'login_response.mapper.dart';

/// Modelo que representa la respuesta de la API de inicio de sesión
@MappableClass()
class LoginResponse with LoginResponseMappable {
  /// Token de sesión JWT
  @MappableField(key: 'session_token')
  final String sessionToken;

  /// Constructor principal
  const LoginResponse({
    required this.sessionToken,
  });


}
