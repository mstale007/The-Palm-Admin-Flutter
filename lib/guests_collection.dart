import 'package:flutter/material.dart';

class GuestsCollection extends StatelessWidget {
  const GuestsCollection({
    Key key,
    @required this.data,
    @required List<TableRow> list_guests_curr,
  })  : _list_guests_curr = list_guests_curr,
        super(key: key);

  final String data;
  final List<TableRow> _list_guests_curr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(data),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(50),
                  },
                  children: _list_guests_curr,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
