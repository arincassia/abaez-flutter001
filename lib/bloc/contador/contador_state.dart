// Clase base para los estados del contador
abstract class ContadorEstado {}

// Estado que contiene el valor actual del contador
class ContadorValor extends ContadorEstado {
  final int valor;

  ContadorValor(this.valor);
}