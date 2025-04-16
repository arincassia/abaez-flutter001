import 'dart:math';

class Noticia {
  final String titulo;
  final String contenido;
  final String fuente;
  final DateTime publicadaEl;

  Noticia({
    required this.titulo,
    required this.contenido,
    required this.fuente,
    required this.publicadaEl,
  });
}

class NoticiaRepository {
  final Random _random = Random();
  final List<String> fuentes = [
    'El Diario',
    'Noticias Globales',
    'La Voz',
    'Mundo Actual',
    'Reporte Diario',
    'El Informador',
    'Noticias Hoy',
    'La Prensa',
    'Actualidad Mundial',
    'El Observador',
  ];
  // Método para obtener noticias iniciales
  Future<List<Noticia>> getNoticias() async {
    await Future.delayed(const Duration(seconds: 2)); 

    final List<String> titulosPredefinidos = [
      'Noticia sobre tecnología',
      'Avances en inteligencia artificial',
      'Descubrimientos científicos recientes',
      'Noticias del mundo financiero',
      'Tendencias en redes sociales',
      'Innovaciones en el sector salud',
      'Noticias sobre cambio climático',
      'Avances en exploración espacial',
      'Actualización sobre criptomonedas',
      'Noticias del sector educativo',
      'Nuevas leyes tecnológicas',
      'Impacto de la tecnología en la sociedad',
      'Noticias sobre ciberseguridad',
      'Avances en energías renovables',
      'Noticias del sector automotriz',
    ];

    return List.generate(15, (index) {
      final fuente = fuentes[_random.nextInt(fuentes.length)];
      final publicadaEl = DateTime.now().subtract(Duration(days: _random.nextInt(30)));

      return Noticia(
        titulo: titulosPredefinidos[index],
        contenido: 'Este es el contenido de la noticia: ${titulosPredefinidos[index]}.',
        fuente: fuente,
        publicadaEl: publicadaEl,
      );
    });
  }
  // Método para obtener noticias paginadas
  Future<List<Noticia>> getPaginatedNoticias({required int pageNumber, int pageSize = 5}) async {
  await Future.delayed(const Duration(seconds: 2));

  final offset = (pageNumber - 1) * pageSize;

 
  final List<String> palabrasClave = [
    'Tecnología',
    'Inteligencia Artificial',
    'Ciencia',
    'Finanzas',
    'Redes Sociales',
    'Salud',
    'Cambio Climático',
    'Exploración Espacial',
    'Criptomonedas',
    'Educación',
    'Leyes',
    'Ciberseguridad',
    'Energías Renovables',
    'Automotriz',
    'Innovación',
  ];

   //Generar noticias aleatorias
  return List.generate(pageSize, (index) {
    final noticiaNumber = offset + index + 1;
    final fuente = fuentes[_random.nextInt(fuentes.length)];
    final publicadaEl = DateTime.now().subtract(Duration(days: _random.nextInt(30)));

    final palabra1 = palabrasClave[_random.nextInt(palabrasClave.length)];
    final titulo = 'Noticias sobre $palabra1';

    return Noticia(
      titulo: titulo,
      contenido: 'Este es el contenido de la noticia número $noticiaNumber sobre $palabra1',
      fuente: fuente,
      publicadaEl: publicadaEl,
    );
  });
 }  
}