import 'package:equatable/equatable.dart';
import 'package:abaez/domain/noticia.dart';

abstract class NoticiasState extends Equatable {
  const NoticiasState();

  @override
  List<Object?> get props => [];
}

class NoticiasInicioState extends NoticiasState {
  const NoticiasInicioState();
}

class NoticiasCargandoState extends NoticiasState {
  const NoticiasCargandoState();
}

class NoticiasCargadasState extends NoticiasState {
  final List<Noticia> noticias;

  const NoticiasCargadasState(this.noticias);

  @override
  List<Object?> get props => [noticias];
}

class NoticiasErrorState extends NoticiasState {
  final String mensaje;

  const NoticiasErrorState(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}