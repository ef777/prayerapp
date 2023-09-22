// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:namazvakitleri/views/prayer_times_view.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../model/prayet_times_model_3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/notifi_service.dart';

bool asc = false;

// ignore: must_be_immutable
class AlarmView extends StatefulWidget {
  AlarmView(
      {key,
      required this.switch1Value,
      required this.switch2Value,
      required this.switch3Value,
      required this.switch4Value,
      required this.switch5Value,
      required this.switch6Value});
  bool switch1Value;
  bool switch2Value;
  bool switch3Value;
  bool switch4Value;
  bool switch5Value;
  bool switch6Value;

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  late Future<PrayerTimesModel3> prayers2;

  late SharedPreferences prefs;

  // Date nesnesi oluşturma

// Tarih bilgilerini yazdırma
  var fajrTime;
  var asrTime;
  var maghTime;
  var dhuhTime;
  var ishaTime;
  //late List<Times?> tesr222;
  var nextPrayer;
  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  var prayerDate = DateFormat('HH:mm').format(DateTime.now());
  late String formattedDate;

  var lat;
  var lon;

  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });

    // Get an inline adaptive size for the current orientation.
    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate());

    _inlineAdaptiveAd = bannerReklam(size);
    await _inlineAdaptiveAd!.load();
  }

  BannerAd bannerReklam(AdSize size) {
    return BannerAd(
      // TODO: replace this test ad unit with your own ad unit.
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4477240702665629/6792395591'
          : 'ca-app-pub-5179056129905268/3407985675',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          print('Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            print('Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAdaptiveAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
              child: Container(
            width: _adWidth,
            height: _adSize!.height.toDouble(),
            child: AdWidget(
              ad: _inlineAdaptiveAd!,
            ),
          ));
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  void initState() {
    fetchData();
    formattedDate = getDate();

    loadSharedPreferences();

    super.initState();
  }

  // SharedPreferences nesnesini yükleme
  void loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      // SharedPreferences'den switch değerlerini yükleme
      widget.switch1Value = prefs.getBool('switch1') ?? false;
      widget.switch2Value = prefs.getBool('switch2') ?? false;
      widget.switch3Value = prefs.getBool('switch3') ?? false;
      widget.switch4Value = prefs.getBool('switch4') ?? false;
      widget.switch5Value = prefs.getBool('switch5') ?? false;
      widget.switch6Value = prefs.getBool('switch6') ?? false;
    });
    await fetchData();

    if (widget.switch6Value) {
      if (widget.switch1Value) {
        fajrTime = fajrTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleSabah'.tr(),
            body: 'main.bodySabah45'.tr(),
            id: int.parse("99"),
            min: fajrTime.minute,
            hours: fajrTime.hour);
      }
      if (widget.switch2Value) {
        dhuhTime = dhuhTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleOgle'.tr(),
            body: 'main.bodyOglen45'.tr(),
            id: int.parse("98"),
            min: dhuhTime.minute,
            hours: dhuhTime.hour);
      }
      if (widget.switch3Value) {
        asrTime = asrTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleIk'.tr(),
            body: 'main.bodyIk45'.tr(),
            id: int.parse("97"),
            min: asrTime.minute,
            hours: asrTime.hour);
      }
      if (widget.switch4Value) {
        maghTime = maghTime.subtract(Duration(minutes: 45));
        print("kuruldu loooooooo");
        NotificationService().showNotification(
            title: 'main.titleAksam'.tr(),
            body: 'main.bodyAksam45'.tr(),
            id: int.parse("96"),
            min: maghTime.minute,
            hours: maghTime.hour);
      }
      if (widget.switch5Value) {
        ishaTime = ishaTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleYatsı'.tr(),
            body: 'main.bodyYatsı45'.tr(),
            id: int.parse("95  "),
            min: ishaTime.minute,
            hours: ishaTime.hour);
      }
    } else {
      NotificationService().cancelAllNotifications();
      print("bildirimler kapatıldı");
    }
  }

  // SharedPreferences'ye switch değerlerini kaydetme
  void saveSharedPreferences() async {
    await prefs.setBool('switch1', widget.switch1Value);
    await prefs.setBool('switch2', widget.switch2Value);
    await prefs.setBool('switch3', widget.switch3Value);
    await prefs.setBool('switch4', widget.switch4Value);
    await prefs.setBool('switch5', widget.switch5Value);
    await prefs.setBool('switch6', widget.switch6Value);
  }

  void dispose() {
    super.dispose();
  }

  Future<PrayerTimesModel3> fetchData() async {
    var position = await getLocation();
    var lat = position.latitude;
    var lon = position.longitude;
    var url =
        "https://namaz-vakti.vercel.app/api/timesFromCoordinates?lat=$lat&lng=$lon&date=$formattedDate&days=1&timezoneOffset=180";
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var timeFree = await PrayerTimesModel3.fromJson(
          jsonDecode(response.body), formattedDate);
      List<DateTime> times = timeFree.times!.l20230312!
          .map((timeString) => DateTime.parse('$formattedDate $timeString'))
          .toList();
      times.sort((b, a) => b.compareTo(a));
      fajrTime = times[1];
      dhuhTime = times[2];
      asrTime = times[3];
      maghTime = times[4];
      ishaTime = times[5];

      if (widget.switch6Value) {
        NotificationService().showNotification(
          id: 1,
          min: fajrTime.minute,
          hours: fajrTime.hour,
          title: 'main.titleSabah'.tr(),
          body: 'main.bodySabah'.tr(),
        );
        NotificationService().showNotification(
          id: 2,
          min: dhuhTime.minute,
          hours: dhuhTime.hour,
          title: 'main.titleOgle'.tr(),
          body: 'main.bodyOglen'.tr(),
        );
        NotificationService().showNotification(
          id: 3,
          min: asrTime.minute,
          hours: asrTime.hour,
          title: 'main.titleIk'.tr(),
          body: 'main.bodyIk'.tr(),
        );
        NotificationService().showNotification(
          id: 4,
          min: maghTime.minute,
          hours: maghTime.hour,
          title: 'main.titleAksam'.tr(),
          body: 'main.bodyAksam'.tr(),
        );
        NotificationService().showNotification(
          id: 5,
          min: ishaTime.minute,
          hours: ishaTime.hour,
          title: 'main.titleYatsı'.tr(),
          body: 'main.bodyYatsı'.tr(),
        );
        print("kuruldu");
      } else {
        NotificationService().cancelAllNotifications();
        print("bildirimler kapatıldı");
      }
      DateTime now = DateTime.now();

      if (now.isBefore(fajrTime)) {
        nextPrayer = fajrTime;
      } else if (now.isBefore(dhuhTime)) {
        nextPrayer = dhuhTime;
      } else if (now.isBefore(asrTime)) {
        nextPrayer = asrTime;
      } else if (now.isBefore(maghTime)) {
        nextPrayer = maghTime;
      } else if (now.isBefore(ishaTime)) {
        nextPrayer = ishaTime;
      } else {
        nextPrayer = fajrTime.add(Duration(days: 1));
      }
      print(nextPrayer);
      return PrayerTimesModel3.fromJson(
          jsonDecode(response.body), formattedDate);
    } else {
      throw Exception('Failed to load album');
    }
  }

  String getDate() {
    DateTime date = DateTime.now(); // Tarihi oluştur
    String formattedDate = DateFormat('yyyy-MM-dd').format(date); // Biçimlendir
    print(formattedDate);
    formattedDate = formattedDate.toString();
    return formattedDate;
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

  @override
  Widget build(BuildContext context) {
    // Yerel tarihi biçimlendirme
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 72),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: AlarmCenter(),
            ),
            AlarmContainer(context),
          ],
        ),
      ),
    );
  }

  Padding AlarmContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'main.notCreate'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              title:
                                  'Namaz Hatırlatıcısı oluşturarak ezandan 45 dakika önce bildirim alabilirsiniz..',
                              confirmBtnText: "Tamam");
                        },
                        icon: Icon(Icons.info_outline_rounded))
                  ],
                ),

                FutureBuilder<PrayerTimesModel3>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DateTime> times = snapshot.data!.times!.l20230312!
                          .map((timeString) =>
                              DateTime.parse('2022-03-10 $timeString'))
                          .toList();
                      times.sort((b, a) => b.compareTo(a));
                      return Column(
                        children: [
                          AlarmCrate(
                            title: 'main.fajr'.tr() + " " + 'main.prayer'.tr(),
                            image: "assets/fajrIcon.svg",
                            valueDe: widget.switch1Value,
                            onChanged: (value) {
                              if (value) {
                                fajrTime =
                                    times[1].subtract(Duration(minutes: 45));
                                print(fajrTime);
                                NotificationService().showNotification(
                                    title: 'main.titleSabah'.tr(),
                                    body: 'main.bodySabah45'.tr(),
                                    id: int.parse("99"),
                                    min: fajrTime.minute,
                                    hours: fajrTime.hour);
                              }
                              setState(() {
                                widget.switch1Value = value;
                              });
                              saveSharedPreferences();
                            },
                          ),
                          AlarmCrate(
                            image: "assets/dhuhrIcon.svg",
                            title: 'main.dhuhr'.tr() + " " + 'main.prayer'.tr(),
                            valueDe: widget.switch2Value,
                            onChanged: (value) {
                              dhuhTime =
                                  times[2].subtract(Duration(minutes: 45));

                              if (value) {
                                NotificationService().showNotification(
                                    title: 'main.titleOgle'.tr(),
                                    body: 'main.bodyOglen45'.tr(),
                                    id: int.parse("98"),
                                    min: dhuhTime.minute,
                                    hours: dhuhTime.hour);
                              }
                              setState(() {
                                widget.switch2Value = value;
                              });
                              saveSharedPreferences();
                            },
                          ),
                          AlarmCrate(
                            image: "assets/arsIcon.svg",
                            title: 'main.ars'.tr() + " " + 'main.prayer'.tr(),
                            valueDe: widget.switch3Value,
                            onChanged: (value) {
                              if (value) {
                                asrTime =
                                    times[3].subtract(Duration(minutes: 45));

                                NotificationService().showNotification(
                                    title: 'main.titleIk'.tr(),
                                    body: 'main.bodyIk45'.tr(),
                                    id: int.parse("97"),
                                    min: asrTime.minute,
                                    hours: asrTime.hour);
                              }
                              setState(() {
                                widget.switch3Value = value;
                              });
                              saveSharedPreferences();
                            },
                          ),
                          AlarmCrate(
                            image: "assets/maghrebIcon.svg",
                            title:
                                'main.maghreb'.tr() + " " + 'main.prayer'.tr(),
                            valueDe: widget.switch4Value,
                            onChanged: (value) {
                              if (value) {
                                maghTime =
                                    times[4].subtract(Duration(minutes: 45));

                                NotificationService().showNotification(
                                    title: 'main.titleAksam'.tr(),
                                    body: 'main.bodyAksam45'.tr(),
                                    id: int.parse("96"),
                                    min: maghTime.minute,
                                    hours: maghTime.hour);
                              }
                              setState(() {
                                widget.switch4Value = value;
                              });
                              saveSharedPreferences();
                            },
                          ),
                          AlarmCrate(
                            image: "assets/ishaicon.svg",
                            title: 'main.isha'.tr() + " " + 'main.prayer'.tr(),
                            valueDe: widget.switch5Value,
                            onChanged: (value) {
                              if (value) {
                                ishaTime =
                                    times[5].subtract(Duration(minutes: 45));
                                NotificationService().showNotification(
                                    title: 'main.titleYatsı'.tr(),
                                    body: 'main.bodyYatsı45'.tr(),
                                    id: int.parse("95"),
                                    min: ishaTime.minute,
                                    hours: ishaTime.hour);
                              }
                              setState(() {
                                widget.switch5Value = value;
                              });
                              saveSharedPreferences();
                            },
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                // fajrTime == null
                //     ? CircularProgressIndicator()
                //     : Column(
                //         children: [
                //           // AlarmCrate(
                //           //   title: 'main.fajr'.tr() + " " + 'main.prayer'.tr(),
                //           //   image: "assets/fajrIcon.svg",
                //           //   valueDe: widget.switch1Value,
                //           //   onChanged: (value) {
                //           //     if (value) {
                //           //       fajrTime =
                //           //           fajrTime.subtract(Duration(minutes: 45));

                //           //       NotificationService().showNotification(
                //           //           title: 'main.titleSabah'.tr(),
                //           //           body: 'main.bodySabah45'.tr(),
                //           //           id: int.parse("99"),
                //           //           min: fajrTime.minute,
                //           //           hours: fajrTime.hour);
                //           //     }
                //           //     setState(() {
                //           //       widget.switch1Value = value;
                //           //     });
                //           //     saveSharedPreferences();
                //           //   },
                //           //   ),
                //         ],
                //       )

                //if (_bannerAd != null)

                // Container(
                //   width: _bannerAd!.size.width.toDouble(),
                //   height: 300,
                //   child: AdWidget(ad: _bannerAd!),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _getAdWidget()
        ],
      ),
    );
  }
}
