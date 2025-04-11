import 'dart:async';

class MockAuthService {
  Future<void> login(String username, String password) async {
    // Validar que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Error: El nombre de usuario y la contraseña no pueden estar vacíos.');
     
    }

    // Simula un retraso para imitar una llamada a un servicio real
    await Future.delayed(Duration(seconds: 1));

    // Imprime las credenciales en la consola
    //print('Mock Login:');
    //print('Username: $username');
    //print('Password: $password');
    return;
  }
}

void main() {
  final authService = MockAuthService();

  // Simula un login
  authService.login('test_user', 'password123');
}