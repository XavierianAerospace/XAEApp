import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_routes.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';

void main() {
  // Inicializar los servicios de Flutter y los plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Service Locator (GetIt) para inyección de dependencias
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el AuthBloc desde GetIt
    final authBloc = GetIt.I<AuthBloc>();

    // Iniciar verificación de autenticación
    authBloc.add(AuthCheckRequested());

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        // Determinar si el usuario está autenticado
        final isAuthenticated = state is AuthAuthenticated;

        return MaterialApp.router(
          title: 'Javex Robotics',
          theme: ThemeData(primarySwatch: Colors.red),
          routerConfig: AppRouter.createRouter(
            initiallyAuthenticated: isAuthenticated,
          ),
        );
      },
    );
  }
}
