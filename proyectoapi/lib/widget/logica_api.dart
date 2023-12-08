import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData();
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

class FullImageView extends StatelessWidget {
  final String url;
  FullImageView({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Image View'),
      ),
      body: Hero(
        tag: 'full',
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
