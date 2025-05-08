import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/data/preferencia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:abaez/data/comentarios_repository.dart';

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
}
