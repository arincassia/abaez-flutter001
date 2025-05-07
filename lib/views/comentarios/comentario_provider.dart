import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';

class ComentarioProvider extends StatelessWidget {
  final Widget child;

  const ComentarioProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ComentarioBloc(), child: child);
  }
}
