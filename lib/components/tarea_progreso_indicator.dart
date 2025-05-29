import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/tareas_contador/tareas_contador_bloc.dart' as tareas_bloc;
import 'package:abaez/bloc/tareas_contador/tareas_contador_state.dart';

class TareaProgresoIndicator extends StatelessWidget {
  const TareaProgresoIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<tareas_bloc.TareaContadorBloc, TareaContadorState>(
      buildWhen: (previous, current) =>
        previous.completadas != current.completadas ||
        previous.total != current.total,
      builder: (context, state) {
        final theme = Theme.of(context);
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: theme.chipTheme.backgroundColor, // Usamos el color de fondo del chip
            // Eliminamos el borderRadius y las sombras
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${state.completadas}/${state.total}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: state.progreso,
                  minHeight: 12, // Un poco más alta para mejor visibilidad
                  backgroundColor: theme.colorScheme.onTertiary, // Usamos el color secundario para contraste
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.secondaryFixed, // Usando el color secundario para más contraste
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tareas completadas',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}