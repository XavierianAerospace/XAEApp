import 'package:flutter/material.dart';
import 'data/dio_api_service.dart';
import 'login_screen.dart';

void main() {
  // Inicializar los servicios de Flutter y los plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Crear la instancia del servicio API (Dio + json-server)
  final apiService = DioApiService();

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final DioApiService apiService;

  MyApp({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Javex Robotics',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(apiService: apiService),
    );
  }
}
