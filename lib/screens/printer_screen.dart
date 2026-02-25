import 'package:flutter/material.dart';

class PrinterScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _printJobs = [
    {
      'name': 'Chasis Rover v3',
      'status': 'Imprimiendo',
      'progress': 0.65,
      'user': 'Juan Pérez',
      'timeRemaining': '2h 15m',
    },
    {
      'name': 'Soporte Sensor',
      'status': 'En Cola',
      'progress': 0.0,
      'user': 'María López',
      'timeRemaining': '45m',
    },
    {
      'name': 'Rueda Prototipo',
      'status': 'Completado',
      'progress': 1.0,
      'user': 'Carlos García',
      'timeRemaining': '0m',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Impresora 3D'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Subir nuevo modelo')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Estado de la impresora
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff1a1a2e),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff00ffff)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estado de la Impresora',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xff00ffff).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Activa',
                        style: TextStyle(color: Color(0xff00ffff)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Icon(Icons.print, size: 60, color: Color(0xff00ffff)),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Cola de Trabajos',
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ..._printJobs.map((job) => _buildJobCard(job)).toList(),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1a1a2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(job['status']).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  job['name'],
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(job['status']).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job['status'],
                  style: TextStyle(color: _getStatusColor(job['status']), fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: Color(0xffaaaaaa)),
              SizedBox(width: 4),
              Text(
                job['user'],
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
              ),
              Spacer(),
              Icon(Icons.access_time, size: 14, color: Color(0xffaaaaaa)),
              SizedBox(width: 4),
              Text(
                job['timeRemaining'],
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
              ),
            ],
          ),
          if (job['progress'] > 0 && job['progress'] < 1) ...[
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: job['progress'],
              backgroundColor: Color(0xff0a0a0f),
              valueColor: AlwaysStoppedAnimation(_getStatusColor(job['status'])),
            ),
            SizedBox(height: 4),
            Text(
              '${(job['progress'] * 100).toInt()}%',
              style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Imprimiendo':
        return Color(0xff00ffff);
      case 'En Cola':
        return Color(0xffffaa00);
      case 'Completado':
        return Colors.green;
      default:
        return Color(0xffaaaaaa);
    }
  }
}