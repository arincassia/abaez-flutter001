// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'comentario.dart';

class ComentarioMapper extends ClassMapperBase<Comentario> {
  ComentarioMapper._();

  static ComentarioMapper? _instance;
  static ComentarioMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ComentarioMapper._());
      ComentarioMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Comentario';

  static String? _$id(Comentario v) => v.id;
  static const Field<Comentario, String> _f$id = Field('id', _$id, opt: true);
  static String _$noticiaId(Comentario v) => v.noticiaId;
  static const Field<Comentario, String> _f$noticiaId = Field(
    'noticiaId',
    _$noticiaId,
  );
  static String _$texto(Comentario v) => v.texto;
  static const Field<Comentario, String> _f$texto = Field('texto', _$texto);
  static String _$fecha(Comentario v) => v.fecha;
  static const Field<Comentario, String> _f$fecha = Field('fecha', _$fecha);
  static String _$autor(Comentario v) => v.autor;
  static const Field<Comentario, String> _f$autor = Field('autor', _$autor);
  static int _$likes(Comentario v) => v.likes;
  static const Field<Comentario, int> _f$likes = Field('likes', _$likes);
  static int _$dislikes(Comentario v) => v.dislikes;
  static const Field<Comentario, int> _f$dislikes = Field(
    'dislikes',
    _$dislikes,
  );
  static List<Comentario>? _$subcomentarios(Comentario v) => v.subcomentarios;
  static const Field<Comentario, List<Comentario>> _f$subcomentarios = Field(
    'subcomentarios',
    _$subcomentarios,
    opt: true,
  );
  static bool _$isSubComentario(Comentario v) => v.isSubComentario;
  static const Field<Comentario, bool> _f$isSubComentario = Field(
    'isSubComentario',
    _$isSubComentario,
    opt: true,
    def: false,
  );
  static String? _$idSubComentario(Comentario v) => v.idSubComentario;
  static const Field<Comentario, String> _f$idSubComentario = Field(
    'idSubComentario',
    _$idSubComentario,
    opt: true,
  );

  @override
  final MappableFields<Comentario> fields = const {
    #id: _f$id,
    #noticiaId: _f$noticiaId,
    #texto: _f$texto,
    #fecha: _f$fecha,
    #autor: _f$autor,
    #likes: _f$likes,
    #dislikes: _f$dislikes,
    #subcomentarios: _f$subcomentarios,
    #isSubComentario: _f$isSubComentario,
    #idSubComentario: _f$idSubComentario,
  };

  static Comentario _instantiate(DecodingData data) {
    return Comentario(
      id: data.dec(_f$id),
      noticiaId: data.dec(_f$noticiaId),
      texto: data.dec(_f$texto),
      fecha: data.dec(_f$fecha),
      autor: data.dec(_f$autor),
      likes: data.dec(_f$likes),
      dislikes: data.dec(_f$dislikes),
      subcomentarios: data.dec(_f$subcomentarios),
      isSubComentario: data.dec(_f$isSubComentario),
      idSubComentario: data.dec(_f$idSubComentario),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Comentario fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Comentario>(map);
  }

  static Comentario fromJson(String json) {
    return ensureInitialized().decodeJson<Comentario>(json);
  }
}

mixin ComentarioMappable {
  String toJson() {
    return ComentarioMapper.ensureInitialized().encodeJson<Comentario>(
      this as Comentario,
    );
  }

  Map<String, dynamic> toMap() {
    return ComentarioMapper.ensureInitialized().encodeMap<Comentario>(
      this as Comentario,
    );
  }

  ComentarioCopyWith<Comentario, Comentario, Comentario> get copyWith =>
      _ComentarioCopyWithImpl<Comentario, Comentario>(
        this as Comentario,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ComentarioMapper.ensureInitialized().stringifyValue(
      this as Comentario,
    );
  }

  @override
  bool operator ==(Object other) {
    return ComentarioMapper.ensureInitialized().equalsValue(
      this as Comentario,
      other,
    );
  }

  @override
  int get hashCode {
    return ComentarioMapper.ensureInitialized().hashValue(this as Comentario);
  }
}

extension ComentarioValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Comentario, $Out> {
  ComentarioCopyWith<$R, Comentario, $Out> get $asComentario =>
      $base.as((v, t, t2) => _ComentarioCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ComentarioCopyWith<$R, $In extends Comentario, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Comentario, ComentarioCopyWith<$R, Comentario, Comentario>>?
  get subcomentarios;
  $R call({
    String? id,
    String? noticiaId,
    String? texto,
    String? fecha,
    String? autor,
    int? likes,
    int? dislikes,
    List<Comentario>? subcomentarios,
    bool? isSubComentario,
    String? idSubComentario,
  });
  ComentarioCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ComentarioCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Comentario, $Out>
    implements ComentarioCopyWith<$R, Comentario, $Out> {
  _ComentarioCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Comentario> $mapper =
      ComentarioMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Comentario, ComentarioCopyWith<$R, Comentario, Comentario>>?
  get subcomentarios =>
      $value.subcomentarios != null
          ? ListCopyWith(
            $value.subcomentarios!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(subcomentarios: v),
          )
          : null;
  @override
  $R call({
    Object? id = $none,
    String? noticiaId,
    String? texto,
    String? fecha,
    String? autor,
    int? likes,
    int? dislikes,
    Object? subcomentarios = $none,
    bool? isSubComentario,
    Object? idSubComentario = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (noticiaId != null) #noticiaId: noticiaId,
      if (texto != null) #texto: texto,
      if (fecha != null) #fecha: fecha,
      if (autor != null) #autor: autor,
      if (likes != null) #likes: likes,
      if (dislikes != null) #dislikes: dislikes,
      if (subcomentarios != $none) #subcomentarios: subcomentarios,
      if (isSubComentario != null) #isSubComentario: isSubComentario,
      if (idSubComentario != $none) #idSubComentario: idSubComentario,
    }),
  );
  @override
  Comentario $make(CopyWithData data) => Comentario(
    id: data.get(#id, or: $value.id),
    noticiaId: data.get(#noticiaId, or: $value.noticiaId),
    texto: data.get(#texto, or: $value.texto),
    fecha: data.get(#fecha, or: $value.fecha),
    autor: data.get(#autor, or: $value.autor),
    likes: data.get(#likes, or: $value.likes),
    dislikes: data.get(#dislikes, or: $value.dislikes),
    subcomentarios: data.get(#subcomentarios, or: $value.subcomentarios),
    isSubComentario: data.get(#isSubComentario, or: $value.isSubComentario),
    idSubComentario: data.get(#idSubComentario, or: $value.idSubComentario),
  );

  @override
  ComentarioCopyWith<$R2, Comentario, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ComentarioCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
