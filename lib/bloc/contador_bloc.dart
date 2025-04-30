import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/state/contador_state.dart'; 
// Eventos del contador
abstract class ContadorEvent {}

class IncrementarContador extends ContadorEvent {}

class DecrementarContador extends ContadorEvent {}

class ResetearContador extends ContadorEvent {}

// Bloc del contador
class ContadorBloc extends Bloc<ContadorEvent, ContadorState> {
  ContadorBloc() : super(ContadorState(0)) {
    on<IncrementarContador>((event, emit) {
      emit(ContadorState(state.contador + 1));
    });

    on<DecrementarContador>((event, emit) {
      emit(ContadorState(state.contador - 1));
    });

    on<ResetearContador>((event, emit) {
      emit(ContadorState(0));
    });
  }
}