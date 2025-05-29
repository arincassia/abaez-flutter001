import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar la persistencia de datos utilizando SharedPreferences
/// Esta clase permite guardar, leer y editar cualquier objeto que pueda ser
/// serializado a JSON y deserializado desde JSON
class SharedPreferencesService {
  SharedPreferences? _prefs;
  
  // Instancia singleton
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  
  // Constructor factory para acceder al singleton
  factory SharedPreferencesService() {
    return _instance;
  }
  
  // Constructor privado
  SharedPreferencesService._internal();
  
  /// Inicializa el servicio obteniendo la instancia de SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Guarda un objeto en SharedPreferences
  /// 
  /// [key]: Clave única para identificar el objeto
  /// [value]: Objeto a guardar (debe ser serializable a JSON)
  /// [toJson]: Función que convierte el objeto a Map 
  /// 
  /// Retorna true si se guardó correctamente, false en caso contrario
  Future<bool> saveObject<T>({
    required String key, 
    required T value,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    if (_prefs == null) {
      await init();
    }
    try {
      final jsonData = toJson(value);
      final jsonString = json.encode(jsonData);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      debugPrint('Error al guardar objeto en SharedPreferences: $e');
      return false;
    }
  }
  
  /// Lee un objeto desde SharedPreferences
  /// 
  /// [key]: Clave única con la que se guardó el objeto
  /// [fromJson]: Función que convierte un Map al objeto de tipo T
  /// [defaultValue]: Valor por defecto si no se encuentra la clave
  /// 
  /// Retorna el objeto leído o el valor por defecto si no existe
  T? getObject<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    T? defaultValue,
  }) {
    if (_prefs == null) {
      // Since we can't use await in a non-async method, return default
      debugPrint('SharedPreferences not initialized');
      return defaultValue;
    }
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) {
        return defaultValue;
      }
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return fromJson(jsonData);
    } catch (e) {
      debugPrint('Error al leer objeto desde SharedPreferences: $e');
      return defaultValue;
    }
  }
  
  /// Actualiza un objeto existente o lo crea si no existe
  /// 
  /// [key]: Clave única para identificar el objeto
  /// [updateFn]: Función que recibe el objeto actual (o null) y retorna el objeto actualizado
  /// [fromJson]: Función que convierte un Map al objeto de tipo T
  /// [toJson]: Función que convierte el objeto a Map
  /// 
  /// Retorna true si se actualizó correctamente, false en caso contrario
  Future<bool> updateObject<T>({
    required String key,
    required T Function(T? currentValue) updateFn,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    if (_prefs == null) {
  await init();
}
    try {
      // Obtener el objeto actual (si existe)
      T? currentObject = getObject<T>(
        key: key, 
        fromJson: fromJson,
      );
      
      // Aplicar la función de actualización
      final updatedObject = updateFn(currentObject);
      
      // Guardar el objeto actualizado
      return await saveObject<T>(
        key: key,
        value: updatedObject,
        toJson: toJson,
      );
    } catch (e) {
      debugPrint('Error al actualizar objeto en SharedPreferences: $e');
      return false;
    }
  }
  
  /// Guarda una lista de objetos en SharedPreferences
  /// 
  /// [key]: Clave única para identificar la lista
  /// [values]: Lista de objetos a guardar
  /// [toJson]: Función que convierte cada objeto a Map
  /// 
  /// Retorna true si se guardó correctamente, false en caso contrario
  Future<bool> saveList<T>({
    required String key, 
    required T? value, 
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    if (_prefs == null) {
  await init();
}
    try {
       if (value == null) {
      // Option 1: Remove the key when value is null
      return await _prefs!.remove(key);
      
      // Option 2: Store an empty object representation
      // return await _prefs!.setString(key, "{}");
    }
      final Map<String, dynamic> jsonData = toJson(value);
      final jsonString = json.encode(jsonData);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      debugPrint('Error al guardar lista en SharedPreferences: $e');
      return false;
    }
  }
  
  /// Lee una lista de objetos desde SharedPreferences
  /// 
  /// [key]: Clave única con la que se guardó la lista
  /// [fromJson]: Función que convierte un Map al objeto de tipo T
  /// 
  /// Retorna la lista leída o una lista vacía si no existe
  List<T> getList<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
   if (_prefs == null) {
    // Since we can't use await in a non-async method, return false
    debugPrint('SharedPreferences not initialized');
    return <T>[];
  }
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) {
        return <T>[];
      }
      
      final List<dynamic> jsonDataList = json.decode(jsonString);
      return jsonDataList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error al leer lista desde SharedPreferences: $e');
      return <T>[];
    }
  }
  
  /// Elimina un objeto o lista almacenado en SharedPreferences
  /// 
  /// [key]: Clave única del objeto a eliminar
  /// 
  /// Retorna true si se eliminó correctamente, false en caso contrario
  Future<bool> remove(String key) async {
    if (_prefs == null) {
  await init();
}
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      debugPrint('Error al eliminar datos de SharedPreferences: $e');
      return false;
    }
  }
  
  /// Verifica si existe una clave en SharedPreferences
  /// 
  /// [key]: Clave a verificar
  /// 
  /// Retorna true si la clave existe, false en caso contrario
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
  
  /// Elimina todos los datos almacenados en SharedPreferences
  /// 
  /// Retorna true si se eliminaron todos los datos correctamente
  Future<bool> clearAll() async {
    if (_prefs == null) {
      // Since we can't use await in a non-async method, return default
      debugPrint('SharedPreferences not initialized');
      return false;
    }
    try {

      return await _prefs!.clear();
    } catch (e) {
      debugPrint('Error al limpiar SharedPreferences: $e');
      return false;
    }
  }
}