import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/api/service/categoria_service.dart';
import 'package:abaez/domain/reporte.dart'; // Añadir importación para MotivoReporte
import 'package:abaez/bloc/reporte/reporte_bloc.dart';
import 'package:abaez/bloc/reporte/reporte_event.dart';
import 'package:abaez/bloc/reporte/reporte_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaModal {
  static Future<void> mostrarModal({
    required BuildContext context,
    Map<String, dynamic>? noticia, // Datos de la noticia para editar
    required VoidCallback onSave, // Callback para guardar
  }) async {
    final formKey = GlobalKey<FormState>();
    final NoticiaRepository noticiaService = NoticiaRepository();

    // Controladores para los campos del formulario
    final TextEditingController tituloController = TextEditingController(
      text: noticia?['titulo'] ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: noticia?['descripcion'] ?? '',
    );
    final TextEditingController fuenteController = TextEditingController(
      text: noticia?['fuente'] ?? '',
    );
    final TextEditingController fechaController = TextEditingController(
      text: noticia?['publicadaEl'] ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: noticia?['urlImagen'] ?? '',
    );

    DateTime? fechaSeleccionada =
        noticia != null ? DateTime.tryParse(noticia['publicadaEl'] ?? '') : null;

    String? categoriaSeleccionada = noticia?['categoriaId'];

    List<Categoria> categorias = [];
    try {
      final categoriaRepository = CategoriaService();
      categorias = await categoriaRepository.getCategorias();
      // Añadir la opción "Sin categoría" al inicio de la lista
      categorias.insert(0, Categoria(id: '', nombre: 'Sin categoría', descripcion: 'Sin categoría'));

      // Verificar si la categoría seleccionada existe en las opciones
      if (categoriaSeleccionada != null) {
        bool existeCategoria = categorias.any((c) => c.id == categoriaSeleccionada);
        if (!existeCategoria) {
          // Si no existe, establecer como null para que se seleccione la primera
          categoriaSeleccionada = null;
        }
      }
    } catch (e) {
      // Manejo de errores al cargar categorías
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }

    Future<void> guardarNoticia() async {
      if (formKey.currentState!.validate()) {
        try {
          // Convierte la fecha seleccionada al formato ISO 8601

          if (noticia == null) {
            // Crear nueva noticia
            await noticiaService.crearNoticia(
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
              publicadaEl: fechaSeleccionada ?? DateTime.now(),
              urlImagen: imagenUrlController.text,
              categoriaId: categoriaSeleccionada ?? CategoriaConstantes.defaultCategoriaId,
            );
          } else {
            // Editar noticia existente
            await noticiaService.actualizarNoticia(
              id: noticia['_id'],
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
               publicadaEl: fechaSeleccionada ?? DateTime.now(),
              urlImagen: imagenUrlController.text,
              categoriaId: categoriaSeleccionada ?? CategoriaConstantes.defaultCategoriaId,
            );
          }

          // Muestra un mensaje de éxito
         

          // Llama al callback para actualizar la lista de noticias
          onSave();

          // Cierra el modal
          if (!context.mounted) return;
          Navigator.pop(context);
        } catch (e) {
          // Muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la noticia: $e')),
          );
        }
      }
    }
     if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(noticia == null ? 'Crear Noticia' : 'Editar Noticia'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una fuente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de publicación',
                      hintText: 'Seleccionar Fecha',
                    ),
                    onTap: () async {
                      DateTime? nuevaFecha = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (nuevaFecha != null) {
                        fechaSeleccionada = nuevaFecha;
                        fechaController.text = DateFormat(
                          'dd-MM-yyyy',
                        ).format(nuevaFecha); // Formatea la fecha
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una fecha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una URL de imagen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  
                  DropdownButtonFormField<String>(
                    value: categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      categoriaSeleccionada = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona una categoría';
                      }
                      return null;
                    },
                    // Añadir opción de placeholder cuando no hay selección
                    hint: const Text('Selecciona una categoría'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: guardarNoticia,
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

/// Clase para mostrar el diálogo de reportes de noticias
class ReporteDialog {
  /// Muestra un diálogo de reporte para una noticia
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required String noticiaId,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => di<ReporteBloc>(),
          child: _ReporteDialogContent(noticiaId: noticiaId),
        );
      },
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;

  const _ReporteDialogContent({required this.noticiaId});

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  // Estadísticas de reportes
  Map<String, int> _estadisticasReportes = {
    'NoticiaInapropiada': 0,
    'InformacionFalsa': 0,
    'Otro': 0,
  };
  bool _reporteEnviando = false;
  MotivoReporte? _ultimoMotivoReportado;

  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEstadisticasReportes();
    });
  }
  
  void _cargarEstadisticasReportes() {
    // Solicitar estadísticas de reportes
    context.read<ReporteBloc>().add(CargarEstadisticasReporte(
      noticiaId: widget.noticiaId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteSuccess) {
          // Solicitar actualización de estadísticas después de un reporte exitoso
          _cargarEstadisticasReportes();
          
          // Mostrar mensaje de éxito y cerrar el diálogo después de un tiempo
          SnackBarHelper.showSnackBar(
            context,
            state.mensaje,
            statusCode: 200,
          );
          
          // No cerramos el diálogo inmediatamente para que el usuario vea los contadores actualizados
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is ReporteError) {
          // Mostrar mensaje de error
          SnackBarHelper.showSnackBar(
            context,
            state.errorMessage,
            statusCode: state.statusCode ?? 400,
          );
        } else if (state is ReporteEstadisticasLoaded && state.noticiaId == widget.noticiaId) {
          // Actualizar contadores cuando se cargan las estadísticas
          // Convertir del enum MotivoReporte a strings para mostrar los contadores
          setState(() {
            _estadisticasReportes = {
              'NoticiaInapropiada': state.estadisticas[MotivoReporte.noticiaInapropiada] ?? 0,
              'InformacionFalsa': state.estadisticas[MotivoReporte.informacionFalsa] ?? 0,
              'Otro': state.estadisticas[MotivoReporte.otro] ?? 0,
            };
          });
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFCEAE8), // Color rosa suave
        // Configurar un ancho máximo para el diálogo
        insetPadding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 24.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reducir el padding interno
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reportar Noticia',
                style: TextStyle(
                  fontSize: 16, // Reducir tamaño de fuente
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12), // Reducir espacio
              const Text(
                'Selecciona el motivo:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16), // Reducir espacio
              
              // Opciones de reporte con íconos y contadores - más compactas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.noticiaInapropiada,
                    icon: Icons.warning,
                    color: Colors.red,
                    label: 'Inapropiada',
                    iconNumber: '${_estadisticasReportes['NoticiaInapropiada']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.noticiaInapropiada,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.informacionFalsa,
                    icon: Icons.info,
                    color: Colors.amber,
                    label: 'Falsa',
                    iconNumber: '${_estadisticasReportes['InformacionFalsa']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.informacionFalsa,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.otro,
                    icon: Icons.flag,
                    color: Colors.blue,
                    label: 'Otro',
                    iconNumber: '${_estadisticasReportes['Otro']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.otro,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                ],
              ),
              
              const SizedBox(height: 16), // Reducir espacio
              
              // Botón para cerrar el diálogo
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _reporteEnviando ? null : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 14, // Reducir tamaño
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivoButton({
    required BuildContext context,
    required MotivoReporte motivo,
    required IconData icon,
    required Color color,
    required String label,
    required String iconNumber,
    bool isLoading = false,
    bool smallSize = false, // Nuevo parámetro para tamaño reducido
  }) {
    // Definir tamaños según el parámetro smallSize
    final buttonSize = smallSize ? 50.0 : 60.0;
    final iconSize = smallSize ? 24.0 : 30.0;
    final badgeSize = smallSize ? 16.0 : 18.0;
    final fontSize = smallSize ? 10.0 : 12.0;
    
    return Column(
      children: [
        InkWell(
          onTap: _reporteEnviando 
              ? null 
              : () => _enviarReporte(context, motivo),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mostrar un indicador de carga si este botón está en proceso
                if (isLoading)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: color,
                    size: iconSize,
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        iconNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: smallSize ? 6.0 : 8.0),
        Text(
          label,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  void _enviarReporte(BuildContext context, MotivoReporte motivo) {
    setState(() {
      _reporteEnviando = true;
      _ultimoMotivoReportado = motivo;
    });
    // Enviar el reporte usando el bloc
    context.read<ReporteBloc>().add(EnviarReporte(
          noticiaId: widget.noticiaId,
          motivo: motivo,
        ));
  }
}
