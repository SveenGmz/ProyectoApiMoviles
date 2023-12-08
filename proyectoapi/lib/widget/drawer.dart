import 'package:flutter/material.dart';
import 'package:proyectoapi/widget/logica_api.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite), // Icono de favoritos
            title: Text('Favoritos'),
            onTap: () {
              // Lógica para el apartado de favoritos
              // ...
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout), // Icono de logout
            title: Text('Logout'),
            onTap: () {
              // Lógica para el logout
              // ...
            },
          ),
        ],
      ),
    );
  }
}
