import 'package:abaez/api/service/base_service.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/data/base_repository.dart' as repo;

class TareaService extends BaseService implements repo.BaseService<Tarea> {
  final String _endpoint = ApiConstantes.tareasEndpoint;

  @override
  Future<List<Tarea>> getAll() async {
    return obtenerTareasUsuario('');
  }

  @override
  Future<void> create(dynamic data) async {
    await crearTarea(data as Tarea);
  }

  @override
  Future<void> update(String id, dynamic data) async {
    await actualizarTarea(data as Tarea);
  }

   @override
  Future<dynamic> delete(String path, {bool requireAuthToken = true}) async {
    await eliminarTarea(path);
  }
  /// Obtiene la lista de tareas de un usuario
   Future<List<Tarea>> obtenerTareasUsuario(String usuario) async {
    final dynamic response = await get(
      '$_endpoint?usuario=$usuario',
    );
    
    final List<dynamic> tareasJson = response as List<dynamic>;

    return tareasJson
        .map<Tarea>((json) => TareaMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea una nueva tarea
  Future<Tarea> crearTarea(Tarea tarea) async {
    final json = await post(
      _endpoint,
      data: tarea.toMap(),
     
    );

    return TareaMapper.fromMap(json);
  }

  /// Elimina una tarea existente
  Future<void> eliminarTarea(String tareaId) async {
    final url = '$_endpoint/$tareaId';
    await delete(url);
  }

  /// Actualiza una tarea existente
  Future<Tarea> actualizarTarea(Tarea tarea) async {
    final taskId = tarea.id;
    final url = '$_endpoint/$taskId';
    final json = await put(
      url,
      data: tarea.toMap(),
    );

    return TareaMapper.fromMap(json);
  }
}