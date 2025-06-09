import 'package:abaez/api/service/base_service.dart';
import 'package:abaez/domain/login_request.dart';
import 'package:abaez/domain/login_response.dart';
import 'package:abaez/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dynamic data;
      final List<LoginRequest> usuariosTest = [
        const LoginRequest(username: 'profeltes', password: 'sodep'),
        const LoginRequest(username: 'Moni', password: 'sodep'),
        const LoginRequest(username: 'sodep', password: 'sodep'),
        const LoginRequest(username: 'visitante', password: 'sodep'),
      ];

      // Verificar si las credenciales coinciden con algún usuario de prueba
      bool credencialesValidas = usuariosTest.any(
        (usuario) =>
            usuario.username == request.username &&
            usuario.password == request.password,
      );
       if (credencialesValidas) {
        data = await postUnauthorized('/login', data: request.toJson());
      }

      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException('Error de autenticación: respuesta vacía');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Error en login');
      }
    }
  }
}

