import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/api_error_helper.dart';

void main() {
  group('getErrorDetails', () {
    test('returns correct details for status code 400', () {
      final exception = ApiException('Error de prueba', statusCode: 400);
      final result = getErrorDetails(exception);

      expect(result.message, 'Petición incorrecta. Por favor, verifica los datos enviados.');
      expect(result.color, Colors.red);
    });

    test('returns correct details for status code 401', () {
      final exception = ApiException('Error de prueba', statusCode: 401);
      final result = getErrorDetails(exception);

      expect(result.message, 'No autorizado. Por favor, inicia sesión nuevamente.');
      expect(result.color, Colors.orange);
    });

    test('returns correct details for status code 404', () {
      final exception = ApiException('Error de prueba', statusCode: 404);
      final result = getErrorDetails(exception);

      expect(result.message, 'Recurso no encontrado. Por favor, verifica la URL.');
      expect(result.color, Colors.grey);
    });

    test('returns correct details for status code 500', () {
      final exception = ApiException('Error de prueba', statusCode: 500);
      final result = getErrorDetails(exception);

      expect(result.message, 'Error interno del servidor. Intenta nuevamente más tarde.');
      expect(result.color, Colors.red);
    });

    test('returns default details for unknown status code', () {
      final exception = ApiException('Error de prueba', statusCode: 999);
      final result = getErrorDetails(exception);

      expect(result.message, 'Error desconocido. Código: 999.');
      expect(result.color, Colors.blue);
    });
  });
}