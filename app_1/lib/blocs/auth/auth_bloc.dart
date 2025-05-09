import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/auth_service.dart';
import '../../database/database_helper.dart';
import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final DatabaseHelper databaseHelper;

  AuthBloc({required this.authService, required this.databaseHelper})
      : super(AuthInitial()) {
    // Xử lý kiểm tra trạng thái đăng nhập
    on<CheckAuthStatus>(_onCheckAuthStatus);

    // Xử lý đăng nhập bằng email
    on<EmailLoginRequested>(_onEmailLoginRequested);

    // Xử lý đăng ký bằng email
    on<EmailRegisterRequested>(_onEmailRegisterRequested);

    // Xử lý đăng nhập bằng Google
    on<GoogleLoginRequested>(_onGoogleLoginRequested);

    // Xử lý đăng xuất
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser != null) {
        final localUser = await databaseHelper.getUser(currentUser.uid);
        if (localUser != null) {
          emit(Authenticated(userId: currentUser.uid, user: localUser));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onEmailLoginRequested(
      EmailLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await authService.signInWithEmail(event.email, event.password);
      if (user != null) {
        final localUser = await databaseHelper.getUser(user.uid);
        if (localUser != null) {
          emit(Authenticated(userId: user.uid, user: localUser));
        } else {
          final newUser = User(
            id: user.uid,
            username: user.displayName ?? user.email!.split('@')[0],
            email: user.email!,
            password: '',
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
            avatar: user.photoURL,
          );
          await databaseHelper.createUser(newUser);
          emit(Authenticated(userId: user.uid, user: newUser));
        }
      } else {
        emit(AuthError(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onEmailRegisterRequested(
      EmailRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await authService.registerWithEmail(event.email, event.password);
      if (user != null) {
        final newUser = User(
          id: user.uid,
          username: event.username,
          email: event.email,
          password: '',
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        await databaseHelper.createUser(newUser);
        emit(Authenticated(userId: user.uid, user: newUser));
      } else {
        emit(AuthError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequested(
      GoogleLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());  // Hiển thị trạng thái loading khi đăng nhập

    try {
      final user = await authService.signInWithGoogle();  // Gọi phương thức sign in với Google

      if (user != null) {
        final localUser = await databaseHelper.getUser(user.uid);

        if (localUser != null) {
          emit(Authenticated(userId: user.uid, user: localUser));
        } else {
          final newUser = User(
            id: user.uid,
            username: user.displayName ?? user.email!.split('@')[0],
            email: user.email!,
            password: '',
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
            avatar: user.photoURL,
          );
          await databaseHelper.createUser(newUser);
          emit(Authenticated(userId: user.uid, user: newUser));
        }
      } else {
        emit(AuthError(message: 'Google sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));  // Xử lý lỗi
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}