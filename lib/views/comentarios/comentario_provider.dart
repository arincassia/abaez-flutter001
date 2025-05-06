import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentario/comentario_bloc.dart';

class ComentarioProvider extends StatelessWidget {
  final Widget child;

  const ComentarioProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ComentarioBloc(), child: child);
  }
}
