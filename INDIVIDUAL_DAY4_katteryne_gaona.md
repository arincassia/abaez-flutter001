# Modelo Reporte con configuración de dart_mappable

## Descripción del Modelo

El modelo `Reporte` es una clase que representa un reporte sobre una noticia en la aplicación. Está implementado utilizando la biblioteca `dart_mappable` para facilitar la serialización y deserialización de objetos JSON.

## Estructura del Modelo

El modelo Reporte está definido en `lib/domain/reporte.dart` y contiene:

1. Un enum `MotivoReporte` que define los posibles motivos de un reporte:
   - NoticiaInapropiada
   - InformacionFalsa
   - Otro

2. La clase `Reporte` con los siguientes atributos:
   - `id`: String opcional, identificador único del reporte
   - `noticiaId`: String requerido, identificador de la noticia reportada
   - `fecha`: String requerido, fecha en formato ISO8601
   - `motivo`: MotivoReporte requerido, el motivo del reporte

## Configuración de dart_mappable

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum para representar los diferentes motivos de reportes
@MappableEnum()
enum MotivoReporte {
  NoticiaInapropiada,
  InformacionFalsa,
  Otro
}

/// Modelo para representar un reporte de noticia
@MappableClass()
class Reporte with ReporteMappable {
  /// Identificador único del reporte, opcional al crear un nuevo reporte
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

## Características de dart_mappable implementadas

1. **Anotaciones**:
   - `@MappableEnum()`: Para permitir mapear el enum MotivoReporte a/desde strings en JSON.
   - `@MappableClass()`: Para generar código de serialización para la clase Reporte.

2. **Mixin ReporteMappable**:
   - Proporciona métodos para convertir objetos Reporte a JSON y viceversa.
   - Habilita métodos como `toJson()` y `toMap()`.

3. **Archivo Generado**:
   - `part 'reporte.mapper.dart'`: Este archivo contiene todo el código generado automáticamente.
   - Incluye `ReporteMapper` para serialización/deserialización.
   - Incluye `MotivoReporteMapper` para trabajar con el enum.
   - Proporciona un método de factory `fromMap` para crear instancias desde JSON.

4. **Soporte para Campos Opcionales**:
   - El campo `id` es opcional, marcado con `?` y sin el modificador `required`.

## Uso del Modelo

El modelo Reporte se utiliza principalmente en:

1. **Servicio de API** (`ReporteService`):
   - Envía reportes usando `reporte.toMap()` para serializar a JSON.
   - Recibe reportes usando `ReporteMapper.fromMap(json)` para deserializar.

2. **Repositorio** (`ReporteRepository`):
   - Crea instancias de Reporte con los datos correspondientes.
   - Gestiona la lógica de negocio relacionada con reportes.

3. **Bloc** (`ReporteBloc`):
   - Maneja eventos relacionados con reportes y actualiza el estado de la aplicación.

## Ventajas de usar dart_mappable

1. **Generación automática de código**:
   - No es necesario escribir manualmente los métodos de serialización.
   - Reduce la posibilidad de errores.

2. **Inmutabilidad**:
   - Promueve el uso de objetos inmutables con campos `final`.

3. **Compatibilidad con JSON**:
   - Facilita la comunicación con APIs REST.

4. **Eficiencia**:
   - El código generado es eficiente y optimizado.



   