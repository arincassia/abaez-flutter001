import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/connectivity/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/di/locator.dart';
import 'package:abaez/bloc/auth/auth_bloc.dart'; 
import 'package:abaez/helpers/secure_storage_service.dart'; 
import 'package:watch_it/watch_it.dart'; 
import 'package:abaez/components/connectivity_wrapper.dart'; 
import 'package:abaez/views/login_screen.dart';
import 'package:abaez/bloc/contador/contador_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_bloc.dart'; 
import 'package:abaez/helpers/shared_preferences_service.dart';
import 'package:abaez/theme/theme.dart'; 
import 'package:google_fonts/google_fonts.dart';  


Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: '.env');
  await initLocator();

  final prefsService = SharedPreferencesService();
  await prefsService.init();
  

  // Eliminar cualquier token guardado para forzar el inicio de sesión
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ContadorBloc()),
        BlocProvider(
          create:
              (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(
          create: (context) => AuthBloc(),
        ), // Solo se inicializa el AuthBloc sin verificar autenticación
        BlocProvider(
          create: (context) => ConnectivityBloc(),
        ), // Bloc para gestionar la conectividad
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: _buildThemeWithNotoFonts(), 
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: const LoginScreen(),
      ),
    );
  }

  ThemeData _buildThemeWithNotoFonts() {
    final baseTheme = AppTheme.bootcampTheme;
        return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansTextTheme(baseTheme.textTheme),
      primaryTextTheme: GoogleFonts.notoSansTextTheme(baseTheme.primaryTextTheme),
    );
  }
}
