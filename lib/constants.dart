import 'package:flutter_dotenv/flutter_dotenv.dart';


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


class ApiConstantes {
   static final String newsurl = dotenv.env['NEWS_URL'] ?? 'URL_NO_DEFINIDA';
  static final String noticiasUrl = '$newsurl/noticias';
  static final String categoriasUrl = '$newsurl/categorias';
  static final String preferenciasUrl = '$newsurl/preferencias';
  static final String reportesUrl = '$newsurl/reportes';
  static final String comentariosUrl = '$newsurl/comentarios';

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

}


class NoticiaConstantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPagina = 7;
  static const double espaciadoAlto = 10;
 
}



class ErrorConstantes {
  static const String errorServer = 'Error del servidor';
  static const String errorNotFound = 'Noticias no encontradas.';
  static const String errorUnauthorized = 'No autorizado';
}

class CategoriaConstantes {
  static const int timeoutSeconds = 10; // Tiempo máximo de espera en segundos
  static const String errorTimeout = 'Tiempo de espera agotado'; // Mensaje para errores de timeout
  static const String errorNoCategoria = 'Categoría no encontrada'; // Mensaje para errores de categorías
  static const String defaultCategoriaId = 'sin_categoria'; // ID por defecto para noticias sin categoría
  static const String mensajeError = 'Error al cargar categorias';
}

