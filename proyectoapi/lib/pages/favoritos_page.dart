import 'package:flutter/material.dart';
import 'package:proyectoapi/models/favorito_model.dart';
import 'package:proyectoapi/servicios/aut_servicios.dart';
import 'package:proyectoapi/widget/logica_api.dart';

class FavoritosPage extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imágenes Favoritas'),
      ),
      body: FutureBuilder<List<Favorito>>(
        future: authService.obtenerFavoritos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final favoritos = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 6,
                crossAxisCount: 2,
                crossAxisSpacing: 6,
              ),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImageView(
                          url: favoritos[index].urls,
                          onFavoritePressed: () {
                            // Agrega la lógica para agregar a favoritos aquí
                            authService.agregarFavorito(
                              context,
                              favoritos[index].urls,
                              favoritos[index].userId,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(favoritos[index].urls),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
