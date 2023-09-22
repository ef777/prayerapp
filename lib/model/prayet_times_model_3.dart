class PrayerTimesModel3 {
  Place? place;
  Times? times;

  PrayerTimesModel3({this.place, this.times});

  PrayerTimesModel3.fromJson(Map<String, dynamic> json, String date) {
    place = json['place'] != null ? new Place.fromJson(json['place']) : null;
    times =
        json['times'] != null ? new Times.fromJson(json['times'], date) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.place != null) {
      data['place'] = this.place!.toJson();
    }
    if (this.times != null) {
      data['times'] = this.times!.toJson();
    }
    return data;
  }
}

class Place {
  String? countryCode;
  String? country;
  String? region;
  String? city;
  double? latitude;
  double? longitude;

  Place(
      {this.countryCode,
      this.country,
      this.region,
      this.city,
      this.latitude,
      this.longitude});

  Place.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    country = json['country'];
    region = json['region'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['country'] = this.country;
    data['region'] = this.region;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Times {
  List<dynamic>? l20230312;

  Times({this.l20230312});

  Times.fromJson(Map<String, dynamic> json, String date) {
    l20230312 = json[date];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['2023-03-12'] = this.l20230312;
    return data;
  }
}
