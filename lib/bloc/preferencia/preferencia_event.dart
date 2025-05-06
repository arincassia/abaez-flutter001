import 'package:equatable/equatable.dart';

 abstract class PreferenciaEvent extends Equatable {
   const PreferenciaEvent();

   @override
   List<Object?> get props => [];
 }

 class CargarPreferencias extends PreferenciaEvent {
   const CargarPreferencias();
 }

 class CambiarCategoria extends PreferenciaEvent {
   final String categoria;
   final bool seleccionada;

   const CambiarCategoria({
     required this.categoria,
     required this.seleccionada,
   });

   @override
   List<Object> get props => [categoria, seleccionada];
 }

 class CambiarMostrarFavoritos extends PreferenciaEvent {
   final bool mostrarFavoritos;

   const CambiarMostrarFavoritos({required this.mostrarFavoritos});

   @override
   List<Object> get props => [mostrarFavoritos];
 }

 class BuscarPorPalabraClave extends PreferenciaEvent {
   final String? palabraClave;

   const BuscarPorPalabraClave({this.palabraClave});

   @override
   List<Object?> get props => [palabraClave];
 }

 class FiltrarPorFecha extends PreferenciaEvent {
   final DateTime? fechaDesde;
   final DateTime? fechaHasta;

   const FiltrarPorFecha({
     this.fechaDesde,
     this.fechaHasta,
   });

   @override
   List<Object?> get props => [fechaDesde, fechaHasta];
 }

 class CambiarOrdenamiento extends PreferenciaEvent {
   final String ordenarPor;
   final bool ascendente;

   const CambiarOrdenamiento({
     required this.ordenarPor,
     required this.ascendente,
   });

   @override
   List<Object> get props => [ordenarPor, ascendente];
 }

 class ReiniciarFiltros extends PreferenciaEvent {
   const ReiniciarFiltros();
 }

 class SavePreferencias extends PreferenciaEvent {
  final List<String> categoriasSeleccionadas;

  const SavePreferencias({
    required this.categoriasSeleccionadas,
  });

  @override
  List<Object> get props => [categoriasSeleccionadas];
}
