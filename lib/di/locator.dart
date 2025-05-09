import 'package:abaez/bloc/bloc%20reportes/reportes_bloc.dart';
import 'package:abaez/bloc/categorias/categorias_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/data/preferencia_repository.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:abaez/data/comentario_repository.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerSingleton<ComentarioRepository>(ComentarioRepository());
  GetIt.instance.registerSingleton(ComentarioBloc());
  GetIt.instance.registerSingleton(ReporteRepository());
  GetIt.instance.registerSingleton(CategoriaBloc());
  // Registramos ReportesBloc como Factory para tener una nueva instancia cada vez
  GetIt.instance.registerFactory<ReportesBloc>(() => ReportesBloc());
}
