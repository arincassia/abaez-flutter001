import 'package:equatable/equatable.dart';
import 'package:abaez/domain/noticia.dart';

sealed class NoticiasEvent extends Equatable {
  const NoticiasEvent();

  @override
  List<Object> get props => [];
}

class FetchNoticias extends NoticiasEvent {
  const FetchNoticias();
}

class AddNoticia extends NoticiasEvent {
  final Noticia noticia;

  const AddNoticia(this.noticia);

  @override
  List<Object> get props => [noticia];
}

class UpdateNoticia extends NoticiasEvent {
  final String id;
  final Noticia noticia;

  const UpdateNoticia(this.id, this.noticia);

  @override
  List<Object> get props => [id, noticia];
}

class DeleteNoticia extends NoticiasEvent {
  final String id;

  const DeleteNoticia(this.id);

  @override
  List<Object> get props => [id];
}

class FilterNoticiasByPreferencias extends NoticiasEvent {
  final List<String> categoriasIds;

  const FilterNoticiasByPreferencias(this.categoriasIds);

  @override
  List<Object> get props => [categoriasIds];
}