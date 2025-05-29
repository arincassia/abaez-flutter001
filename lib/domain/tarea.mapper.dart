// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tarea.dart';

class TareaMapper extends ClassMapperBase<Tarea> {
  TareaMapper._();

  static TareaMapper? _instance;
  static TareaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TareaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Tarea';

  static String? _$id(Tarea v) => v.id;
  static const Field<Tarea, String> _f$id = Field('id', _$id, opt: true);
  static String _$usuario(Tarea v) => v.usuario;
  static const Field<Tarea, String> _f$usuario = Field('usuario', _$usuario);
  static String _$titulo(Tarea v) => v.titulo;
  static const Field<Tarea, String> _f$titulo = Field('titulo', _$titulo);
  static String _$tipo(Tarea v) => v.tipo;
  static const Field<Tarea, String> _f$tipo =
      Field('tipo', _$tipo, opt: true, def: 'normal');
  static String? _$descripcion(Tarea v) => v.descripcion;
  static const Field<Tarea, String> _f$descripcion =
      Field('descripcion', _$descripcion, opt: true);
  static DateTime? _$fecha(Tarea v) => v.fecha;
  static const Field<Tarea, DateTime> _f$fecha =
      Field('fecha', _$fecha, opt: true);
  static DateTime? _$fechaLimite(Tarea v) => v.fechaLimite;
  static const Field<Tarea, DateTime> _f$fechaLimite =
      Field('fechaLimite', _$fechaLimite, opt: true);
  static bool _$completado(Tarea v) => v.completado;
  static const Field<Tarea, bool> _f$completado =
      Field('completado', _$completado, opt: true, def: false);

  @override
  final MappableFields<Tarea> fields = const {
    #id: _f$id,
    #usuario: _f$usuario,
    #titulo: _f$titulo,
    #tipo: _f$tipo,
    #descripcion: _f$descripcion,
    #fecha: _f$fecha,
    #fechaLimite: _f$fechaLimite,
    #completado: _f$completado,
  };

  static Tarea _instantiate(DecodingData data) {
    return Tarea(
        id: data.dec(_f$id),
        usuario: data.dec(_f$usuario),
        titulo: data.dec(_f$titulo),
        tipo: data.dec(_f$tipo),
        descripcion: data.dec(_f$descripcion),
        fecha: data.dec(_f$fecha),
        fechaLimite: data.dec(_f$fechaLimite),
        completado: data.dec(_f$completado));
  }

  @override
  final Function instantiate = _instantiate;

  static Tarea fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Tarea>(map);
  }

  static Tarea fromJson(String json) {
    return ensureInitialized().decodeJson<Tarea>(json);
  }
}

mixin TareaMappable {
  String toJson() {
    return TareaMapper.ensureInitialized().encodeJson<Tarea>(this as Tarea);
  }

  Map<String, dynamic> toMap() {
    return TareaMapper.ensureInitialized().encodeMap<Tarea>(this as Tarea);
  }

  TareaCopyWith<Tarea, Tarea, Tarea> get copyWith =>
      _TareaCopyWithImpl<Tarea, Tarea>(this as Tarea, $identity, $identity);
  @override
  String toString() {
    return TareaMapper.ensureInitialized().stringifyValue(this as Tarea);
  }

  @override
  bool operator ==(Object other) {
    return TareaMapper.ensureInitialized().equalsValue(this as Tarea, other);
  }

  @override
  int get hashCode {
    return TareaMapper.ensureInitialized().hashValue(this as Tarea);
  }
}

extension TareaValueCopy<$R, $Out> on ObjectCopyWith<$R, Tarea, $Out> {
  TareaCopyWith<$R, Tarea, $Out> get $asTarea =>
      $base.as((v, t, t2) => _TareaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TareaCopyWith<$R, $In extends Tarea, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? usuario,
      String? titulo,
      String? tipo,
      String? descripcion,
      DateTime? fecha,
      DateTime? fechaLimite,
      bool? completado});
  TareaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TareaCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Tarea, $Out>
    implements TareaCopyWith<$R, Tarea, $Out> {
  _TareaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Tarea> $mapper = TareaMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? usuario,
          String? titulo,
          String? tipo,
          Object? descripcion = $none,
          Object? fecha = $none,
          Object? fechaLimite = $none,
          bool? completado}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (usuario != null) #usuario: usuario,
        if (titulo != null) #titulo: titulo,
        if (tipo != null) #tipo: tipo,
        if (descripcion != $none) #descripcion: descripcion,
        if (fecha != $none) #fecha: fecha,
        if (fechaLimite != $none) #fechaLimite: fechaLimite,
        if (completado != null) #completado: completado
      }));
  @override
  Tarea $make(CopyWithData data) => Tarea(
      id: data.get(#id, or: $value.id),
      usuario: data.get(#usuario, or: $value.usuario),
      titulo: data.get(#titulo, or: $value.titulo),
      tipo: data.get(#tipo, or: $value.tipo),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      fecha: data.get(#fecha, or: $value.fecha),
      fechaLimite: data.get(#fechaLimite, or: $value.fechaLimite),
      completado: data.get(#completado, or: $value.completado));

  @override
  TareaCopyWith<$R2, Tarea, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TareaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
