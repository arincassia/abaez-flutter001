// Definición de eventos para el ContadorBloc
abstract class ContadorEvent {}

// Evento para incrementar el contador
class IncrementarContador extends ContadorEvent {}

// Evento para decrementar el contador
class DecrementarContador extends ContadorEvent {}

// Evento para resetear el contador
class ResetearContador extends ContadorEvent {}