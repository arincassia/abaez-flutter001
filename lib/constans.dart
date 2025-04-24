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
  static final String newsurl = dotenv.env['NEWS_URL'] ?? 'URL_NO_DEFINIDA';





}