# Documentación del Sistema de Reportes

## Modelo Reporte

El modelo `Reporte` se implementa usando el paquete `dart_mappable` para facilitar la serialización y deserialización entre objetos Dart y JSON. Esta implementación permite un manejo eficiente de la información en la comunicación con la API.

```dart
// filepath: c:\Bootcamp\abaez-flutter001\lib\domain\reporte.dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum que define los posibles motivos de reporte
@MappableEnum()
enum MotivoReporte { 
  NoticiaInapropiada,
  InformacionFalsa, 
  Otro 
}

/// Clase que representa un reporte de noticia
@MappableClass()
class Reporte with ReporteMappable {
  @MappableField(key: '_id')
  final String? id;
  final String noticiaId;
  final String fecha;
  final MotivoReporte motivo;

  const Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
  });
}
```

La anotación `@MappableClass()` genera automáticamente código para la serialización del modelo, mientras que `@MappableEnum()` permite la correcta conversión del enum `MotivoReporte`. La librería genera métodos como `toJson()`, `toMap()`, `fromJson()` y `fromMap()` que facilitan la conversión de los datos.

El campo `id` está anotado con `@MappableField(key: '_id')` para manejar la diferencia entre el nombre del campo en la API (`_id`) y en nuestro modelo (`id`).

## Archivo Generado: reporte.mapper.dart

El paquete `dart_mappable` genera automáticamente el archivo `reporte.mapper.dart` con clases auxiliares para el manejo de la serialización:

- `MotivoReporteMapper`: Convierte entre el enum y su representación en string
- `ReporteMapper`: Maneja la conversión entre objetos Reporte y Maps/JSON
- Extensiones `ReporteMappable` y otras utilidades

Este enfoque reduce significativamente el código boilerplate necesario para manejar la serialización y deserialización, además de proporcionar una forma más segura y tipo-segura de trabajar con datos.

## Servicio de Reportes (ReporteService)

La comunicación con la API se realiza a través del servicio `ReporteService`:

```dart
Future<Reporte> crearReporte({
  required String noticiaId,
  required MotivoReporte motivo,
}) async {
  try {
    final fecha = DateTime.now().toIso8601String();
    final response = await _dio.post(
      _baseUrl,
      data: {
        'noticiaId': noticiaId,
        'fecha': fecha,
        'motivo': motivo.toValue(), // Método generado por dart_mappable
      },
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        return ReporteMapper.fromMap(response.data as Map<String, dynamic>);
      } else {
        return ReporteMapper.fromJson(response.data.toString());
      }
    } else {
      throw ApiException('Error al crear reporte', statusCode: response.statusCode);
    }
  } catch (e) {
    // Manejo de excepciones
    throw ApiException('Error inesperado: $e');
  }
}
```

Nótese el uso de `motivo.toValue()` para convertir correctamente el enum a su representación en string.

## Comportamiento del Sistema de Reportes

### Flujo Exitoso

1. **Interacción del Usuario**: 
   - El usuario hace clic en el botón "Reportar" de una noticia
   - Se muestra un diálogo con un menú desplegable de motivos (NoticiaInapropiada, InformacionFalsa, Otro)
   - El usuario selecciona un motivo y hace clic en "Enviar Reporte"

2. **Procesamiento del Reporte**:
   - El `ReporteBloc` recibe un evento `ReporteCreateEvent` con el ID de la noticia y el motivo
   - El estado cambia a `ReporteLoading` (muestra un indicador de carga)
   - El servicio envía la solicitud a la API utilizando `ReporteService.crearReporte()`
   - La API responde con éxito (código 200 o 201)
   - El reporte se deserializa usando `ReporteMapper.fromMap()` o `ReporteMapper.fromJson()`
   - El estado cambia a `ReporteCreated` con los datos del reporte creado

3. **Retroalimentación al Usuario**:
   - Se muestra un SnackBar de éxito con "Reporte enviado correctamente"
   - El diálogo se cierra automáticamente

### Manejo de Errores

1. **Errores de conexión**:
   - Si hay problemas de conexión o timeout, se lanza una ApiException
   - El ReporteBloc cambia el estado a `ReporteError`
   - Se muestra un SnackBar de error con el mensaje correspondiente
   - El diálogo permanece abierto para que el usuario pueda reintentar o cancelar

2. **Errores de servidor**:
   - Si el servidor responde con códigos 4xx o 5xx, se lanza una ApiException
   - El ReporteBloc cambia el estado a `ReporteError` con el mensaje del servidor
   - Se muestra un SnackBar de error con el mensaje apropiado

3. **Errores de serialización/deserialización**:
   - Si hay problemas al convertir entre JSON y objetos Dart, se captura la excepción
   - Se muestra un mensaje de error apropiado (por ejemplo, "Error al procesar datos del servidor")

## Mejoras Implementadas

1. **Regeneración del ReporteBloc**: Se cambió de singleton a factory para evitar problemas de estado entre reportes.

2. **Manejo de estado mejorado**: Se reinicia el estado del bloc cuando hay errores previos.

3. **Prevención de cierre accidental**: Se configuró `barrierDismissible: false` para evitar que el diálogo se cierre tocando fuera.

4. **Gestión de temporización de eventos**: Se agregó un pequeño retraso con `Future.delayed` para asegurar que la UI se actualice correctamente.

## Conclusión

El sistema de reportes implementado con dart_mappable proporciona una forma robusta y tipificada de manejar los datos, reduciendo la posibilidad de errores en tiempo de ejecución relacionados con la serialización. El patrón BLoC permite una separación clara entre la UI y la lógica de negocio, facilitando el mantenimiento y las pruebas del sistema.
