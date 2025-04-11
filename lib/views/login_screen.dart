import 'package:flutter/material.dart';
import 'package:abaez/api/service/auth_service.dart';
import 'package:abaez/views/welcom_srceen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MockAuthService _authService = MockAuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de Usuario
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El campo Usuario es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El campo Contraseña es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () async {
                  // Validar el formulario
                  if (_formKey.currentState?.validate() ?? false) {
                    final username = _usernameController.text.trim();
                    final password = _passwordController.text.trim();

                    // Llama al servicio de autenticación
                    await _authService.login(username, password);

                     // Redige a la pantalla de bienvenida
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => WelcomeScreen(username: _usernameController.text.trim()),
                  ),
                  );
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
                Title(
                color: Colors.black,
                child: const Text('Cambio by danusita'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}