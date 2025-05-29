// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tarea_cache_prefs.dart';

class TareaCachePrefsMapper extends ClassMapperBase<TareaCachePrefs> {
  TareaCachePrefsMapper._();

  static TareaCachePrefsMapper? _instance;
  static TareaCachePrefsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TareaCachePrefsMapper._());
      TareaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TareaCachePrefs';

  static String _$usuario(TareaCachePrefs v) => v.usuario;
  static const Field<TareaCachePrefs, String> _f$usuario =
      Field('usuario', _$usuario);
  static List<Tarea> _$misTareas(TareaCachePrefs v) => v.misTareas;
  static const Field<TareaCachePrefs, List<Tarea>> _f$misTareas =
      Field('misTareas', _$misTareas);

  @override
  final MappableFields<TareaCachePrefs> fields = const {
    #usuario: _f$usuario,
    #misTareas: _f$misTareas,
  };

  static TareaCachePrefs _instantiate(DecodingData data) {
    return TareaCachePrefs(
        usuario: data.dec(_f$usuario), misTareas: data.dec(_f$misTareas));
  }

  @override
  final Function instantiate = _instantiate;

  static TareaCachePrefs fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TareaCachePrefs>(map);
  }

  static TareaCachePrefs fromJson(String json) {
    return ensureInitialized().decodeJson<TareaCachePrefs>(json);
  }
}

mixin TareaCachePrefsMappable {
  String toJson() {
    return TareaCachePrefsMapper.ensureInitialized()
        .encodeJson<TareaCachePrefs>(this as TareaCachePrefs);
  }

  Map<String, dynamic> toMap() {
    return TareaCachePrefsMapper.ensureInitialized()
        .encodeMap<TareaCachePrefs>(this as TareaCachePrefs);
  }

  TareaCachePrefsCopyWith<TareaCachePrefs, TareaCachePrefs, TareaCachePrefs>
      get copyWith =>
          _TareaCachePrefsCopyWithImpl<TareaCachePrefs, TareaCachePrefs>(
              this as TareaCachePrefs, $identity, $identity);
  @override
  String toString() {
    return TareaCachePrefsMapper.ensureInitialized()
        .stringifyValue(this as TareaCachePrefs);
  }

  @override
  bool operator ==(Object other) {
    return TareaCachePrefsMapper.ensureInitialized()
        .equalsValue(this as TareaCachePrefs, other);
  }

  @override
  int get hashCode {
    return TareaCachePrefsMapper.ensureInitialized()
        .hashValue(this as TareaCachePrefs);
  }
}

extension TareaCachePrefsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TareaCachePrefs, $Out> {
  TareaCachePrefsCopyWith<$R, TareaCachePrefs, $Out> get $asTareaCachePrefs =>
      $base.as((v, t, t2) => _TareaCachePrefsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TareaCachePrefsCopyWith<$R, $In extends TareaCachePrefs, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Tarea, TareaCopyWith<$R, Tarea, Tarea>> get misTareas;
  $R call({String? usuario, List<Tarea>? misTareas});
  TareaCachePrefsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TareaCachePrefsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TareaCachePrefs, $Out>
    implements TareaCachePrefsCopyWith<$R, TareaCachePrefs, $Out> {
  _TareaCachePrefsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TareaCachePrefs> $mapper =
      TareaCachePrefsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tarea, TareaCopyWith<$R, Tarea, Tarea>> get misTareas =>
      ListCopyWith($value.misTareas, (v, t) => v.copyWith.$chain(t),
          (v) => call(misTareas: v));
  @override
  $R call({String? usuario, List<Tarea>? misTareas}) =>
      $apply(FieldCopyWithData({
        if (usuario != null) #usuario: usuario,
        if (misTareas != null) #misTareas: misTareas
      }));
  @override
  TareaCachePrefs $make(CopyWithData data) => TareaCachePrefs(
      usuario: data.get(#usuario, or: $value.usuario),
      misTareas: data.get(#misTareas, or: $value.misTareas));

  @override
  TareaCachePrefsCopyWith<$R2, TareaCachePrefs, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TareaCachePrefsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
