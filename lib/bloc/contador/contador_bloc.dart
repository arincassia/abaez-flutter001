import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/contador/contador_event.dart';
import 'package:abaez/bloc/contador/contador_state.dart';

class ContadorBloc extends Bloc<ContadorEvento, ContadorEstado> {
  ContadorBloc() : super(ContadorValor(0)) {
    on<IncrementEvent>((event, emit) {
      final currentState = state as ContadorValor;
      emit(ContadorValor(currentState.valor + 1));
    });

    on<DecrementEvent>((event, emit) {
      final currentState = state as ContadorValor;
      emit(ContadorValor(currentState.valor - 1));
    });

    on<ResetEvent>((event, emit) {
      emit(ContadorValor(0));
    });
  }
}