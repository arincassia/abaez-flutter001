import 'package:flutter/material.dart';
import 'package:abaez/helpers/task_card_helper.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/constants.dart';

class TaskCard extends StatelessWidget {
  final Tarea tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, 
      color: Colors.white, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgetsHelper.buildSpacing(), // Espacio entre el título y la descripción
                  CommonWidgetsHelper.buildNoStepsText(),
                CommonWidgetsHelper.buildSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea el botón a la derecha
                  children: [
                    CommonWidgetsHelper.buildBoldFooter('${TareasConstantes.fechaLimite} $fechaLimiteDato'),
                    ElevatedButton.icon(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}