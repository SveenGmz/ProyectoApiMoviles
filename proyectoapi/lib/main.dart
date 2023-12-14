import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoapi/pages/check_auth_screen.dart';
import 'package:proyectoapi/pages/home_page.dart';
import 'package:proyectoapi/pages/pantalla_login.dart';
import 'package:proyectoapi/pages/register_screen.dart';
import 'package:proyectoapi/servicios/aut_servicios.dart';
import 'package:proyectoapi/servicios/notificacion_servicios.dart';

void main() => runApp(AppState());

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
    
      debugShowCheckedModeBanner: false, 
      title: 'Login',
      initialRoute:
          'checking', // Primero checha si no esta logueado, al no estarlo manda a LoginPage
      routes: {
        'login': (_) => LoginPage(), // pantalla de inicio de sesión
        'register': (_) => RegisterScreen(), // pantalla de registro
        'home': (_) => MyApiWidget(), // pantalla principal
        'checking': (_) =>
            CheckAuthScreen(), // pantalla de verificación de autenticación
      },
      scaffoldMessengerKey: NotificationsService
          .messengerKey, 
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0), 
        appBarTheme: const AppBarTheme(
            elevation: 0, color: Color.fromARGB(255, 77, 65, 240) ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 77, 65, 240) , elevation: 0),
      ),
      
      home: FutureBuilder(
        future: Provider.of<AuthService>(context)
            .readToken(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data as String).isNotEmpty) {
              // Si hay un token, el usuario ha iniciado sesión, muestra HomeScreen
              return MyApiWidget();
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