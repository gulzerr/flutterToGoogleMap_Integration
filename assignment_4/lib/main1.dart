import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'GeoMap.dart';
import 'models/users.dart';
import 'models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.amber,
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

var user_info = new List();

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
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          leading: Icon(Icons.sentiment_very_satisfied,
            color: Colors.greenAccent,
          ),
          title: Text(
            users.users[index].name,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            users.users[index].location == null ? "Latitude = 23.779136, Longitude = 90.398331" :
            "Latitude= ${users.users[index].location.latitude}, "
                "Longitude= ${users.users[index].location.longitude}",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          onTap: (){
            user_info.clear();
            user_info.add(users.users[index].name);
            users.users[index].location == null ? user_info.add('23.779136') :
            user_info.add(users.users[index].location.latitude);
            users.users[index].location == null ? user_info.add('90.398331') :
            user_info.add(users.users[index].location.longitude);
            print(user_info[1]);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsDemo())
            );
//						Navigator.push(context, MaterialPageRoute(builder: (context ){
//							return MapsDemo(value: users.users[index]);
//						})
//						);
          },
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










class MapsDemo extends StatefulWidget {
  User value;
  MapsDemo({Key key,@required this.value}) : super(key : key);


  final String title = "Maps Demo";

  @override
  MapsDemoState createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {

//	User value;
//	MapsDemoState(this.value);
  static double latitude = user_info[1];
  static double longitude = user_info[1];
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(23.780249, 90.407777);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(latitude, longitude),
    tilt: 59.440,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: user_info[0],
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: new CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 15.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
//						Padding(
//							padding: EdgeInsets.all(16.0),
//							child: Align(
//								alignment: Alignment.topRight,
//								child: Column(
//									children: <Widget>[
//										button(_onMapTypeButtonPressed, Icons.map),
//										SizedBox(
//											height: 16.0,
//										),
//										button(_onAddMarkerButtonPressed, Icons.add_location),
//										SizedBox(
//											height: 16.0,
//										),
//										button(_goToPosition1, Icons.location_searching),
//									],
//								),
//							),
//						),
          ],
        ),
      ),
    );
  }
}