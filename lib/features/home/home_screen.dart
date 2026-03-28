import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _allTasks = [];
  final List<String> _miembrosActivos = [];
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    final totalTareasPendientes = _allTasks.length;

    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título principal con padding superior
              Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Center(
                  child: Text(
                    'Bienvenido de vuelta al semillero',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Logo centrado en grande
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              // Número de tareas pendientes
              Center(
                child: Text(
                  'Tareas pendientes: $totalTareasPendientes',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Subtítulo y lista de miembros activos
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Miembros en el Laboratorio:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Fondo blanco con bordes redondeados para la lista de miembros activos
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _miembrosActivos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.green,
                      ),
                      title: Text(
                        _miembrosActivos[index],
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
