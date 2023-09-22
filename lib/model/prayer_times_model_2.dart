class HijriModel {
  HijriModel({
    required this.code,
    required this.status,
    required this.data,
  });
  late final int code;
  late final String status;
  late final Data data;

  HijriModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.hijri,
    required this.gregorian,
  });
  late final Hijri hijri;
  late final Gregorian gregorian;

  Data.fromJson(Map<String, dynamic> json) {
    hijri = Hijri.fromJson(json['hijri']);
    gregorian = Gregorian.fromJson(json['gregorian']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['hijri'] = hijri.toJson();
    _data['gregorian'] = gregorian.toJson();
    return _data;
  }
}

class Hijri {
  Hijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
  });
  late final String date;
  late final String format;
  late final String day;
  late final Weekday weekday;
  late final Month month;
  late final String year;
  late final Designation designation;
  late final List<dynamic> holidays;

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = Weekday.fromJson(json['weekday']);
    month = Month.fromJson(json['month']);
    year = json['year'];
    designation = Designation.fromJson(json['designation']);
    holidays = List.castFrom<dynamic, dynamic>(json['holidays']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['format'] = format;
    _data['day'] = day;
    _data['weekday'] = weekday.toJson();
    _data['month'] = month.toJson();
    _data['year'] = year;
    _data['designation'] = designation.toJson();
    _data['holidays'] = holidays;
    return _data;
  }
}

class Weekday {
  Weekday({
    required this.en,
    required this.ar,
  });
  late final String en;
  late final String ar;

  Weekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['ar'] = ar;
    return _data;
  }
}

class Month {
  Month({
    required this.number,
    required this.en,
    required this.ar,
  });
  late final int number;
  late final String en;
  late final String ar;

  Month.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['en'] = en;
    _data['ar'] = ar;
    return _data;
  }
}

class Designation {
  Designation({
    required this.abbreviated,
    required this.expanded,
  });
  late final String abbreviated;
  late final String expanded;

  Designation.fromJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['abbreviated'] = abbreviated;
    _data['expanded'] = expanded;
    return _data;
  }
}

class Gregorian {
  Gregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });
  late final String date;
  late final String format;
  late final String day;
  late final Weekday weekday;
  late final Month month;
  late final String year;
  late final Designation designation;

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = Weekday.fromJson(json['weekday']);
    month = Month.fromJson(json['month']);
    year = json['year'];
    designation = Designation.fromJson(json['designation']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['format'] = format;
    _data['day'] = day;
    _data['weekday'] = weekday.toJson();
    _data['month'] = month.toJson();
    _data['year'] = year;
    _data['designation'] = designation.toJson();
    return _data;
  }
}
