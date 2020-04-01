

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
class News {
  final String title;
  final String description;
  final String author;
  final String urlToimage;
  final String publishedAt;

  News(this.title, this.description, this.author, this.urlToimage,
      this.publishedAt);
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
  @override
  void initState() {
    super.initState();
  }



  Future<List<News>> getNews() async {
    var data = await http.get(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=fe364fd4923f47c1b112a77b224c885d');
    var jsonData = json.decode(data.body);
    var newsData = jsonData['articles'];
    List<News> news = [];

    //insert data in array from api
    for (var data in newsData) {
      News newsItem = News(data['title'], data['description'], data['author'],
          data['urlToImage'], data['publishedAt']);
      news.add(newsItem);
    }
    return news;
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
                     duration: const Duration(milliseconds: 100),
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
        child: FutureBuilder(
            future: getNews(),
            //snapshot is accept data and is equal to response that use in kotlin
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                       News news= new News(snapshot.data[index].title,
                         snapshot.data[index].description,
                         snapshot.data[index].author,
                         snapshot.data[index].urlToimage,
                         snapshot.data[index].publishedAt);
                       Navigator.push(
                         context,MaterialPageRoute(
                         builder: (context)=>new Details(news: news,)
                       )
                       );
                      },
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 120.0,
                              height: 110.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),

                                child: snapshot.data[index].urlToimage == null
                                    ?Image.network('https://images.squarespace-cdn.com/content/v1/5c8586f5a9ab9526954d136a/1580013122150-90UEF5OO3K7P2G2JKVK6/ke17ZwdGBToddI8pDm48kPoswlzjSVMM-SxOp7CV59BZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIeQMKeWYgwh6Mn73n2eZmZLHHpcPIxgL2SArp_rN2M_AKMshLAGzx4R3EDFOm1kBS/image-asset.jpeg')
                                :Image.network(
                                  snapshot.data[index].urlToimage,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),


                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(snapshot.data[index].title),
                                subtitle: Text(
                                    snapshot.data[index].author == null
                                        ? 'Unknown Author'
                                        : snapshot.data[index].author),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
        ),
           ),

           );
       },
     ),
    );
  }
}
class Details extends StatelessWidget{
  final News news;
  Details({this.news});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Container(
         child: Column(
           children: <Widget>[
             //Stack is to put out multiple layout widget
             Stack(
               children: <Widget>[
                 Container(
                   height: 400,
                   child: Image.network('${this.news.urlToimage}',
                   fit: BoxFit.fill,),
                 ),
                 AppBar(
                   backgroundColor: Colors.transparent,
                   leading: InkWell(
                     child: Icon(Icons.arrow_back_ios),
                     onTap: ()=> Navigator.pop(context),
                   ),
                   elevation: 0,
                 )
               ],
             ),
             Padding(
               padding: const EdgeInsets.all(8),
               child: Column(
                 children: <Widget>[
                   SizedBox(
                     height: 10,
                   ),
                   Text('${this.news.title}',
                     style: TextStyle(
                       color: Colors.black87,
                       fontWeight: FontWeight.bold,
                       fontSize: 20,
                       letterSpacing: 0.2,
                       wordSpacing: 0.6
                     ),
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Text(
                     this.news.description,

                     style: TextStyle(
                       color: Colors.black45,
                       fontSize: 16,
                       wordSpacing: 0.4
                     ),
                   )
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }
}