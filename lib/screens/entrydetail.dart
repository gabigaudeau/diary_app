import 'package:flutter/material.dart';
import 'package:diary_app/model/entry.dart';
import 'package:diary_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>[
  'Save Entry & Back',
  'Delete Entry',
  'Back to List'
];

const mnuSave = 'Save Entry & Back';
const mnuDelete = 'Delete Entry';
const mnuBack = 'Back to List';

class EntryDetail extends StatefulWidget {
  final Entry entry;
  EntryDetail(this.entry);

  @override
  State<StatefulWidget> createState() => EntryDetailState(entry);
}

class EntryDetailState extends State {
  Entry entry;
  EntryDetailState(this.entry);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = entry.title;
    descriptionController.text = entry.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(entry.date),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) => this.updateTitle(),
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                          maxLines: 8,
                          controller: descriptionController,
                          style: textStyle,
                          onChanged: (value) => this.updateDescription(),
                          decoration: InputDecoration(
                              labelText: "Entry",
                              alignLabelWithHint: true,
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ))),
                    ),
                  ],
                )
              ],
            )));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (entry.id == null) {
          return;
        }
        result = await helper.deleteEntry(entry.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Entry"),
            content: Text("The Entry has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    entry.date = new DateFormat.yMd().format(DateTime.now());
    entry.weekday = DateFormat('EEEE').format(DateTime.now());
    if (entry.id != null) {
      helper.updateEntry(entry);
    } else {
      helper.insertEntry(entry);
    }
    Navigator.pop(context, true);
  }

  void updateTitle() {
    entry.title = titleController.text;
  }

  void updateDescription() {
    entry.description = descriptionController.text;
  }
}
