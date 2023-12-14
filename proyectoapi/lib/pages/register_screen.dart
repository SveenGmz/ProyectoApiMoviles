import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoapi/servicios/aut_servicios.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/fondogif.gif'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Registro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  fillColor:
                      Color.fromARGB(255, 247, 247, 247).withOpacity(0.5),
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // Validación del correo electrónico
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Ingresa un correo electrónico válido';
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  fillColor:
                      Color.fromARGB(255, 247, 247, 247).withOpacity(0.5),
                  filled: true,
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  // Validación de la contraseña
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe tener al menos 6 caracteres';
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  // Espera respuesta y si es asignado correctamente el token, registra
                  String? result =
                      await authService.createUser(email, password);

                  if (result == null) {

                    Navigator.pushReplacementNamed(context, 'login');
                  } else {
                    print('Error en el registro: $result');
                  }
                },
                child: Text(
                    'Registrar'
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Color.fromARGB(255, 230, 229, 229),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 30, 101, 233),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
