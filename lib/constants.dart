import 'package:abaez/core/api_config.dart';

class AppConstants {
  //Constantes para la aplicación de tareas
  static const String tituloAppbar = 'Mis tareas';
  static const String listaVacia = 'No hay tareas disponibles';
  static const String agregarTarea = 'Agregar Tarea';
  static const String editarTarea = 'Editar Tarea';
  static const String tituloTarea = 'Título';
  static const String tipoTarea = 'Tipo'; // Modificacion 1.1
  static const String descripcionTarea = 'Descripción';
  static const String fechaTarea = 'Fecha';
  static const String seleccionarFecha = 'Seleccionar Fecha';
  static const String cancelar = 'Cancelar';
  static const String guardar = 'Guardar';
  static const String tareaEliminada = 'Tarea eliminada';
  static const String camposVacios = 'Por favor, completa todos los campos obligatorios.';
  static const String fechaLimite = 'Fecha límite: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String errorCreateDefault = 'Error al crear el recurso';  
  

  //Constantes para la aplicación de preguntas
  static const String titleApp = 'Juego de Preguntas'; 
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!'; 
  static const String startGame = 'Iniciar Juego';
  static const String finalScore = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de Nuevo';

  //Constantes para la aplicación de cotizaciones financieras
  static const String titleAppFinance = 'Cotizaciones Financieras';
  static const String loadingmessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String companyName = 'Nombre de la Empresa';
  static const String stockPrice = 'Precio de la Acción:';
  static const String changePercentage = 'Porcentaje de Cambio:';
  static const String lastUpdated = 'Última Actualización:';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 10;
  static const String dateFormat = 'dd/MM/yyyy HH:mm'; 

  //Constantes para la aplicación de noticias técnicas
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listasVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPaginaConst = 10;
  static const double espaciadoAlto = 10;
  static const String tituloNoticias = 'Noticias';
  static const String descripcionNoticia = 'Descripción';
  static const String fuente = 'Fuente';
  static const String publicadaEl = 'Publicado el';
  static const String tooltipOrden = 'Cambiar orden';
 // static const String newsurl = 'https://newsapi.org/v2/everything';
  
}

class TareasCachePrefsConstantes {
  static const String tituloApp = 'Preferencias de Tareas';
  static const String mensajeCargando = 'Cargando preferencias de tareas...';
  static const String listaVacia = 'No hay preferencias de tareas disponibles';
  static const String mensajeError = 'Error al obtener preferencias de tareas';
  static const String errorNotFound = 'Preferencias de tareas no encontradas';
  static const String successUpdated = 'Preferencias de tareas actualizadas exitosamente';
  static const String errorUpdated = 'Error al editar las preferencias de tareas';
  static const String successDeleted = 'Preferencias de tareas eliminadas exitosamente';
  static const String errorDelete = 'Error al eliminar las preferencias de tareas';
  static const String errorAdd = 'Error al agregar preferencias de tareas';
  static const String successCreated = 'Preferencias de tareas creadas exitosamente';
  static const String errorCreated = 'Error al crear las preferencias de tareas';
  static const String errorUnauthorized = 'No autorizado para acceder a preferencias de tareas';
  static const String errorInvalidData = 'Datos inválidos en preferencias de tareas';
  static const String errorServer = 'Error del servidor en preferencias de tareas';
  static const String errorSync = 'Error al sincronizar preferencias de tareas';
  static const String successSync = 'Preferencias de tareas sincronizadas correctamente';
}

// Constantes para la pantalla de Tareas
class TareasConstantes {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String tipoTarea = 'Tipo: ';
  static const String taskTypeNormal = 'normal';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  static const String tareaEliminada = 'Tarea eliminada';
  static const int limitePasos = 2;
  static const int limiteTareas = 10;
  static const String mensajeError = 'Error al obtener tareas';
  static const String errorEliminar = 'Error al eliminar la tarea';
  static const String errorActualizar = 'Error al actualizar la tarea';
  static const String errorCrear = 'Error al crear la tarea';

}

