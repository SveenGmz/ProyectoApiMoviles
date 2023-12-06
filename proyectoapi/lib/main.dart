import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var urlData;
  void getApiData()async{

    var url = Uri.parse("https://api.unsplash.com/photos/?client_id=2b4S3Hur3_ojyYrhF1BRjFylYFrME3mMkV5pa4cTNvs");
    final res = await http.get(url);
    setState(() {
      urlData = jsonDecode(res.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProyectoApi_IramGmz'),
      ),
      body: Center(child: urlData==null
      ? CircularProgressIndicator() 
      : GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 6,crossAxisCount: 2, crossAxisSpacing: 6),
      itemBuilder: (context, i){
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(urlData[i]['urls']['full'])
            )
          ),
        );
      }),),
    );
  }
}

