import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/tareas_contador/tareas_contador_event.dart';
import 'package:abaez/bloc/tareas_contador/tareas_contador_state.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(TareaContadorState()) {
    on<IncrementarContador>((event, emit) {
      emit(state.copyWith(completadas: state.completadas + 1));
    });

    on<DecrementarContador>((event, emit) {
      emit(state.copyWith(completadas: state.completadas - 1));
    });

    on<SetTotalTareas>((event, emit) {
      emit(state.copyWith(total: event.total));
    });

    on<SetCompletadas>((event, emit) {
      emit(state.copyWith(completadas: event.completadas));
    });
  }
}