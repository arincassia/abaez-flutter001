
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
  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      // Si no hay ID almacenado, devolver preferencias vacías sin consultar API
      if (_preferenciaId != null && _preferenciaId!.isNotEmpty) {      final data = await get(
          '/preferencias/$_preferenciaId',
          requireAuthToken: false, // Operación de lectura
        );
        // Si la respuesta es exitosa, convertir a objeto Preferencia
        if (data != null && data is Map<String, dynamic>) {
          return Preferencia.fromJson(data);
        }
      }
      return await _crearPreferenciasVacias();
    } on DioException catch (e) {
      debugPrint('❌ DioException en getPreferencias: ${e.toString()}');      if (e.response?.statusCode == 404) {
        // Si no existe, devolver preferencias vacías
        return await _crearPreferenciasVacias();
      } else {
        handleError(e);
        return await _crearPreferenciasVacias();
      }
    } catch (e) {
      debugPrint('❌ Error inesperado en getPreferencias: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e');
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
  /// Método auxiliar para crear un nuevo registro de preferencias vacías
  Future<Preferencia> _crearPreferenciasVacias() async {
    try {
      final preferenciasVacias = Preferencia.empty();      // Crear un nuevo registro en la API
      final data = await post(
        '/preferencias',
        data: preferenciasVacias.toJson(),
        requireAuthToken: true, // Operación de escritura
      );

      // Guardar el nuevo ID si existe
      if (data != null && data['id'] != null) {
        await _guardarId(data['id']);
      }

      return preferenciasVacias;    } on DioException catch (e) {
      debugPrint('❌ DioException en _crearPreferenciasVacias: ${e.toString()}');
      handleError(e);
      // En caso de error, retornamos preferencias vacías sin ID
      return Preferencia.empty();
    } catch (e) {
      debugPrint('❌ Error inesperado en _crearPreferenciasVacias: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e');
    }
  }
}
