import 'package:flutter/material.dart';
import 'package:proyectoapi/widget/drawer.dart';
import 'package:proyectoapi/widget/logica_api.dart'; 
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Agrega un botón de menú en la barra de la aplicación
         
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: size.width,
            height: size.height * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
                image: AssetImage('assets/1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "What would you like\n to Find?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 228, 228, 228),
                      contentPadding: EdgeInsets.only(top: 5),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: Color.fromARGB(255, 146, 146, 146),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 131, 131, 131),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MyApiWidget(), // Widget para mostrar la API de imágenes
          ),
        ],
      ),
      // Asigna el Drawer personalizado al Scaffold
      drawer: CustomDrawer(),
    );
  }
}
