import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Map<String, List<Map<String, dynamic>>> _tasksByStatus = {
    'Por Hacer': [
      {
        'title': 'Diseñar chasis',
        'priority': 'Alta',
        'assignee': 'Juan',
        'subsystem': 'Mecánica',
      },
      {
        'title': 'Configurar sensores',
        'priority': 'Media',
        'assignee': 'María',
        'subsystem': 'Electrónica',
      },
    ],
    'En Progreso': [
      {
        'title': 'Desarrollar algoritmo navegación',
        'priority': 'Alta',
        'assignee': 'Carlos',
        'subsystem': 'Programación',
      },
      {
        'title': 'Pruebas de motor',
        'priority': 'Alta',
        'assignee': 'Ana',
        'subsystem': 'Mecánica',
      },
    ],
    'Completadas': [
      {
        'title': 'Documentar API',
        'priority': 'Baja',
        'assignee': 'Pedro',
        'subsystem': 'Programación',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Text('Gestión de Tareas', style: TextStyle(color: Color(0xffffffff))),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Color(0xff00ffff)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filtros de tareas')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: _tasksByStatus.entries.map((entry) {
          return _buildTaskColumn(entry.key, entry.value);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Crear nueva tarea')),
          );
        },
        backgroundColor: Color(0xff00ffff),
        child: Icon(Icons.add, color: Color(0xff0a0a0f)),
      ),
    );
  }

  Widget _buildTaskColumn(String status, List<Map<String, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xff00ffff),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tasks.length}',
                  style: TextStyle(color: Color(0xff0a0a0f), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ...tasks.map((task) => _buildTaskCard(task)).toList(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPriorityColor(task['priority']).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task['title'],
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildPriorityChip(task['priority']),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.folder, size: 16, color: Color(0xff00ffff)),
              SizedBox(width: 4),
              Text(
                task['subsystem'],
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xff00ffff),
                child: Text(
                  task['assignee'][0],
                  style: TextStyle(color: Color(0xff0a0a0f), fontSize: 12),
                ),
              ),
              SizedBox(width: 8),
              Text(
                task['assignee'],
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(priority).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getPriorityColor(priority), width: 1),
      ),
      child: Text(
        priority,
        style: TextStyle(color: _getPriorityColor(priority), fontSize: 10),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Color(0xffffaa00);
      case 'Baja':
        return Colors.green;
      default:
        return Color(0xffaaaaaa);
    }
  }
}