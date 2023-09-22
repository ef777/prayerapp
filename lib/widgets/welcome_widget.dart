import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:namazvakitleri/loading_indicator.dart';
import 'package:namazvakitleri/model/prayet_times_model_3.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    Key? key,
    required this.time,
    required this.nextPrayer,
    this.future,
    this.formattedDate,
  }) : super(key: key);
  final String time;
  final dynamic nextPrayer;
  final Future<PrayerTimesModel3>? future;
  final dynamic formattedDate;
  @override
  Future<PrayerTimesModel3> fetchData2() async {
    var position = await getLocation();
    var lat = position.latitude;
    var lon = position.longitude;
    var url =
        "https://namaz-vakti.vercel.app/api/timesFromCoordinates?lat=$lat&lng=$lon&date=$formattedDate&days=1&timezoneOffset=180";
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return PrayerTimesModel3.fromJson(
          jsonDecode(response.body), formattedDate);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {}
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 14, 31, 216).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(
            "assets/mosque1.jpg",
          ),
          fit: BoxFit.fill,
        ),
      ),
      height: 182,
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 350.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Assalamu Aleikum",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              FutureBuilder<PrayerTimesModel3>(
                future: fetchData2(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "Namaza Kalan Süre : " + nextPrayer.toString(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Color.fromARGB(255, 217, 216, 216),
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
