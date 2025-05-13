import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/data/auth_repository.dart';
import 'package:abaez/bloc/auth/auth_event.dart';
import 'package:abaez/bloc/auth/auth_state.dart';
import 'package:watch_it/watch_it.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository= di<AuthRepository>(); // Obtenemos el repositorio del locator

  AuthBloc(): super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure(error: 'El usuario y la contraseña son obligatorios'));
        return;
      }
      
      final success = await _authRepository.login(
        event.email,
        event.password,
      );
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(const AuthFailure(error: 'Credenciales inválidas'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}