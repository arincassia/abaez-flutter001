import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  // Método para construir un título en negrita con tamaño 20
  Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22, //Modificacion 2.3
      ),
    );
  }

  // Método para mostrar hasta 3 líneas de información
  Widget buildInfoLines(String line1, {String? line2, String? line3}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.w100, fontFamily: 'Arial')),
        if (line2 != null) Text(line2),
        if (line3 != null) Text(line3),
      ],
    );
  }

  // Método para construir un pie de página en negrita
  Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey //Modificacion 3.3
      ),
    );
  }

  // Método para construir un SizedBox con altura de 8
  Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  // Método para construir un borde redondeado
  BoxDecoration buildRoundedBorder() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    );
  }
}