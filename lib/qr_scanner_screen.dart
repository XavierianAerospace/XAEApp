import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f), // Fondo principal XAE
      appBar: AppBar(
        title: Text('Escanear QR'),
        backgroundColor: Color(0xff1a1a2e), // Fondo de tarjetas
        foregroundColor: Color(0xffffffff), // Texto primario
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Simulación: QR Escaneado'),
                backgroundColor: Color(0xff1a1a2e),
              ),
            );
          },
          child: Text('Simular Escaneo', style: TextStyle(color: Color(0xff0a0a0f))),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff00ffff), // Acento primario cyan
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}