class ValidacionConstantes {
  // Mensajes genéricos
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  // static const String campoInvalido = 'no es válido';
  // static const String campoMuyCorto = 'es demasiado corto';
  // static const String campoMuyLargo = 'es demasiado largo';
  
  // Campos comunes
  static const String imagenUrl = 'URL de la imagen';
  // static const String nombre = 'nombre';
  // static const String descripcion = 'descripción';
  // static const String imagen = 'imagen';
  // static const String url = 'URL';
  // static const String titulo = 'título';
  static const String fecha = 'La fecha';
  static const String email = 'email del usuario';
  // static const String precio = 'precio';
  // static const String cantidad = 'cantidad';
  
  // Campos específicos
  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
  static const String tituloTarea = 'El título de la tarea';
}
class ApiConstantes {
   static final String newsurl = ApiConfig.beeceptorBaseUrl;
  static final String noticiasUrl = '$newsurl/noticias';
  static final String categoriasUrl = '$newsurl/categorias';
  static final String preferenciasUrl = '$newsurl/preferencias';
  static final String comentariosUrl = '$newsurl/comentarios';
  static final String reportesUrl = '$newsurl/reportes';
  static final String tareasEndpoint= '$newsurl/tareas';
  static final String loginUrl = '$newsurl/login';


  static const int timeoutSeconds = 10; 
  static const String errorTimeout = 'Tiempo de espera agotado'; 
  static const String errorNoCategory = 'Categoría no encontrada'; 
  static const String defaultcategoriaId = 'sin_categoria'; 
  static const String listasVacia = 'No hay categorias disponibles';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String categorysuccessCreated = 'Categoría creada con éxito';
  static const String categorysuccessUpdated = 'Categoría actualizada con éxito';
  static const String categorysuccessDeleted = 'Categoría eliminada con éxito';
  static const String newssuccessCreated = 'Noticia creada con éxito';
  static const String newssuccessUpdated = 'Noticia actualizada con éxito';
  static const String newssuccessDeleted = 'Noticia eliminada con éxito';
  static const String errorUnauthorized = 'No autorizado'; 
  static const String errorNotFound = 'Noticias no encontradas';
  static const String errorServer = 'Error del servidor';
  static const String errorNoInternet = 'Por favor, verifica tu conexión a internet.';
}


class NoticiasConstantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al obtener noticias';
  static const String defaultCategoriaId = 'default';
  static const String errorNotFound = 'Noticia no encontrada';
  static const String successUpdated = 'Noticia actualizada exitosamente';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized = 'No autorizado para acceder a noticia';
  static const String errorInvalidData = 'Datos inválidos en noticia';
  static const String errorServer = 'Error del servidor en noticia';
  static const String errorCreated = 'Error al crear la noticia';
  static const String errorUpdated = 'Error al editar la noticia';
  static const String errorDelete = 'Error al eliminar la noticia';
  static const String errorFilter = 'Error al filtrar noticias';
  static const String errorVerificarNoticiaExiste = 'Error al verificar si la noticia existe';
  static const String errorActualizarContadorReportes = 'Error al actualizar el contador de reportes';
}



class ErrorConstantes {
  static const String errorServer = 'Error del servidor';
  static const String errorNotFound = 'Noticias no encontradas.';
  static const String errorUnauthorized = 'No autorizado';
}

class CategoriaConstantes{
  static const String tituloApp = 'Categorías de Noticias';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String listaVacia = 'No hay categorias disponibles';
  static const String mensajeError = 'Error al obtener categorías';
  static const String errorNocategoria = 'Categoría no encontrada';
  static const String defaultcategoriaId = 'Sin Categoria';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String errorDelete = 'Error al eliminar la categoría';
  static const String errorAdd = 'Error al agregar categoría';
  static const String successCreated = 'Categoria creada exitosamente';
  static const String errorCreated = 'Error al crear la categoría';
  static const String errorUnauthorized = 'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
}


