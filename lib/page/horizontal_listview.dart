

import 'package:flutter/material.dart';

class HorizontalListView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '横向listview',
      home: Scaffold(
        appBar: AppBar(
          title: Text('横向ListView'),
        ),
        body: Center(
          child: Container(
            height: 200.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 380.0,
                  color: Colors.blue,
                ),
                Container(
                  width: 380.0,
                  color: Colors.pink,
                ),
                Container(
                  width: 380.0,
                  color: Colors.blueAccent,
                ),
                Container(
                  width: 380.0,
                  color: Colors.green,
                ),

              ],

            ),
          ),

        ),
      ),

    );
  }
}