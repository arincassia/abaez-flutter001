import 'package:flutter/material.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ApiErrorDetails {
  final String message;
  final Color color;

  ApiErrorDetails({required this.message, required this.color});
}

ApiErrorDetails getErrorDetails(ApiException exception) {
  switch (exception.statusCode) {
    case 400:
      return ApiErrorDetails(
        message: 'Petición incorrecta. Por favor, verifica los datos enviados.',
        color: Colors.red,
      );
    case 401:
      return ApiErrorDetails(
        message: 'No autorizado. Por favor, inicia sesión nuevamente.',
        color: Colors.orange,
      );
    case 404:
      return ApiErrorDetails(
        message: 'Recurso no encontrado. Por favor, verifica la URL.',
        color: Colors.grey,
      );
    case 500:
      return ApiErrorDetails(
        message: 'Error interno del servidor. Intenta nuevamente más tarde.',
        color: Colors.red,
      );
    default:
      return ApiErrorDetails(
        message: 'Error desconocido. Código: ${exception.statusCode ?? 'N/A'}.',
        color: Colors.blue,
      );
  }
}