import 'package:flutter/material.dart';
import 'menu_screen.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    if (_emailController.text == 'prueba@correo.com' && _passwordController.text == '1') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Color(0xffffaa00),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Image.asset(
                'assets/logo.png',
                height: 220,
                width: 220,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Color(0xff1a1a2e),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Color(0xff00ffff), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Xavierian Aerospace\nEngineering',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Color(0xffffffff)),
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(color: Color(0xffaaaaaa)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff00ffff)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffaaaaaa)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Color(0xffffffff)),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Color(0xffaaaaaa)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff00ffff)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffaaaaaa)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00ffff),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Color(0xff0a0a0f), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}