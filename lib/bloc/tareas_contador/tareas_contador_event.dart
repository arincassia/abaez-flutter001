abstract class TareaContadorEvent {}

class IncrementarContador extends TareaContadorEvent {}

class DecrementarContador extends TareaContadorEvent {}

class SetTotalTareas extends TareaContadorEvent {
  final int total;
  SetTotalTareas(this.total);
}

class SetCompletadas extends TareaContadorEvent {
  final int completadas;
  SetCompletadas(this.completadas);
}