import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_palm_admin/screen0.dart';
import 'package:the_palm_admin/screen1.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' The Palm Admin',
      home: Dashboard(),
    );
  }
}

//Base Page
class Dashboard extends StatefulWidget {
  // const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group_rounded),
                label: Text('Guests'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          ScreenContent(selectedIndex: _selectedIndex)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog(context, "", "", "", "", <Widget>[]);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_business_rounded),
      ),
    );
  }
}

class ScreenContent extends StatefulWidget {
  const ScreenContent({
    Key key,
    @required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  _ScreenContentState createState() => _ScreenContentState();
}

class _ScreenContentState extends State<ScreenContent> {
  Timestamp todayTimeStamp = Timestamp.now();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    switch (widget._selectedIndex) {
      case 0:
        return Screen0();
        break;
      case 1:
        return Screen1();
        break;
      default:
        return Expanded(
          child: Center(child: Text("Something went Wrong!")),
        );
    }
  }
}

Future<bool> addDialog(BuildContext context, selectedDoc, total_rooms, rates,
    feature_photo, img_list) async {
  var room_type = "";
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Add new Room Type", style: TextStyle(fontSize: 15.0)),
                GestureDetector(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            content: Container(
              height: 300.0,
              width: 500.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Rooms Type Name: "),
                    TextFormField(
                      initialValue: "",
                      onChanged: (value) {
                        room_type = value;
                      },
                    ),
                    Text("Total Rooms: "),
                    TextFormField(
                      initialValue: total_rooms.toString(),
                      onChanged: (value) {
                        total_rooms = value;
                      },
                    ),
                    Text("Rates: "),
                    TextFormField(
                      initialValue: rates.toString(),
                      onChanged: (value) {
                        rates = value;
                      },
                    ),
                    Text("Feature Photo: "),
                    TextFormField(
                      initialValue: feature_photo.toString(),
                      onChanged: (value) {
                        feature_photo = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  // print(total_rooms, rates, img_list, feature_photo);
                  addRoomData(room_type, {
                    'Total': total_rooms,
                    'rates': rates.toString(),
                    'featurePhoto': feature_photo.toString(),
                    'photos': [feature_photo.toString()].cast<String>()
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
      });
}

Future<void> addRoomData(selectedDoc, data) async {
  print(selectedDoc + data.toString());
  Firestore.instance
      .collection('Rooms')
      .document(selectedDoc)
      .setData(data)
      .catchError((e) {
    print(e);
  });
}
