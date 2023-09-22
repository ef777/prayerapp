import 'dart:io';
import 'package:http/http.dart' as http;

class PrayerTimesModel {
  bool? success;
  List<Result>? result;

  PrayerTimesModel({this.success, this.result});

  PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? saat;
  String? vakit;

  Result({this.saat, this.vakit});

  Result.fromJson(Map<String, dynamic> json) {
    saat = json['saat'];
    vakit = json['vakit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saat'] = this.saat;
    data['vakit'] = this.vakit;
    return data;
  }
}

class ApiService {
  static Future getWeatherDataByCity(String city) async {
    return await http.get(
        Uri.parse("https://api.collectapi.com/pray/all?data.city=istanbul"),
        headers: {
          HttpHeaders.authorizationHeader:
              'apikey 32j9cWNjp8LvgdHuJHCqEA:26Q3GYJNV8MH0S0BKU2yT8',
          HttpHeaders.contentTypeHeader: 'application/json'
        });
  }
}
