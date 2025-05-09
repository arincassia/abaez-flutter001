import 'package:dio/dio.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Servicio para la gestión de reportes de noticias
class ReporteService {
  final Dio dio;
  final NoticiaService _noticiaService;

  /// Constructor con inyección de dependencias
  ReporteService({
    Dio? dio,
    NoticiaService? noticiaService,
  }) : dio = dio ?? Dio(BaseOptions(
           connectTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
           receiveTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
         )),
       _noticiaService = noticiaService ?? NoticiaService();

  /// Envía un nuevo reporte
  Future<Reporte> enviarReporte(Reporte reporte) async {
    try {
      // Validación básica
      if (reporte.noticiaId.isEmpty) {
        throw ApiException('El ID de la noticia es requerido', statusCode: 400);
      }

      // 1. Verificar que la noticia exista llamando al servicio de noticias
      try {
        List<Noticia> noticias = await _noticiaService.getNoticias();
        bool noticiaExiste = noticias.any((noticia) => noticia.id == reporte.noticiaId);
        
        if (!noticiaExiste) {
          throw ApiException('La noticia no existe o no está disponible', statusCode: 404);
        }
      } catch (e) {
        debugPrint('Error al verificar existencia de noticia: $e');
        if (e is ApiException) {
          rethrow;
        }
        throw ApiException('Error al verificar la existencia de la noticia', statusCode: 500);
      }

      // 2. Verificar si ya se reportó
      try {
        final yaReportado = await verificarReporteExistente(
          reporte.noticiaId,
          reporte.usuarioId,
        );

        if (yaReportado) {
          throw ApiException('Ya has reportado esta noticia anteriormente', statusCode: 409);
        }
      } catch (e) {
        if (e is ApiException && e.statusCode == 409) {
          rethrow; // Solo relanzamos si es un error de "ya reportado"
        }
        // Para otros errores en la verificación, continuamos con el proceso
        // pero registramos el error para debugging
        debugPrint('Error no crítico al verificar reporte existente: $e');
      }

      // 3. Enviar el reporte a la API
      try {
        final response = await dio.post(
          ApiConstantes.reportesUrl,
          data: {
            'noticiaId': reporte.noticiaId,
            'usuarioId': reporte.usuarioId,
            'motivo': reporte.motivo.toString().split('.').last, // Enviar solo el nombre del enum
            'descripcion': reporte.descripcion,
            'fecha': reporte.fecha,
          },
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        // 4. Guardar localmente que este usuario ya reportó esta noticia
        await _guardarReporteLocal(reporte.noticiaId, reporte.usuarioId);

        // 5. Deserializar y devolver el reporte creado
        if (response.statusCode == 201 || response.statusCode == 200) {
          if (response.data is Map) {
            // Si la respuesta es un objeto JSON, creamos el reporte desde él
            return Reporte(
              id: response.data['_id'] ?? response.data['id'],
              noticiaId: reporte.noticiaId,
              usuarioId: reporte.usuarioId,
              motivo: reporte.motivo,
              descripcion: reporte.descripcion,
              fecha: reporte.fecha,
              revisado: response.data['revisado'] ?? false,
            );
          }
        }
        
        // Si no podemos parsear la respuesta, devolvemos el reporte original
        return reporte;
      } on DioException catch (e) {
        debugPrint('Error DIO al enviar reporte: ${e.message}');
        throw ApiException(
          'Error al enviar el reporte: ${e.message}',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado en enviarReporte: $e');
      throw ApiException('Error inesperado al enviar el reporte', statusCode: 500);
    }
  }

  /// Verifica si una noticia ya fue reportada por el usuario consultando todos los reportes
  /// 
  /// Este método primero verifica localmente y luego en el servidor si es necesario
  Future<bool> verificarReporteExistente(String noticiaId, String usuarioId) async {
    try {
      // 1. Primero verificar localmente para reducir llamadas a API
      final reportadoLocalmente = await _verificarReporteLocal(noticiaId, usuarioId);
      if (reportadoLocalmente) {
        return true;
      }

      // 2. Si no hay registro local, verificar obteniendo todos los reportes
      // y filtrando por noticiaId y usuarioId
      try {
        final response = await dio.get(ApiConstantes.reportesUrl);
        
        if (response.statusCode == 200) {
          final List<dynamic> reportes = response.data as List<dynamic>;
          
          // Verificar si existe algún reporte con el mismo noticiaId y usuarioId
          final bool existe = reportes.any((reporte) => 
              reporte['noticiaId'] == noticiaId && 
              reporte['usuarioId'] == usuarioId);
          
          if (existe) {
            // Si existe en el servidor pero no localmente, guardarlo local
            await _guardarReporteLocal(noticiaId, usuarioId);
          }
          
          return existe;
        }
      } catch (e) {
        // Si hay un error al obtener los reportes, lo ignoramos y asumimos que no existe
        debugPrint('Error al obtener reportes para verificación: $e');
      }
      
      // Si no pudimos verificar en el servidor, asumimos que no existe el reporte
      return false;
    } catch (e) {
      debugPrint('Error al verificar reporte existente: $e');
      return false; // En caso de error, asumimos que no está reportado para permitir continuar
    }
  }

  /// Guarda localmente que un usuario ha reportado una noticia
  Future<void> _guardarReporteLocal(String noticiaId, String usuarioId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'reporte_${noticiaId}_${usuarioId}';
      await prefs.setBool(key, true);
    } catch (e) {
      debugPrint('Error al guardar reporte local: $e');
      // Error al guardar en SharedPreferences (no crítico)
    }
  }

  /// Verifica localmente si un usuario ya reportó una noticia
  Future<bool> _verificarReporteLocal(String noticiaId, String usuarioId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'reporte_${noticiaId}_${usuarioId}';
      return prefs.getBool(key) ?? false;
    } catch (e) {
      debugPrint('Error al verificar reporte local: $e');
      return false;
    }
  }

  /// Obtiene todos los reportes de una noticia específica
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      final response = await dio.get(ApiConstantes.reportesUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        
        // Filtrar reportes por noticiaId
        final reportesFiltrados = data.where((json) => json['noticiaId'] == noticiaId).toList();
        
        // Convertir a objetos Reporte
        return reportesFiltrados.map((json) {
          return Reporte(
            id: json['_id'] ?? json['id'],
            noticiaId: json['noticiaId'],
            usuarioId: json['usuarioId'],
            motivo: _parseMotivoReporte(json['motivo']),
            descripcion: json['descripcion'],
            fecha: json['fecha'],
            revisado: json['revisado'] ?? false,
          );
        }).toList();
      } else {
        throw ApiException(
          'Error al obtener reportes',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al obtener reportes: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }
  
  /// Convierte una cadena de texto al enum MotivoReporte correspondiente
  MotivoReporte _parseMotivoReporte(String? motivoStr) {
    switch (motivoStr) {
      case 'noticia_inapropiada':
        return MotivoReporte.noticiaInapropiada;
      case 'informacion_falsa':
        return MotivoReporte.informacionFalsa;
      case 'contenido_violento':
        return MotivoReporte.contenidoViolento;
      case 'incitacion_odio':
        return MotivoReporte.incitacionOdio;
      case 'derechos_autor':
        return MotivoReporte.derechosAutor;
      case 'otro':
        return MotivoReporte.otro;
      default:
        return MotivoReporte.otro;
    }
  }
}