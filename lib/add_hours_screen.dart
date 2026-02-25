import 'package:flutter/material.dart';

class AddHoursScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Agregar Horas'),
      ),
      body: Center(
        child: Text(
          'Aquí irá el lector de QR',
          style: TextStyle(color: Color(0xffffffff), fontSize: 18),
        ),
      ),
    );
  }
}