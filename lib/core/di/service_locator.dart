import 'package:get_it/get_it.dart';
import '../../data/api_service.dart';
import '../../data/dio_api_service.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/menu/bloc/menu_bloc.dart';
import '../../features/pending/bloc/pending_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/inventory/bloc/inventory_bloc.dart';
import '../../features/add_hours/bloc/add_hours_bloc.dart';

/// Service Locator - Inyección de Dependencias con GetIt
///
/// Esta clase se encarga de registrar todas las dependencias del proyecto
/// siguiendo el patrón de Singleton (servicios globales) y Factory (instancias efímeras)
final getIt = GetIt.instance;

/// Configuración inicial del Service Locator
void setupServiceLocator() {
  // ==================== REGISTRAR SINGLETONS (Servicios Globales) ====================

  /// API Service - Se crea UNA sola instancia que se reutiliza en toda la app
  getIt.registerSingleton<ApiService>(
    DioApiService(),
  );

  // ==================== REGISTRAR FACTORIES (Instancias Efímeras - BLoCs) ====================

  /// AuthBloc - Factory Pattern: Se crea una nueva instancia cada vez que se accede
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(apiService: getIt<ApiService>()),
  );

  /// HomeBloc - Factory Pattern
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(apiService: getIt<ApiService>()),
  );

  /// MenuBloc - Factory Pattern
  getIt.registerFactory<MenuBloc>(
    () => MenuBloc(apiService: getIt<ApiService>()),
  );

  /// PendingBloc - Factory Pattern
  getIt.registerFactory<PendingBloc>(
    () => PendingBloc(apiService: getIt<ApiService>()),
  );

  /// ProfileBloc - Factory Pattern
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(apiService: getIt<ApiService>()),
  );

  /// InventoryBloc - Factory Pattern
  getIt.registerFactory<InventoryBloc>(
    () => InventoryBloc(apiService: getIt<ApiService>()),
  );

  /// AddHoursBloc - Factory Pattern
  getIt.registerFactory<AddHoursBloc>(
    () => AddHoursBloc(apiService: getIt<ApiService>()),
  );
}
