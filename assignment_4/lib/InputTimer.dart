import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class InputTimer extends StatefulWidget {
  String value;

  InputTimer({Key key, @required this.value}) : super(key: key);

  final String title = "Maps Demo";

  @override
  InputTimerState createState() => InputTimerState(value);
}

class InputTimerState extends State<InputTimer> {
  String value;
  InputTimerState(this.value);

  var _textController = new TextEditingController();

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(value.toString()),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email or Phone number",
                  hintStyle: TextStyle(color: Colors.grey[400])),
              keyboardType: TextInputType.number,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                int time = int.parse(_textController.text);
                Timer(Duration(seconds: time), (){
                  showToast("Rased toast after ${_textController.text} Seconds", gravity: Toast.BOTTOM);
                }
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
