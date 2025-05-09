// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'reporte.dart';

class MotivoReporteMapper extends EnumMapper<MotivoReporte> {
  MotivoReporteMapper._();

  static MotivoReporteMapper? _instance;
  static MotivoReporteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MotivoReporteMapper._());
    }
    return _instance!;
  }

  static MotivoReporte fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MotivoReporte decode(dynamic value) {
    switch (value) {
      case "noticia_inapropiada":
        return MotivoReporte.noticiaInapropiada;
      case "informacion_falsa":
        return MotivoReporte.informacionFalsa;
      case "contenido_violento":
        return MotivoReporte.contenidoViolento;
      case "incitacion_odio":
        return MotivoReporte.incitacionOdio;
      case "derechos_autor":
        return MotivoReporte.derechosAutor;
      case "otro":
        return MotivoReporte.otro;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MotivoReporte self) {
    switch (self) {
      case MotivoReporte.noticiaInapropiada:
        return "noticia_inapropiada";
      case MotivoReporte.informacionFalsa:
        return "informacion_falsa";
      case MotivoReporte.contenidoViolento:
        return "contenido_violento";
      case MotivoReporte.incitacionOdio:
        return "incitacion_odio";
      case MotivoReporte.derechosAutor:
        return "derechos_autor";
      case MotivoReporte.otro:
        return "otro";
    }
  }
}

extension MotivoReporteMapperExtension on MotivoReporte {
  dynamic toValue() {
    MotivoReporteMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MotivoReporte>(this);
  }
}

class ReporteMapper extends ClassMapperBase<Reporte> {
  ReporteMapper._();

  static ReporteMapper? _instance;
  static ReporteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReporteMapper._());
      MotivoReporteMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Reporte';

  static String? _$id(Reporte v) => v.id;
  static const Field<Reporte, String> _f$id =
      Field('id', _$id, key: r'_id', opt: true);
  static String _$noticiaId(Reporte v) => v.noticiaId;
  static const Field<Reporte, String> _f$noticiaId =
      Field('noticiaId', _$noticiaId);
  static String _$usuarioId(Reporte v) => v.usuarioId;
  static const Field<Reporte, String> _f$usuarioId =
      Field('usuarioId', _$usuarioId);
  static MotivoReporte _$motivo(Reporte v) => v.motivo;
  static const Field<Reporte, MotivoReporte> _f$motivo =
      Field('motivo', _$motivo);
  static String? _$descripcion(Reporte v) => v.descripcion;
  static const Field<Reporte, String> _f$descripcion =
      Field('descripcion', _$descripcion, opt: true);
  static String _$fecha(Reporte v) => v.fecha;
  static const Field<Reporte, String> _f$fecha = Field('fecha', _$fecha);
  static bool _$revisado(Reporte v) => v.revisado;
  static const Field<Reporte, bool> _f$revisado =
      Field('revisado', _$revisado, opt: true, def: false);

  @override
  final MappableFields<Reporte> fields = const {
    #id: _f$id,
    #noticiaId: _f$noticiaId,
    #usuarioId: _f$usuarioId,
    #motivo: _f$motivo,
    #descripcion: _f$descripcion,
    #fecha: _f$fecha,
    #revisado: _f$revisado,
  };

  static Reporte _instantiate(DecodingData data) {
    return Reporte(
        id: data.dec(_f$id),
        noticiaId: data.dec(_f$noticiaId),
        usuarioId: data.dec(_f$usuarioId),
        motivo: data.dec(_f$motivo),
        descripcion: data.dec(_f$descripcion),
        fecha: data.dec(_f$fecha),
        revisado: data.dec(_f$revisado));
  }

  @override
  final Function instantiate = _instantiate;

  static Reporte fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Reporte>(map);
  }

  static Reporte fromJson(String json) {
    return ensureInitialized().decodeJson<Reporte>(json);
  }
}

mixin ReporteMappable {
  String toJson() {
    return ReporteMapper.ensureInitialized()
        .encodeJson<Reporte>(this as Reporte);
  }

  Map<String, dynamic> toMap() {
    return ReporteMapper.ensureInitialized()
        .encodeMap<Reporte>(this as Reporte);
  }

  ReporteCopyWith<Reporte, Reporte, Reporte> get copyWith =>
      _ReporteCopyWithImpl<Reporte, Reporte>(
          this as Reporte, $identity, $identity);
  @override
  String toString() {
    return ReporteMapper.ensureInitialized().stringifyValue(this as Reporte);
  }

  @override
  bool operator ==(Object other) {
    return ReporteMapper.ensureInitialized()
        .equalsValue(this as Reporte, other);
  }

  @override
  int get hashCode {
    return ReporteMapper.ensureInitialized().hashValue(this as Reporte);
  }
}

extension ReporteValueCopy<$R, $Out> on ObjectCopyWith<$R, Reporte, $Out> {
  ReporteCopyWith<$R, Reporte, $Out> get $asReporte =>
      $base.as((v, t, t2) => _ReporteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReporteCopyWith<$R, $In extends Reporte, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? noticiaId,
      String? usuarioId,
      MotivoReporte? motivo,
      String? descripcion,
      String? fecha,
      bool? revisado});
  ReporteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReporteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Reporte, $Out>
    implements ReporteCopyWith<$R, Reporte, $Out> {
  _ReporteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Reporte> $mapper =
      ReporteMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? noticiaId,
          String? usuarioId,
          MotivoReporte? motivo,
          Object? descripcion = $none,
          String? fecha,
          bool? revisado}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (noticiaId != null) #noticiaId: noticiaId,
        if (usuarioId != null) #usuarioId: usuarioId,
        if (motivo != null) #motivo: motivo,
        if (descripcion != $none) #descripcion: descripcion,
        if (fecha != null) #fecha: fecha,
        if (revisado != null) #revisado: revisado
      }));
  @override
  Reporte $make(CopyWithData data) => Reporte(
      id: data.get(#id, or: $value.id),
      noticiaId: data.get(#noticiaId, or: $value.noticiaId),
      usuarioId: data.get(#usuarioId, or: $value.usuarioId),
      motivo: data.get(#motivo, or: $value.motivo),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      fecha: data.get(#fecha, or: $value.fecha),
      revisado: data.get(#revisado, or: $value.revisado));

  @override
  ReporteCopyWith<$R2, Reporte, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ReporteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
