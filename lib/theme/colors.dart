import 'package:flutter/material.dart';

class AppColors {
  // Colores principales de la marca
  static const Color primaryDarkBlue = Color(0xFF10498A); // Azul oscuro
  static const Color primaryLightBlue = Color(0xFF006CB5); // Azul claro
  static const Color neutralGray = Color(0xFF898989); // Gris

  // Actualizamos el color primario para usar el nuevo esquema
  static const Color primary = primaryDarkBlue;
  static const Color primaryHover = primaryLightBlue;
  static const Color primaryActive = neutralGray; // Gris deshabilitado
  static const Color surface = gray02;
  static const Color background = Color(0xFFF5F5F5);
  

  // Gray Scale
  static const Color gray01 = Color(0xFFFFFFFF);
  static const Color gray02 = Color(0xFFF7F7F7);
  // Agregando grays faltantes
  static const Color gray03 = Color(0xFFEFEFEF);
  static const Color gray04 = Color(0xFFE6E6E6);
  static const Color gray05 = Color(0xFFDDDDDD);
  static const Color gray06 = Color(0xFFD4D4D4);
  static const Color gray07 = Color(0xFFCCCCCC);
  static const Color gray08 = Color(0xFFB5B5B5);
  // Agregando grays intermedios faltantes
  static const Color gray09 = Color(0xFF999999);
  static const Color gray10 = Color(0xFF808080);
  static const Color gray11 = Color(0xFF666666);
  static const Color gray12 = Color(0xFF4D4D4D);
  static const Color gray13 = Color(0xFF353535);
  static const Color gray14 = Color(0xFF303030);
  static const Color gray15 = Color(0xFF282828);
  static const Color gray16 = Color(0xFF1A1A1A);

  // Colores de estado
  static const Color destructive = Color(0xFFDC2626); // Color de error
  static const Color disabled = Color(0xFFD4D4D4); // Usando gray06 para disabled

  // Red scale para estados hover/pressed
  static const Color red03 = Color(0xFFFEE2E2);
  static const Color red07 = Color(0xFFFCA5A5);

  // Colores adicionales
  static const Color blue01 = Color(0xFFF2F6FF);
  static const Color blue02 = Color(0xFFE6EEFE);
  static const Color blue03 = Color(0xFFCDDDFC);
  static const Color blue04 = Color(0xFFB4CCFB);
  static const Color blue09 = Color(0xFF3776F5);
  static const Color blue10 = Color(0xFF1E65F3);
  static const Color blue11 = Color(0xFF0554F2);
  static const Color blue12 = Color(0xFF0443C2);
  static const Color blue13 = Color(0xFF033291);
  static const Color blue14 = Color(0xFF022261);
  static const Color blue15 = Color(0xFF01153D);
  static const Color blue16 = Color(0xFF011130);
  static const Color blue17 = Color(0xFF002D72);

  static const Color white = Color(0xFFFFFFFF);
}