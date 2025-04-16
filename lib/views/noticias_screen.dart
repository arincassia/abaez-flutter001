import 'package:flutter/material.dart';
import 'package:abaez/api/noticia_service.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/components/noticia_card.dart';
import 'package:abaez/constans.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  NoticiasScreenState createState() => NoticiasScreenState();
}

class NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiaService noticiaService = NoticiaService(NoticiaRepository());
  final ScrollController _scrollController = ScrollController();

  List<Noticia> noticiasList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  String? mensajeError;

  @override
  void initState() {
    super.initState();
    _loadInitialNoticias();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore && !isLoading) {
        _loadNoticias();
      }
    });
  }
   // Carga inicial de noticias
   Future<void> _loadInitialNoticias() async {
    setState(() {
      isLoading = true;
      noticiasList.clear();
      currentPage = 1;
      hasMore = true;
      mensajeError = null;
    });
    try {

  final initialNoticias = await noticiaService.getNoticias();

  setState(() {
    if (initialNoticias.isEmpty) {
      hasMore = false;
    } else {
      noticiasList.addAll(initialNoticias);
      currentPage++;
    }
  });
 } 
  catch (e) {
  setState(() {
    mensajeError = AppConstants.mensajeError;
 });
} 
  finally {
  setState(() {
    isLoading = false;
  });
 }
}
  // Carga de noticias paginadas
  Future<void> _loadNoticias() async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
      mensajeError = null;
    });

    try {
      final newNoticias = await noticiaService.obtenerNoticiasPaginadas(
        numeroPagina: currentPage,
        tamanoPagina: AppConstants.tamanoPaginaConst,
      );

      setState(() {
        if (newNoticias.isEmpty) {
          hasMore = false;
        } else {
          noticiasList.addAll(newNoticias);
          currentPage++;
        }
      });
    } 
    catch (e) {
      setState(() {
        mensajeError = AppConstants.mensajeError;
      });
    } 
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.tituloNoticias),
      ),
      body: Container(
        color: Colors.grey[200],
        child: isLoading && noticiasList.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(AppConstants.mensajeCargando),
                  ],
                ),
              )
            : mensajeError != null
                ? Center(
                    child: Text(
                      mensajeError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : noticiasList.isEmpty
                    ? const Center(
                        child: Text(
                          AppConstants.listasVacia,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: noticiasList.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == noticiasList.length) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final noticia = noticiasList[index];
                          return NoticiaCard(noticia: noticia, index: index); //realiza el llamado al card de noticias
                        },
                      ),
               ),
      );
  }
 
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}