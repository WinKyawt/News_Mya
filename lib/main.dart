import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
 bool isLoggedIn =false;
 Map userProfile;

 _loginWithFB(){

 }
 _logout(){

 }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        
        body: Center(
          
          child: isLoggedIn ?
          Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
         //Image.network("https://placehold.it/20×20", height: 20.0, width: 20,),
              
              Text(""),
              OutlineButton(
                child: Text("Logout"),
                onPressed: (){
                  _logout();
                },
                ),
            ],
          )
          
          : OutlineButton(
            child:Text("Login with Facebook"),
            onPressed:(){
              _loginWithFB();
            },
          ),
        ),
      ),
    );
  }
}