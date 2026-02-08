import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthAuthenticated extends AuthState {
  final String username;

  const AuthAuthenticated(this.username);

  @override
  List<Object?> get props => [username];
}

class AuthUnauthenticated extends AuthState {}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthUnauthenticated());

  void login(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      emit(AuthAuthenticated(username));
    }
  }

  void logout() {
    emit(AuthUnauthenticated());
  }

  bool get isAuthenticated => state is AuthAuthenticated;

  String? get username {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).username;
    }
    return null;
  }
}
