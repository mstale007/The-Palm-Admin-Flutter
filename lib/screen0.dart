import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Screen0 extends StatelessWidget {
  const Screen0({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: [
              Text(
                "Rooms",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("Rooms").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading');
                      default:
                        List<Widget> _list_rooms = [];
                        snapshot.data.documents.forEach((element) {
                          _list_rooms.add(RoomCollection(
                              room_type: element.documentID,
                              total_rooms: element.data['Total'],
                              rates: element.data['rates'],
                              feature_photo: element.data['featurePhoto'],
                              img_list: element.data['photos'].cast<String>()));
                          print(element);
                        });
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _list_rooms,
                          ),
                        );
                    }
                  },
                ),
              ),
              // RoomCollection(
              //     room_type: room_type,
              //     total_rooms: total_rooms,
              //     rates: rates,
              //     feature_photo: feature_photo,
              //     img_list: img_list),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomCollection extends StatelessWidget {
  const RoomCollection({
    Key key,
    @required this.room_type,
    @required this.total_rooms,
    @required this.rates,
    @required this.feature_photo,
    @required this.img_list,
  }) : super(key: key);

  final String room_type;
  final String total_rooms;
  final String rates;
  final String feature_photo;
  final List<String> img_list;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(room_type),
                  Column(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () {
                          updateDialog(context, room_type, total_rooms, rates,
                              feature_photo, img_list);
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          deleteDialog(context, room_type);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [Text("Total Rooms: "), Text(total_rooms.toString())],
              ),
              Row(
                children: [Text("Rates: "), Text(rates.toString())],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Feature Photo: "),
                  Image.network(feature_photo),
                ],
              ),
              Column(
                children: [
                  Text('Photos '),
                  Column(
                      children: new List.generate(
                          img_list.length,
                          (index) => Container(
                                  child: Image.network(
                                img_list[index],
                                width: 100,
                              ))).toList())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> updateDialog(BuildContext context, selectedDoc, total_rooms, rates,
    feature_photo, img_list) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Edit the Data for ' + selectedDoc,
                    style: TextStyle(fontSize: 15.0)),
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
                    Text("Photos: "),
                    Column(
                      children: new List.generate(
                          img_list.length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((index + 1).toString()),
                                  TextFormField(
                                      initialValue: img_list[index],
                                      onChanged: (value) {
                                        img_list[index] = value;
                                      }),
                                ],
                              )),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  // print(total_rooms, rates, img_list, feature_photo);
                  updateRoomData(selectedDoc, {
                    'Total': total_rooms,
                    'rates': rates.toString(),
                    'featurePhoto': feature_photo.toString(),
                    'photos': img_list.cast<String>()
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

updateRoomData(selectedDoc, newValues) {
  Firestore.instance
      .collection('Rooms')
      .document(selectedDoc)
      .updateData(newValues)
      .catchError((e) {
    print(e);
  });
}

Future<bool> deleteDialog(BuildContext context, selectedDoc) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Do you want to delete ' + selectedDoc + " ?",
                style: TextStyle(fontSize: 15.0)),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                textColor: Colors.green,
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteData(selectedDoc).catchError((e) {});
                },
              ),
              FlatButton(
                child: Text('No'),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
      });
}

deleteData(docId) {
  Firestore.instance
      .collection('Rooms')
      .document(docId)
      .delete()
      .catchError((e) {
    print(e);
  });
}
