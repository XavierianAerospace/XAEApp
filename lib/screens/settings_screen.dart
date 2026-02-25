import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Configuración'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Preferencias',
            style: TextStyle(
              color: Color(0xffaaaaaa),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildSwitchTile(
            'Notificaciones',
            'Recibir alertas de eventos y tareas',
            Icons.notifications,
            _notifications,
                (value) => setState(() => _notifications = value),
          ),
          _buildSwitchTile(
            'Modo Oscuro',
            'Tema oscuro de la aplicación',
            Icons.dark_mode,
            _darkMode,
                (value) => setState(() => _darkMode = value),
          ),
          SizedBox(height: 24),
          Text(
            'Información',
            style: TextStyle(
              color: Color(0xffaaaaaa),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildInfoTile('Versión', '1.0.0', Icons.info),
          _buildInfoTile('Acerca de', 'XAE Manager', Icons.rocket_launch),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title,
      String subtitle,
      IconData icon,
      bool value,
      Function(bool) onChanged,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(color: Color(0xffffffff))),
        subtitle: Text(subtitle, style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
        secondary: Icon(icon, color: Color(0xff00ffff)),
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xff00ffff),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xff00ffff)),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
              Text(value, style: TextStyle(color: Color(0xffffffff))),
            ],
          ),
        ],
      ),
    );
  }
}