import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/quiz_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_bloc.dart';
import 'package:challenge_liber_quiz/repositories/quiz_repository_impl.dart';
import 'package:challenge_liber_quiz/screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(QuizRepositoryImpl()),
        ),
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(QuizRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0175C2)),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
