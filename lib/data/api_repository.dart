
class ApiRepository {
  
  
  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    // Formatear la fecha manualmente
    final String fechaFormateada =
        '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}';
  // Generar pasos personalizados con la fecha límite
    return [
      'Paso 1: Planificar antes del $fechaFormateada',
      'Paso 2: Ejecutar antes del $fechaFormateada',
      'Paso 3: Revisar antes del $fechaFormateada',
    ];
  }
}

