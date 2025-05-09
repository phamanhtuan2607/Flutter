import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_1/blocs/auth/auth_bloc.dart';
import 'package:app_1/blocs/task/task_bloc.dart';
import 'package:app_1/database/database_helper.dart';
import 'package:app_1/screens/login_screen.dart';
import 'package:app_1/screens/register_screen.dart';
import 'package:app_1/screens/task_list_screen.dart';
import 'package:app_1/services/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authService = AuthService();
  final databaseHelper = DatabaseHelper.instance;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authService: authService,
            databaseHelper: databaseHelper,
          )..add(CheckAuthStatus()),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(
            databaseHelper: databaseHelper,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is Authenticated) {
            return TaskListScreen(user: state.userId); // Sử dụng userId từ state
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tasks': (context) => BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return TaskListScreen(user: state.userId);
            }
            return const LoginScreen();
          },
        ),
      },
    );
  }
}