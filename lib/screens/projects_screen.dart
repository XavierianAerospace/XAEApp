import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String searchQuery = '';
  String selectedCategory = 'Todos';

  final List<String> categories = ['Todos', 'Robótica', 'Aeroespacial', 'Software', 'Mecánica'];

  final List<Map<String, dynamic>> projects = [
    {
      'id': 1,
      'nombre': 'Robot Competencia 2026',
      'categoria': 'Robótica',
      'estado': 'En Progreso',
      'progreso': 0.65,
      'descripcion': 'Desarrollo de robot para competencia nacional de robótica',
      'equipo': ['Juan Pérez', 'María López', 'Carlos García'],
      'fecha_inicio': DateTime(2026, 1, 15),
    },
    {
      'id': 2,
      'nombre': 'Sistema de Telemetría',
      'categoria': 'Aeroespacial',
      'estado': 'Completado',
      'progreso': 1.0,
      'descripcion': 'Sistema de telemetría para cohetes experimentales',
      'equipo': ['Ana Torres', 'Santiago Castro'],
      'fecha_inicio': DateTime(2026, 10, 1),
    },
    {
      'id': 3,
      'nombre': 'App XAE Manager',
      'categoria': 'Software',
      'estado': 'En Progreso',
      'progreso': 0.45,
      'descripcion': 'Aplicación móvil para gestión del semillero',
      'equipo': ['Santiago Castro', 'Diana Rodríguez'],
      'fecha_inicio': DateTime(2026, 2, 1),
    },
    {
      'id': 4,
      'nombre': 'Brazo Robótico',
      'categoria': 'Mecánica',
      'estado': 'Planificación',
      'progreso': 0.15,
      'descripcion': 'Diseño y construcción de brazo robótico de 6 DOF',
      'equipo': ['Carlos García', 'Juan Pérez'],
      'fecha_inicio': DateTime(2026, 3, 1),
    },
  ];

  List<Map<String, dynamic>> get filteredProjects {
    return projects.where((project) {
      final matchesSearch = project['nombre'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Todos' || project['categoria'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 35.0),
          child: Text(
            'Proyectos XAE',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Color(0xffffffff)),
              decoration: InputDecoration(
                hintText: 'Buscar proyectos...',
                hintStyle: TextStyle(color: Color(0xffaaaaaa)),
                filled: true,
                fillColor: Color(0xff1a1a2e),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xff00ffff)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xff00ffff), width: 2),
                ),
                prefixIcon: Icon(Icons.search, color: Color(0xff00ffff)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => selectedCategory = category),
                    backgroundColor: Color(0xff1a1a2e),
                    selectedColor: Color(0xff00ffff),
                    labelStyle: TextStyle(
                      color: isSelected ? Color(0xff0a0a0f) : Color(0xffffffff),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) => _buildProjectCard(filteredProjects[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return GestureDetector(
      onTap: () => _showProjectDetail(project),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff1a1a2e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project['nombre'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                  ),
                ),
                _buildStatusChip(project['estado']),
              ],
            ),
            SizedBox(height: 8),
            Text(project['categoria'], style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14)),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progreso', style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
                    Text('${(project['progreso'] * 100).toInt()}%',
                        style: TextStyle(color: Color(0xff00ffff), fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project['progreso'],
                    backgroundColor: Color(0xff0a0a0f),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00ffff)),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: [
                Icon(Icons.people, size: 16, color: Color(0xffaaaaaa)),
                Text('${project['equipo'].length} miembros',
                    style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completado':
        color = Color(0xff00ffff);
        break;
      case 'En Progreso':
        color = Color(0xffffaa00);
        break;
      default:
        color = Color(0xffaaaaaa);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _showProjectDetail(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Color(0xff1a1a2e),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xffaaaaaa),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(project['nombre'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
              SizedBox(height: 8),
              _buildStatusChip(project['estado']),
              SizedBox(height: 20),
              Text('Descripción',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff00ffff))),
              SizedBox(height: 8),
              Text(project['descripcion'], style: TextStyle(color: Color(0xffffffff), fontSize: 16)),
              SizedBox(height: 20),
              Text('Equipo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff00ffff))),
              SizedBox(height: 8),
              ...List.generate(
                project['equipo'].length,
                    (index) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xff00ffff),
                        child: Text(project['equipo'][index][0],
                            style: TextStyle(color: Color(0xff0a0a0f))),
                      ),
                      SizedBox(width: 12),
                      Text(project['equipo'][index], style: TextStyle(color: Color(0xffffffff))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildInfoRow('Categoría', project['categoria']),
              _buildInfoRow('Fecha de inicio',
                  '${project['fecha_inicio'].day}/${project['fecha_inicio'].month}/${project['fecha_inicio'].year}'),
              _buildInfoRow('Progreso', '${(project['progreso'] * 100).toInt()}%'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xffaaaaaa))),
          Text(value, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}