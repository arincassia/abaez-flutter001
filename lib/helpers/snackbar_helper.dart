import 'package:flutter/material.dart';
import 'package:abaez/helpers/error_helper.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, String message, {int? statusCode}) {
    // Usar directamente ErrorHelper para obtener el color
    final color = ErrorHelper.getErrorMessageAndColor(statusCode)['color'] as Color;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 200);
  }

  // Método para errores del cliente (400-499)
  static void showClientError(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 400);
  }
  
  // Método para errores del servidor (500+)
  static void showServerError(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 500);
  }
}