import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Editar perfil')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xff00ffff),
              child: Icon(Icons.person, size: 70, color: Color(0xff0a0a0f)),
            ),
            SizedBox(height: 16),
            Text(
              'Santiago Castro',
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'prueba@correo.com',
              style: TextStyle(color: Color(0xffaaaaaa)),
            ),
            SizedBox(height: 24),
            _buildInfoCard('Subsistema', 'Programación', Icons.folder),
            _buildInfoCard('Rol', 'Desarrollador', Icons.work),
            _buildInfoCard('Miembro desde', 'Enero 2026', Icons.calendar_today),
            _buildInfoCard('Horas acumuladas', '120 horas', Icons.access_time),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(Icons.logout),
              label: Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffffaa00),
                foregroundColor: Color(0xff0a0a0f),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xff00ffff)),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
              Text(value, style: TextStyle(color: Color(0xffffffff), fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}