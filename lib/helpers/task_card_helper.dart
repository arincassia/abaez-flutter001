import 'package:flutter/material.dart';
import 'package:abaez/domain/tarea.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño 20
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }


   

  /// Construye líneas de información (máximo 3 líneas)
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    final List<String> lines = [line1, if (line2 != null) line2, if (line3 != null) line3];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((line) => Text(
                line,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ))
          .toList(),
    );
  }

  /// Construye un pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  /// Construye un SizedBox con altura de 8
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  /// Construye un borde redondeado con BorderRadius.circular(10)
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }

  /// Construye un ícono dinámico basado en el tipo de tarea
  static Widget buildLeadingIcon(String type) {
    return Icon(
      type == 'normal' ? Icons.task : Icons.warning,
      color: type == 'normal' ? Colors.blue : Colors.red,
      size: 22,
    );
  }

  // Construye un texto predeterminado para "No hay pasos disponibles"
  static Widget buildNoStepsText() {
    return const Text(
      'No hay pasos disponibles',
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

   /// Construye un BorderRadius con bordes redondeados solo en la parte superior
  static BorderRadius buildTopRoundedBorder({double radius = 8.0}) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }
}

Widget construirTarjetaDeportiva(Tarea tarea, String tareaId, VoidCallback onEdit,  ValueChanged<bool> onCompletadoChanged,) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espaciado entre tarjetas
    child:ListTile(
      
    contentPadding: const EdgeInsets.all(16.0), // Padding interno del ListTile
    tileColor: Colors.white, // Fondo blanco para el ListTile
    shape: CommonWidgetsHelper.buildRoundedBorder(),
    leading: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: tarea.completado,
          onChanged: (bool? value) {
            if (value != null) {
              onCompletadoChanged(value);
            }
          },
        ),
        CommonWidgetsHelper.buildLeadingIcon(tarea.tipo),
      ],
    ), // Ícono dinámico
    title: CommonWidgetsHelper.buildBoldTitle(tarea.titulo), // Título en negrita
      trailing: IconButton(
        onPressed: onEdit, // Llama a la función de edición
        icon: const Icon(Icons.edit, size: 16),
        style: ElevatedButton.styleFrom(                     
          foregroundColor: Colors.grey, // Color del texto
        ),
      ),
    ),        
  );
}