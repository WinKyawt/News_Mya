

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}





void main() => runApp(
  MaterialApp(
    home: MyApp(),
  )
);
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
       builder: (BuildContext context){
         return OfflineBuilder(
           connectivityBuilder: (
             BuildContext context,
             ConnectivityResult connectivity,
             Widget child,
           ){
             final bool conn = connectivity != ConnectivityResult.none;
             return Stack(
               fit: StackFit.expand,
               children: [
                 child,
                 Positioned(
                   left: 0.0,
                   right: 0.0,
                   height: 100,
                   child: AnimatedContainer(
                     duration: const Duration(milliseconds: 300),
                     color:  conn ? null : Colors.teal,
                     child: conn ? null : 
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Text("Offline",
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 30,
                         ),),
                         SizedBox(width: 8.0,),
                         SizedBox(
                           width: 12,
                           height: 12,
                           child: CircularProgressIndicator(
                             strokeWidth: 2.0,
                             valueColor: AlwaysStoppedAnimation(Colors.white),
                           ),
                         )
                       ],
                     ),
                     ))
               ],
             );
           },
           child: Center(
            child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data.title);
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(snapshot.data.title),
                        Text(snapshot.data.title),
                        
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
           ),

           );
       },
     ),
    );
  }
}