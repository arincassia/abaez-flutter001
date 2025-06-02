
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:abaez/domain/preferencia.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/base_service.dart';

class PreferenciaService extends BaseService {
  // Clave para almacenar el ID en SharedPreferences
  static const String _preferenciaIdKey = 'preferencia_id';

  // ID para preferencias, inicialmente nulo
  String? _preferenciaId;
  // Constructor que inicializa el ID desde SharedPreferences y hereda de BaseService
  PreferenciaService() : super() {
    _cargarIdGuardado();
  }

  Future<void> _cargarIdGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_preferenciaIdKey)) {
      _preferenciaId = prefs.getString(_preferenciaIdKey);
    } else {
      _preferenciaId = '';
    }
  }

  Future<void> _guardarId(String id) async {
    _preferenciaId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferenciaIdKey, id);
  }
 Future<Preferencia> getPreferencias() async {
  try {
    // Si no hay ID almacenado, devolver preferencias vacías sin consultar API
    if (_preferenciaId != null && _preferenciaId!.isNotEmpty) {
      try {
        final data = await get(
          '/preferencias/$_preferenciaId',
          requireAuthToken: false, // Operación de lectura
        );
        // Si la respuesta es exitosa, convertir a objeto Preferencia
        if (data != null && data is Map<String, dynamic>) {
          return Preferencia.fromJson(data);
        }
      } catch (apiError) {
        // Capturar cualquier error de API aquí y continuar con preferencias vacías
        debugPrint('⚠️ Error al obtener preferencias existentes: $apiError');
        // No relanzamos el error, simplemente continuamos para crear preferencias vacías
      }
    }
    // Si llegamos aquí, necesitamos crear preferencias vacías
    return await _crearPreferenciasVacias();
  } catch (e) {
    // Este bloque solo captura errores inesperados en la función completa
    debugPrint('❌ Error inesperado en getPreferencias: ${e.toString()}');
    // Devolver preferencias vacías en lugar de lanzar excepción
    return Preferencia.empty();
  }
}
  /// Guarda las preferencias del usuario (Actualiza)
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {      await put(
        '/preferencias/$_preferenciaId',
        data: preferencia.toJson(),
        requireAuthToken: true, // Operación de escritura
      );
      
      debugPrint('✅ Preferencias guardadas correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en guardarPreferencias: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  Future<Preferencia> _crearPreferenciasVacias() async {
  try {
    final preferenciasVacias = Preferencia.empty();
    // Crear un nuevo registro en la API
    try {
      final data = await post(
        '/preferencias',
        data: preferenciasVacias.toJson(),
        requireAuthToken: true,
      );

      // Guardar el nuevo ID si existe
      if (data != null && data['id'] != null) {
        await _guardarId(data['id']);
      }
    } catch (apiError) {
      debugPrint('⚠️ Error al crear preferencias vacías: $apiError');
      // No relanzamos el error, simplemente devolvemos las preferencias vacías
    }

    return preferenciasVacias;
  } catch (e) {
    debugPrint('❌ Error inesperado en _crearPreferenciasVacias: ${e.toString()}');
    // Siempre devolver preferencias vacías en caso de error
    return Preferencia.empty();
  }
}
}
