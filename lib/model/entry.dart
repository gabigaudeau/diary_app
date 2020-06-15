class Entry {

  // FIELDS
  final List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  int _id;
  String _title;
  String _description;
  String _date;
  String _weekday;

  // CONSTRUCTORS
  // square brackets are for optional parameter
  Entry(this._title, this._date, this._weekday, [this._description]);
  Entry.withId(this._id, this._title, this._date, this._weekday,
      [this._description]);

  // METHODS
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  String get weekday => _weekday;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set date(String newDate) {
    if (newDate.length == 10) {
      _date = newDate;
    } else if (newDate.length == 9) {
      _date = '0' + newDate;
    }
  }

  set weekday(String newWeekday) {
    if (weekdays.contains(newWeekday)) {
      _weekday = newWeekday;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Entry.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._date = o["date"];
  }
}
