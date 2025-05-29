import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/reportes/reportes_bloc.dart';
import 'package:abaez/data/auth_repository.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/data/preferencia_repository.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/helpers/secure_storage_service.dart';
import 'package:abaez/helpers/connectivity_service.dart';
import 'package:abaez/api/service/category_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:abaez/data/comentario_repository.dart';
import 'package:abaez/helpers/shared_preferences_service.dart';
import 'package:abaez/data/tarea_repository.dart';
import  'package:abaez/api/service/tarea_service.dart';



Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerLazySingleton<TareasRepository>(() => TareasRepository());
  di.registerSingleton<ComentarioRepository>(ComentarioRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  di.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService());
  di.registerLazySingleton<TareaService>(() => TareaService());

  // Registramos el servicio de conectividad
  di.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  GetIt.instance.registerSingleton(ComentarioBloc());
  // Cambiamos a registerFactory para generar una nueva instancia cada vez que sea solicitada
  GetIt.instance.registerFactory(() => ReporteBloc());
  di.registerSingleton<AuthRepository>(AuthRepository());
  
  // Registramos el servicio de caché de categorías como singleton
  di.registerLazySingleton<CategoryCacheService>(() => CategoryCacheService());
}