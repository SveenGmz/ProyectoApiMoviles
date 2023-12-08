import 'package:flutter/material.dart';
import 'package:proyectoapi/pages/home_page.dart';
// Asegúrate de importar la ruta correcta

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: ThemeData.dark(),
      home: HomePage(), // Aquí se establece HomePage como la página principal
    );
  }
}
