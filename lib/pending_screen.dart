import 'package:flutter/material.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  // Simulación de tareas pendientes
  final List<Map<String, dynamic>> tareasPendientes = [
    {
      'titulo': 'Organizar inventario',
      'subsistema': 'Logística',
      'urgencia': '!',
      'fecha': DateTime(2024, 12, 10),
      'completada': false,
    },
    {
      'titulo': 'Montar estructura',
      'subsistema': 'Mecánica',
      'urgencia': '!!',
      'fecha': DateTime(2024, 12, 7),
      'completada': false,
    },
    {
      'titulo': 'Depurar código',
      'subsistema': 'Programación',
      'urgencia': '!!!',
      'fecha': DateTime(2024, 12, 8),
      'completada': false,
    },
    {
      'titulo': 'Practicar maniobras',
      'subsistema': 'Drivers',
      'urgencia': '!!',
      'fecha': DateTime(2024, 12, 6),
      'completada': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f), // Fondo principal XAE
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 35.0),
          child: Text(
            'Tareas Pendientes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff), // Texto primario
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: tareasPendientes.length,
          itemBuilder: (context, index) {
            final tarea = tareasPendientes[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Color(0xff1a1a2e), // Fondo de tarjetas
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: tarea['completada']
                      ? Color(0xff00ffff)
                      : Color(0xffffaa00),
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Icon(
                  tarea['completada'] ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: tarea['completada'] ? Color(0xff00ffff) : Color(0xffffaa00),
                ),
                title: Text(
                  tarea['titulo'],
                  style: TextStyle(
                    color: Color(0xffffffff), // Texto primario
                    fontWeight: FontWeight.bold,
                    decoration: tarea['completada'] ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subsistema: ${tarea['subsistema']}',
                      style: TextStyle(color: Color(0xffaaaaaa)), // Texto secundario
                    ),
                    Text(
                      'Urgencia: ${tarea['urgencia']} | Fecha: ${tarea['fecha'].day}/${tarea['fecha'].month}/${tarea['fecha'].year}',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    tarea['completada'] = !tarea['completada'];
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar nueva tarea
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Función para agregar tarea'),
              backgroundColor: Color(0xff1a1a2e),
            ),
          );
        },
        backgroundColor: Color(0xff00ffff), // Acento primario cyan
        child: Icon(Icons.add, color: Color(0xff0a0a0f)),
      ),
    );
  }
}