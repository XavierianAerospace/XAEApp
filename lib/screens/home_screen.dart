import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Text('Inicio', style: TextStyle(color: Color(0xffffffff))),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color(0xff00ffff)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida
            Text(
              'Bienvenido al Semillero XAE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
            SizedBox(height: 20),

            // Resumen
            _buildSummaryCard(
              icon: Icons.assignment,
              title: 'Tareas Pendientes',
              value: '12',
              color: Color(0xffffaa00),
            ),
            SizedBox(height: 12),
            _buildSummaryCard(
              icon: Icons.folder,
              title: 'Proyectos Activos',
              value: '5',
              color: Color(0xff00ffff),
            ),
            SizedBox(height: 12),
            _buildSummaryCard(
              icon: Icons.people,
              title: 'Miembros Activos',
              value: '24',
              color: Color(0xff00ffff),
            ),
            SizedBox(height: 24),

            // Noticias recientes
            Text(
              'Noticias Recientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
            SizedBox(height: 12),
            _buildNewsCard(
              title: 'Reunión General',
              date: '24 Feb 2026',
              content: 'Se realizará la reunión semanal del semillero.',
            ),
            SizedBox(height: 12),
            _buildNewsCard(
              title: 'Nuevo Proyecto',
              date: '24 Feb 2026',
              content: 'ExpoJaveriana.',
            ),
            SizedBox(height: 24),

            // Accesos rápidos
            Text(
              'Accesos Rápidos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickAccessCard(Icons.print, 'Impresora 3D'),
                _buildQuickAccessCard(Icons.calendar_today, 'Calendario'),
                _buildQuickAccessCard(Icons.inventory, 'Inventario'),
                _buildQuickAccessCard(Icons.people, 'Integrantes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String date,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Color(0xff00ffff)),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Color(0xffffffff), fontSize: 14),
          ),
        ],
      ),
    );
  }
}