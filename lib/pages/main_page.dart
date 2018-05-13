import 'package:flutter/material.dart';
import 'package:pomotimer/interval_widget.dart';

class HomePage extends StatefulWidget {
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(title: new Text('aye test')),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new IntervalTimeForm()],
        ),
      ),
    );
  }
}
