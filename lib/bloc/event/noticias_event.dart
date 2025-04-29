import 'package:abaez/domain/noticia.dart';
abstract class NoticiasEvent {}

class CargarNoticiasEvent extends NoticiasEvent {}

class EliminarNoticiaEvent extends NoticiasEvent {
  final Noticia noticia;

  EliminarNoticiaEvent(this.noticia);
}

class EditarNoticiaEvent extends NoticiasEvent {
  final Noticia noticia;

  EditarNoticiaEvent(this.noticia);
}

class AgregarNoticiaEvent extends NoticiasEvent {
  final Noticia noticia;

  AgregarNoticiaEvent(this.noticia);
}