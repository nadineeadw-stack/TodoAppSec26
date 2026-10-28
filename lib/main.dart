import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/todo/todo_cubit.dart';
import 'package:todo_app/services/auth_ser.dart';
import 'package:todo_app/services/todo_repository.dart';
import 'package:todo_app/screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(create: (context) => AuthService()),
        RepositoryProvider<TodoRepository>(
          create: (context) => TodoRepository(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(context.read<AuthService>()),
              ),
              BlocProvider<TodoCubit>(
                create: (context) => TodoCubit(context.read<TodoRepository>()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const SignUpScreen(),
            ),
          );
        },
      ),
    );
  }
}
