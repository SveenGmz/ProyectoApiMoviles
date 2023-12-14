import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyectoapi/servicios/aut_servicios.dart';

class MyApiWidget extends StatefulWidget {
  @override
  _MyApiWidgetState createState() => _MyApiWidgetState();
}

class _MyApiWidgetState extends State<MyApiWidget> {
  var urlData;

  void getApiData() async {
    var url = Uri.parse(
        "https://api.unsplash.com/photos/?per_page=30&client_id=2b4S3Hur3_ojyYrhF1BRjFylYFrME3mMkV5pa4cTNvs");
    final res = await http.get(url);
    setState(() {
      urlData = jsonDecode(res.body);
      print(urlData);
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  void addToFavorites(String imageUrl) async {
    try {
      final AuthService authService = AuthService();
      final String userId = await authService.obtenerUserId();

      await authService.agregarFavorito(context, imageUrl, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen agregada a favoritos con éxito'),
        ),
      );
    } catch (error) {
      print('Error al agregar favorito: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar favorito'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return urlData == null
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            itemCount: 30,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 6,
              crossAxisCount: 2,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullImageView(
                        url: urlData[i]['urls']['full'],
                        onFavoritePressed: () {
                          addToFavorites(urlData[i]['urls']['full']);
                        },
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'full_$i',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(urlData[i]['urls']['full']),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class FullImageView extends StatefulWidget {
  final String url;
  final VoidCallback onFavoritePressed;

  FullImageView({
    required this.url,
    required this.onFavoritePressed,
  });

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  bool isFavorited = false;

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
      if (isFavorited) {
        // Puedes implementar lógica adicional aquí si es necesario
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'full',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 300,
            child: SizedBox(
              width: 64,
              height: 64,
              child: FloatingActionButton(
                onPressed: () {
                  widget.onFavoritePressed(); // Llamada a la función del padre
                  toggleFavorite();
                },
                backgroundColor: Colors.white.withOpacity(0.0),
                child: Icon(
                  isFavorited
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: const Color.fromARGB(255, 228, 62, 50),
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
