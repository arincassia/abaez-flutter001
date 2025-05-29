import 'package:dart_mappable/dart_mappable.dart';
import 'package:abaez/domain/tarea.dart';

part 'tarea_cache_prefs.mapper.dart';

@MappableClass()
class TareaCachePrefs with TareaCachePrefsMappable {
  final String usuario;
  final List<Tarea> misTareas;

  const TareaCachePrefs({
    required this.usuario,
    required this.misTareas,
  });
}