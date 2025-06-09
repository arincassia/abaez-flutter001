import 'package:abaez/views/contador.dart';
import 'package:abaez/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:abaez/views/tarea_screen.dart'; 
import 'package:abaez/views/start_screen.dart';
import 'package:abaez/views/quote_screen.dart';
import 'package:abaez/views/noticias_screen.dart';
import 'package:abaez/views/category_screen.dart';
import 'package:abaez/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';
import 'package:abaez/views/acerca_de.dart';
import 'package:abaez/theme/colors.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryDarkBlue,
              ),
              accountName: Text(
                username,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.gray01,
                ),
              ),
              accountEmail: Text(
                '$username@ejemplo.com',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.gray01,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.gray01,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: AppColors.primaryDarkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.list, color: AppColors.primaryDarkBlue),
                    title: Text('Lista de Tareas', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TareaScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer, color: AppColors.primaryLightBlue),
                    title: Text('Contador', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(title: 'Contador'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.videogame_asset, color: AppColors.primaryDarkBlue),
                    title: Text('Juego de preguntas', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StartScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money, color: AppColors.primaryLightBlue),
                    title: Text('Cotizaciones', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuoteScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.article, color: AppColors.primaryDarkBlue),
                    title: Text('Noticias', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoticiaScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.category, color: AppColors.primaryLightBlue),
                    title: Text('Categorias', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoryScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.gray05),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.gray14),
                    title: Text('Acerca de', style: theme.textTheme.bodyLarge),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AcercaDePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: AppColors.destructive),
                    title: Text(
                      'Cerrar sesión', 
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.destructive
                      ),
                    ),
                    onTap: () async {
                      final secureStorage = GetIt.instance<SecureStorageService>();
                      await secureStorage.clearAllSessionData();
                      
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryDarkBlue,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 40, 
                    color: AppColors.gray01,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¡Bienvenido/a, $username!',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Qué deseas hacer hoy?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.gray14,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      'Tareas',
                      Icons.list,
                      AppColors.primaryDarkBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TareaScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Contador',
                      Icons.timer,
                      AppColors.primaryLightBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(title: 'Contador'),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Juego',
                      Icons.videogame_asset,
                      AppColors.primaryDarkBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StartScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Cotizaciones',
                      Icons.attach_money,
                      AppColors.primaryLightBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuoteScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Noticias',
                      Icons.article,
                      AppColors.primaryDarkBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NoticiaScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Categorías',
                      Icons.category,
                      AppColors.primaryLightBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoryScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.gray05),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.gray01,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}