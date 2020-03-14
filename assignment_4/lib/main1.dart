import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/users.dart';
import 'models/user.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const String url = 'http://anontech.info/courses/cse491/employees.json';

  static Future<Users> getUsers() async {
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        return parseUsers(response.body);
      } else {
        return Users();
      }
    } catch (e) {
      print('Error ${e.toString()}');
      return Users();
    }
  }

  static Users parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<User> users = parsed.map<User>((json) => User.fromJson(json)).toList();
    Users u = Users();
    u.users = users;
    return u;
  }

  Users users;
  String title;
  @override
  void initState(){
    super.initState();
    title = 'Loading users...';
    users = Users();
    getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
        title = widget.title;
        print(users.users);
      });
    });
  }

  Widget list() {
    return Expanded(
      child: ListView.builder(
        itemCount: users.users == null ? 0 : users.users.length,
        itemBuilder: (BuildContext context, int index) {
          return row(index);
        },
      ),
    );
  }

  Widget row(int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              users.users[index].name,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5.0,                      // 23.810331, 90.412521
            ),
            Text(
              users.users[index].location == null ? "Latitude = 23.810331, Longitude = 90.412521" :
              "Latitude= ${users.users[index].location.latitude.toString()}, "
                  "Longitude= ${users.users[index].location.longitude.toString()}",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            list(),
          ],
        ),
      ),
    );
  }
}