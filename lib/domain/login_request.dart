import 'package:dart_mappable/dart_mappable.dart';

part 'login_request.mapper.dart';

/// Modelo que representa la solicitud de inicio de sesión
@MappableClass()
class LoginRequest with LoginRequestMappable {
  /// correo electrónico para iniciar sesión
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

}
