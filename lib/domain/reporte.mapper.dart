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
      case r'noticiaInapropiada':
        return MotivoReporte.noticiaInapropiada;
      case r'informacionFalsa':
        return MotivoReporte.informacionFalsa;
      case r'otro':
        return MotivoReporte.otro;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MotivoReporte self) {
    switch (self) {
      case MotivoReporte.noticiaInapropiada:
        return r'noticiaInapropiada';
      case MotivoReporte.informacionFalsa:
        return r'informacionFalsa';
      case MotivoReporte.otro:
        return r'otro';
    }
  }
}

extension MotivoReporteMapperExtension on MotivoReporte {
  String toValue() {
    MotivoReporteMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MotivoReporte>(this) as String;
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
  static const Field<Reporte, String> _f$id = Field('id', _$id, opt: true);
  static String _$noticiaId(Reporte v) => v.noticiaId;
  static const Field<Reporte, String> _f$noticiaId =
      Field('noticiaId', _$noticiaId);
  static String _$fecha(Reporte v) => v.fecha;
  static const Field<Reporte, String> _f$fecha = Field('fecha', _$fecha);
  static MotivoReporte _$motivo(Reporte v) => v.motivo;
  static const Field<Reporte, MotivoReporte> _f$motivo =
      Field('motivo', _$motivo);

  @override
  final MappableFields<Reporte> fields = const {
    #id: _f$id,
    #noticiaId: _f$noticiaId,
    #fecha: _f$fecha,
    #motivo: _f$motivo,
  };

  static Reporte _instantiate(DecodingData data) {
    return Reporte(
        id: data.dec(_f$id),
        noticiaId: data.dec(_f$noticiaId),
        fecha: data.dec(_f$fecha),
        motivo: data.dec(_f$motivo));
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
      {String? id, String? noticiaId, String? fecha, MotivoReporte? motivo});
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
          String? fecha,
          MotivoReporte? motivo}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (noticiaId != null) #noticiaId: noticiaId,
        if (fecha != null) #fecha: fecha,
        if (motivo != null) #motivo: motivo
      }));
  @override
  Reporte $make(CopyWithData data) => Reporte(
      id: data.get(#id, or: $value.id),
      noticiaId: data.get(#noticiaId, or: $value.noticiaId),
      fecha: data.get(#fecha, or: $value.fecha),
      motivo: data.get(#motivo, or: $value.motivo));

  @override
  ReporteCopyWith<$R2, Reporte, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ReporteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
