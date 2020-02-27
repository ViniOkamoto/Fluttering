import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _incrementCounter() {
    _counter++;
    _streamController.sink.add(_counter);
  }
  void _decrementCounter() {
    _counter--;
    _streamController.sink.add(_counter);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.android,
          size: 30,
        ),
        backgroundColor: Colors.black45,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle( color: Colors.deepOrange, fontSize: 20),
            ),
           StreamBuilder<int>(
             initialData: 0,
             stream: _streamController.stream,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               return Text(
                 "${snapshot.data}",
                 style: TextStyle(fontSize: 30, color: Colors.deepOrange),
               );
             },
           )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepOrange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2,
                child: Icon( Icons.exposure_neg_1,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onTap: _decrementCounter,
              ),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                child: Icon( Icons.exposure_plus_1,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onTap: _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}
