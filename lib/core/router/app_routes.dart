import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/menu/menu_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/pending/pending_screen.dart';
import '../../features/inventory/inventory_screen.dart';

class AppRouter {
  static GoRouter createRouter({
    required bool initiallyAuthenticated,
  }) {
    return GoRouter(
      initialLocation: initiallyAuthenticated ? '/menu' : '/login',

      redirect: (BuildContext context, GoRouterState state) {
        final isLoginRoute = state.uri.path == '/login';

        if (!initiallyAuthenticated && !isLoginRoute) {
          return '/login';
        }

        if (initiallyAuthenticated && isLoginRoute) {
          return '/menu';
        }

        return null;
      },

      routes: <RouteBase>[
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

        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          name: 'profile',
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const ProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          name: 'pending',
          path: '/pending',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const PendingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          name: 'inventory',
          path: '/inventory',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const InventoryScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],

      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri}'),
        ),
      ),
    );
  }
}
