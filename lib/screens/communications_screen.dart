import 'package:flutter/material.dart';

class CommunicationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xff0a0a0f),
        appBar: AppBar(
          backgroundColor: Color(0xff1a1a2e),
          foregroundColor: Color(0xffffffff),
          title: Text('Comunicaciones'),
          bottom: TabBar(
            indicatorColor: Color(0xff00ffff),
            labelColor: Color(0xff00ffff),
            unselectedLabelColor: Color(0xffaaaaaa),
            tabs: [
              Tab(text: 'Noticias'),
              Tab(text: 'Eventos'),
              Tab(text: 'Contactos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewsList(),
            _buildEventsList(),
            _buildContactsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildNewsCard('Reunión General', '24 Feb 2026', 'Se realizará la reunión semanal'),
        _buildNewsCard('Nuevo Proyecto', '03 Feb 2026', 'Inicio del proyecto de prueba'),
      ],
    );
  }

  Widget _buildEventsList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildEventCard('ExpoJaveriana', '24 Feb 2026', '08:30'),
        _buildEventCard('Otro día', '03 Mar 2026', '10:00'),
      ],
    );
  }

  Widget _buildContactsList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildContactCard('Email', 'aess@javeriana.edu.co', Icons.email),
        _buildContactCard('Teléfono', '+57 300 123 4567', Icons.phone),
      ],
    );
  }

  Widget _buildNewsCard(String title, String date, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(date, style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
          SizedBox(height: 8),
          Text(content, style: TextStyle(color: Color(0xffaaaaaa))),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String date, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.event, color: Color(0xff00ffff), size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('$date - $time', style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String label, String value, IconData icon) {
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
              Text(label, style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12)),
              Text(value, style: TextStyle(color: Color(0xffffffff))),
            ],
          ),
        ],
      ),
    );
  }
}