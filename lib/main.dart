import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
/*
* ======= COMENTARIOS =======
* En la bottom navbar, dejar inicio, tareas, perfil(creo) y más.
* Falta definir si (toda la app) va a tener header.
* En integrantes y tareas falta el popup como está en proyectos.
* */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XAE Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff00ffff),
        scaffoldBackgroundColor: Color(0xff0a0a0f),

        // Aún no funciona
        fontFamily: 'Doto',

        colorScheme: ColorScheme.dark(
          primary: Color(0xff00ffff),
          secondary: Color(0xffffaa00),
          background: Color(0xff0a0a0f),
          surface: Color(0xff1a1a2e),
        ),

        textTheme: TextTheme(
          // Títulos grandes
          displayLarge: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),

          // Títulos de sección
          headlineLarge: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          // Títulos en tarjetas
          titleLarge: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),

          // Texto del cuerpo
          bodyLarge: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffaaaaaa),
            fontSize: 12,
          ),

          // Labels
          labelLarge: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffffffff),
            fontSize: 14,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffaaaaaa),
            fontSize: 12,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Doto',
            color: Color(0xffaaaaaa),
            fontSize: 10,
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}