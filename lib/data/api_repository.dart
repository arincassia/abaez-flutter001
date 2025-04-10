
class ApiRepository {
  
  
  List<String> obtenerPasos(String titulo, DateTime fechaLimite, int n) {
    // Formatear la fecha manualmente
    final int numeroDePasos = n.clamp(4, 10);
    final String fechaFormateada =
        '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}';
  // Generar pasos personalizados con la fecha límite
     return List.generate(
      numeroDePasos,
      (index) => 'Paso ${index + 1}: Acción antes del $fechaFormateada',
    );
  }
}

