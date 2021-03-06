import 'package:flutter/material.dart';
import 'package:diary_app/model/entry.dart';
import 'package:diary_app/util/dbhelper.dart';
import 'package:diary_app/screens/entrydetail.dart';

class EntryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EntryListState();
}

class EntryListState extends State {
  DbHelper helper = DbHelper();
  List<Entry> entries;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (entries == null) {
      entries = List<Entry>();
      getData();
    }

    return Scaffold(
        body: entryListItems(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Entry('', ''));
          },
          tooltip: "Add new Entry",
          child: new Icon(Icons.add),
        ));
  }

  ListView entryListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: Text(getDateDigit(this.entries[position].date)),
            ),
            title: Text(this.entries[position].title),
            subtitle: Text(this.entries[position].date),
            onTap: () {
              debugPrint("Tapped on " + this.entries[position].id.toString());
              navigateToDetail(this.entries[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final entriesFuture = helper.getEntries();
      entriesFuture.then((result) {
        List<Entry> entryList = List<Entry>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          entryList.add(Entry.fromObject(result[i]));
          debugPrint(entryList[i].title);
        }

        setState(() {
          entries = entryList;
          count = count;
        });

        debugPrint("Items " + count.toString());
      });
    });
  }

  void navigateToDetail(Entry entry) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => EntryDetail(entry))
    );
    if (result == true) {
      getData();
    }
  }

  String getDateDigit(String date) {
    String day = date.split('/')[0];

    if (day[0] == '0') {
      day = day[1].toString();
    } 

    return day;
  }

  String getWeekDay()

}
