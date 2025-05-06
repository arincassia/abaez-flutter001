// Clase base para los eventos del contador
abstract class ContadorEvento {}

// Evento para incrementar el contador
class IncrementEvent extends ContadorEvento {}

// Evento para decrementar el contador
class DecrementEvent extends ContadorEvento {}

// Evento para reiniciar el contador
class ResetEvent extends ContadorEvento {}