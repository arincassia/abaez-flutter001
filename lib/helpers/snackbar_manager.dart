/// Gestor para controlar el estado de visualización del SnackBar de conectividad
class SnackBarManager {
  static final SnackBarManager _instance = SnackBarManager._internal();

  /// Singleton para acceder a la instancia desde cualquier parte de la aplicación
  factory SnackBarManager() {
    return _instance;
  }

  SnackBarManager._internal();

  /// Indica si el SnackBar de conectividad está siendo mostrado
  bool _isConnectivitySnackBarShowing = false;

  /// Getter para conocer si el SnackBar de conectividad está visible
  bool get isConnectivitySnackBarShowing => _isConnectivitySnackBarShowing;

  /// Método para marcar el inicio de la visualización del SnackBar de conectividad
  void setConnectivitySnackBarShowing(bool value) {
    _isConnectivitySnackBarShowing = value;
  }

  /// Método para mostrar un SnackBar solo si el SnackBar de conectividad no está activo
  bool canShowSnackBar() {
    return !_isConnectivitySnackBarShowing;
  }
}