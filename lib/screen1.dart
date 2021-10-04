import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_palm_admin/guests_collection.dart';

class Screen1 extends StatelessWidget {
  const Screen1({
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
                "Guests",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("Reservation")
                        .getDocuments()
                        .asStream(),
                    builder: (context, snapshot) {
                      var data = 'Current Guests';
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text('Loading');
                        default:
                          List<TableRow> _list_guests_curr = [];
                          List<TableRow> _list_guests_upcoming = [];
                          List<TableRow> _list_guests_past = [];

                          //List of Current Guests
                          //First Row
                          _list_guests_curr.add(
                            TableRow(children: <Widget>[
                              Text("#"),
                              Text("Name"),
                              Text("No. of Guests"),
                              Text("Check-in"),
                              Text("Check-out"),
                              Text("Pay ID")
                            ]),
                          );

                          //List of Current Guests
                          //First Row
                          _list_guests_upcoming.add(
                            TableRow(children: <Widget>[
                              Text("#"),
                              Text("Name"),
                              Text("No. of Guests"),
                              Text("Check-in"),
                              Text("Check-out"),
                              Text("Pay ID")
                            ]),
                          );

                          //List of Current Guests
                          //First Row
                          _list_guests_past.add(
                            TableRow(children: <Widget>[
                              Text("#"),
                              Text("Name"),
                              Text("No. of Guests"),
                              Text("Check-in"),
                              Text("Check-out"),
                              Text("Pay ID")
                            ]),
                          );
                          snapshot.data.documents
                              .asMap()
                              .forEach((index, value) {
                            //Divide the data in 3 lists past, current, upcoming
                            if (value.data["Check-out"]
                                        .compareTo(Timestamp.now()) ==
                                    1 &&
                                value.data["Check-in"]
                                        .compareTo(Timestamp.now()) ==
                                    -1) {
                              _list_guests_curr.add(TableRow(children: [
                                Text(index.toString()),
                                Text(value.data['Name']),
                                Text(value.data['Guests'].toString()),
                                Text(
                                    '${value.data["Check-in"].toDate().day}-${value.data["Check-in"].toDate().month}-${value.data["Check-in"].toDate().year}'),
                                Text(
                                    '${value.data["Check-out"].toDate().day}-${value.data["Check-out"].toDate().month}-${value.data["Check-out"].toDate().year}'),
                                Text(value.data['PayID']),
                              ]));
                            } else if (value.data["Check-in"]
                                    .compareTo(Timestamp.now()) ==
                                1) {
                              _list_guests_upcoming.add(TableRow(children: [
                                Text(index.toString()),
                                Text(value.data['Name']),
                                Text(value.data['Guests'].toString()),
                                Text(
                                    '${value.data["Check-in"].toDate().day}-${value.data["Check-in"].toDate().month}-${value.data["Check-in"].toDate().year}'),
                                Text(
                                    '${value.data["Check-out"].toDate().day}-${value.data["Check-out"].toDate().month}-${value.data["Check-out"].toDate().year}'),
                                Text(value.data['PayID']),
                              ]));
                            } else {
                              _list_guests_past.add(TableRow(children: [
                                Text(index.toString()),
                                Text(value.data['Name']),
                                Text(value.data['Guests'].toString()),
                                Text(
                                    '${value.data["Check-in"].toDate().day}-${value.data["Check-in"].toDate().month}-${value.data["Check-in"].toDate().year}'),
                                Text(
                                    '${value.data["Check-out"].toDate().day}-${value.data["Check-out"].toDate().month}-${value.data["Check-out"].toDate().year}'),
                                Text(value.data['PayID']),
                              ]));
                            }
                          });
                          return Column(
                            children: [
                              GuestsCollection(
                                  data: 'Current Guests',
                                  list_guests_curr: _list_guests_curr),
                              SizedBox(
                                height: 50,
                              ),
                              GuestsCollection(
                                  data: 'Upcoming Guests',
                                  list_guests_curr: _list_guests_upcoming),
                              SizedBox(
                                height: 50,
                              ),
                              GuestsCollection(
                                  data: 'Past Guests',
                                  list_guests_curr: _list_guests_past),
                            ],
                          );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
