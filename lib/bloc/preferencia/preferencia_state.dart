import 'package:equatable/equatable.dart';
 import 'package:flutter/foundation.dart';

 @immutable
 class PreferenciaState extends Equatable {
   final List<String> categoriasSeleccionadas;
   final bool mostrarFavoritos;
   final String? palabraClave;
   final DateTime? fechaDesde;
   final DateTime? fechaHasta;
   final String ordenarPor;
   final bool ascendente;

   const PreferenciaState({
     this.categoriasSeleccionadas = const [],
     this.mostrarFavoritos = false,
     this.palabraClave,
     this.fechaDesde,
     this.fechaHasta,
     this.ordenarPor = 'fecha',
     this.ascendente = false,
   });

   PreferenciaState copyWith({
     List<String>? categoriasSeleccionadas,
     bool? mostrarFavoritos,
     String? palabraClave,
     DateTime? fechaDesde,
     DateTime? fechaHasta,
     String? ordenarPor,
     bool? ascendente,
   }) {
     return PreferenciaState(
       categoriasSeleccionadas: categoriasSeleccionadas ?? this.categoriasSeleccionadas,
       mostrarFavoritos: mostrarFavoritos ?? this.mostrarFavoritos,
       palabraClave: palabraClave ?? this.palabraClave,
       fechaDesde: fechaDesde ?? this.fechaDesde,
       fechaHasta: fechaHasta ?? this.fechaHasta,
       ordenarPor: ordenarPor ?? this.ordenarPor,
       ascendente: ascendente ?? this.ascendente,
     );
   }

   @override
   List<Object?> get props => [
     categoriasSeleccionadas,
     mostrarFavoritos,
     palabraClave,
     fechaDesde,
     fechaHasta,
     ordenarPor,
     ascendente,
   ];
 }

 class PreferenciaError extends PreferenciaState {
  final String mensaje;

  const PreferenciaError(this.mensaje, {int? statusCode});

  @override
  List<Object?> get props => [mensaje, ...super.props];
}
