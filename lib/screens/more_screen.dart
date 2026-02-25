import 'package:flutter/material.dart';
import 'members_screen.dart';
import 'communications_screen.dart';
import 'social_screen.dart';
import 'repositories_screen.dart';
import 'printer_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Text('Más Opciones', style: TextStyle(color: Color(0xffffffff))),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Información del Semillero',
            style: TextStyle(
              color: Color(0xffaaaaaa),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildOptionCard(
            context,
            Icons.people,
            'Integrantes',
            'Directorio de miembros',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => MembersScreen())),
          ),
          _buildOptionCard(
            context,
            Icons.campaign,
            'Comunicaciones',
            'Noticias y calendario',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommunicationsScreen())),
          ),
          _buildOptionCard(
            context,
            Icons.share,
            'Redes Sociales',
            'Enlaces y feeds',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => SocialScreen())),
          ),
          _buildOptionCard(
            context,
            Icons.code,
            'Repositorios',
            'Proyectos en GitHub',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => RepositoriesScreen())),
          ),
          SizedBox(height: 24),
          Text(
            'Herramientas',
            style: TextStyle(
              color: Color(0xffaaaaaa),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildOptionCard(
            context,
            Icons.print,
            'Impresora 3D',
            'Gestión de impresiones',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrinterScreen())),
          ),
          SizedBox(height: 24),
          Text(
            'Configuración',
            style: TextStyle(
              color: Color(0xffaaaaaa),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildOptionCard(
            context,
            Icons.person,
            'Perfil',
            'Ver y editar perfil',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
          _buildOptionCard(
            context,
            Icons.settings,
            'Configuración',
            'Ajustes de la app',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
          SizedBox(height: 24),
          _buildOptionCard(
            context,
            Icons.logout,
            'Cerrar Sesión',
            'Salir de la aplicación',
                () => Navigator.of(context).popUntil((route) => route.isFirst),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDestructive ? Color(0xffffaa00) : Color(0xff00ffff)).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Color(0xffffaa00) : Color(0xff00ffff),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Color(0xffffaa00) : Color(0xffffffff),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xffaaaaaa),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}