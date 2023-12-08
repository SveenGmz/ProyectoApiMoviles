import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoapi/pages/check_auth_screen.dart';
import 'package:proyectoapi/pages/home_page.dart';
import 'package:proyectoapi/pages/pantalla_login.dart';
import 'package:proyectoapi/pages/register_screen.dart';
import 'package:proyectoapi/servicios/aut_servicios.dart';
import 'package:proyectoapi/servicios/notificacion_servicios.dart';

// Punto de entrada principal de la aplicación
void main() => runApp(AppState());

// Clase principal que envuelve la aplicación con los proveedores necesarios
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Le avisa a todo el codigo si hay cambio
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuraciones generales de la aplicación
      debugShowCheckedModeBanner: false, //quita la barra debug
      title: 'Login',
      initialRoute:
          'checking', // Primero checha si no esta logueado, al no estarlo manda a LoginPage
      routes: {
        'login': (_) => LoginPage(), // pantalla de inicio de sesión
        'register': (_) => RegisterScreen(), // pantalla de registro
        'home': (_) => HomePage(), // pantalla principal
        'checking': (_) =>
            CheckAuthScreen(), // pantalla de verificación de autenticación
      },
      scaffoldMessengerKey: NotificationsService
          .messengerKey, // Clave para gestionar notificaciones
      theme: ThemeData.light().copyWith(
        // Configuraciones de tema general de la aplicación
        scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0), // Color de fondo de los scaffold
        appBarTheme: const AppBarTheme(
            elevation: 0, color: Color.fromARGB(255, 77, 65, 240) ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 77, 65, 240) , elevation: 0),
      ),
      // Widget principal que determina qué pantalla mostrar basado en la lógica de autenticación
      home: FutureBuilder(
        future: Provider.of<AuthService>(context)
            .readToken(), //revisa asincronicamente si el token leido es correcto
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se verifica el estado de autenticación, muestra un cargador si es necesario
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data as String).isNotEmpty) {
              // Si hay un token, el usuario ha iniciado sesión, muestra HomeScreen
              return HomePage();
            } else {
              // Si no hay un token, el usuario no ha iniciado sesión, muestra LoginPage
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}