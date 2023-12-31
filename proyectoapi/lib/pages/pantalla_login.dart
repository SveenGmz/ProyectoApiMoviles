import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoapi/pages/register_screen.dart';
import 'package:proyectoapi/providers/login_form_provider.dart';
import 'package:proyectoapi/servicios/aut_servicios.dart';
import 'package:proyectoapi/pages/home_page.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginFormProvider _loginFormProvider = LoginFormProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/fondogif.gif'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 50,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 30.0),
              ChangeNotifierProvider(
                create: (_) => _loginFormProvider,
                child: _LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('¿No tienes una cuenta? ¡Regístrate aquí!',
                style: TextStyle(
                  color: const Color.fromARGB(255, 170, 168, 168), 
                  fontSize: 15, 
                  fontWeight: FontWeight.w300, 
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  _LoginForm({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginFormProvider.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: Color.fromARGB(255, 247, 247, 247).withOpacity(0.5),
              filled: true,
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
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
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: Color.fromARGB(255, 247, 247, 247).withOpacity(0.5),
              filled: true,
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              if (loginFormProvider.isValidForm()) {
                loginFormProvider.isLoading = true;
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final email = emailController.text;
                final password = passwordController.text;

                String? result = await authService.login(email, password);

                loginFormProvider.isLoading = false;

                if (result == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApiWidget()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Inicio de Sesión Incorrecto'),
                        content: Text(result),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: Text('Iniciar Sesión',
            style: TextStyle(
              color: const Color.fromARGB(255, 170, 168, 168),
            )),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 159, 30, 233),
            ),
          ),
        ],
      ),
    );
  }
}
