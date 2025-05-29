class TareaContadorState {
  final int completadas;
  final int total;
  final double progreso;

  TareaContadorState({
    this.completadas = 0,
    this.total = 0,
    this.progreso = 0.0,
  });

  TareaContadorState copyWith({
    int? completadas,
    int? total,
  }) {
    final newCompletadas = completadas ?? this.completadas;
    final newTotal = total ?? this.total;
    
    return TareaContadorState(
      completadas: newCompletadas,
      total: newTotal,
      progreso: newTotal > 0 ? newCompletadas / newTotal : 0.0,
    );
  }
}