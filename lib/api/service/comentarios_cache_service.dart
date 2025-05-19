import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abaez/domain/comentario.dart';

/// Servicio para manejar la caché de comentarios con persistencia usando SharedPreferences
class ComentariosCacheService {
  // Clave para el timestamp de última actualización
  static const String _keyPrefix = 'comentarios_cache_';
  static const String _timestampPrefix = 'comentarios_timestamp_';
  
  // Tiempo máximo de validez de la caché en minutos
  final int cacheDurationMinutes;
  
  ComentariosCacheService({this.cacheDurationMinutes = 15});
  
  /// Guarda comentarios en la caché
  Future<void> guardarComentariosEnCache(String noticiaId, List<Comentario> comentarios) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Convertir la lista de comentarios a JSON
      final List<Map<String, dynamic>> comentariosJson = 
          comentarios.map((c) => c.toJson()).toList();
      
      // Guardar en SharedPreferences
      await prefs.setString(
        _getComentariosKey(noticiaId), 
        jsonEncode(comentariosJson)
      );
      
      // Actualizar timestamp
      await prefs.setInt(
        _getTimestampKey(noticiaId), 
        DateTime.now().millisecondsSinceEpoch
      );
      
      debugPrint('✅ Comentarios guardados en caché para noticia $noticiaId');
    } catch (e) {
      debugPrint('❌ Error al guardar comentarios en caché: $e');
    }
  }
  
  /// Obtiene comentarios desde la caché
  Future<List<Comentario>?> obtenerComentariosDesdeCache(String noticiaId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Verificar si la caché existe
      final String? comentariosStr = prefs.getString(_getComentariosKey(noticiaId));
      if (comentariosStr == null) {
        debugPrint('⚠️ No hay caché para comentarios de noticia $noticiaId');
        return null;
      }
      
      // Verificar si la caché está vigente
      if (!_esCacheVigente(prefs, noticiaId)) {
        debugPrint('⚠️ La caché para noticia $noticiaId ha expirado');
        return null;
      }
      
      // Decodificar el JSON
      final List<dynamic> comentariosJson = jsonDecode(comentariosStr);
      
      // Convertir a objetos Comentario
      final comentarios = comentariosJson
          .map((json) => Comentario.fromJson(json))
          .toList();
      
      debugPrint('✅ ${comentarios.length} comentarios recuperados de caché para noticia $noticiaId');
      return comentarios;
    } catch (e) {
      debugPrint('❌ Error al obtener comentarios desde caché: $e');
      return null;
    }
  }
  
  /// Invalida la caché para una noticia específica
  Future<void> invalidarCache(String noticiaId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getComentariosKey(noticiaId));
      await prefs.remove(_getTimestampKey(noticiaId));
      debugPrint('🔄 Caché invalidada para noticia $noticiaId');
    } catch (e) {
      debugPrint('❌ Error al invalidar caché: $e');
    }
  }
  
  /// Invalida toda la caché de comentarios
  Future<void> invalidarTodaCache() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_keyPrefix) || key.startsWith(_timestampPrefix)) {
          await prefs.remove(key);
        }
      }
      debugPrint('🔄 Toda la caché de comentarios ha sido invalidada');
    } catch (e) {
      debugPrint('❌ Error al invalidar toda la caché: $e');
    }
  }
  
  /// Comprueba si la caché está vigente
  bool _esCacheVigente(SharedPreferences prefs, String noticiaId) {
    final int? timestamp = prefs.getInt(_getTimestampKey(noticiaId));
    if (timestamp == null) return false;
    
    final DateTime timestampDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateTime now = DateTime.now();
    
    final difference = now.difference(timestampDate).inMinutes;
    return difference < cacheDurationMinutes;
  }
  
  /// Genera la clave para los comentarios
  String _getComentariosKey(String noticiaId) => '$_keyPrefix$noticiaId';
  
  /// Genera la clave para el timestamp
  String _getTimestampKey(String noticiaId) => '$_timestampPrefix$noticiaId';
}