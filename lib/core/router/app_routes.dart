import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/menu/menu_screen.dart';

/// Router Configuration - GoRouter
///
/// Configuración de rutas con Go Router siguiendo los requisitos del documento:
/// - Navegación declarativa con deep linking
/// - Rutas nombradas para navegación clara
/// - Protected routes con middleware de autenticación
/// - Transiciones personalizadas coherentes con el estilo XAE
class AppRouter {
  /// Configuración de GoRouter con middleware de autenticación
  static GoRouter createRouter({
    required bool initiallyAuthenticated,
  }) {
    return GoRouter(
      /// Ruta inicial según el estado de autenticación
      initialLocation: initiallyAuthenticated ? '/menu' : '/login',

      /// Redirect logic - Protected Routes
      /// Este middleware verifica autenticación antes de navegar
      redirect: (BuildContext context, GoRouterState state) {
        final isLoginRoute = state.uri.path == '/login';

        // Si no está autenticado y no está en login, redirigir a login
        if (!initiallyAuthenticated && !isLoginRoute) {
          return '/login';
        }

        // Si está autenticado y trata de acceder a login, redirigir a menu
        if (initiallyAuthenticated && isLoginRoute) {
          return '/menu';
        }

        // No redirigir, permitir navegación
        return null;
      },

      /// Lista de rutas
      routes: <RouteBase>[
        /// RUTA: Login
        GoRoute(
          name: 'login',
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        /// RUTA: Menu (Navegación Principal)
        GoRoute(
          name: 'menu',
          path: '/menu',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),

        /// RUTA: Home
        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        /// RUTA: Profile
        GoRoute(
          name: 'profile',
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        /// RUTA: Pending
        GoRoute(
          name: 'pending',
          path: '/pending',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        /// RUTA: Inventory
        GoRoute(
          name: 'inventory',
          path: '/inventory',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const MenuScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],

      /// Manejo de errores 404
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri}'),
        ),
      ),
    );
  }
}
