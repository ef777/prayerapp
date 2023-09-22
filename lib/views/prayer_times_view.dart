// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/views/settings_view.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;

import 'package:namazvakitleri/service/notifi_service.dart';
import 'package:namazvakitleri/widgets/prayer_times_container.dart';

import '../model/prayet_times_model_3.dart';
import 'alarm_view.dart';
import 'buyying_view/buying_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool visi = true;
String login = "0";

class PrayerTimesView extends StatefulWidget {
  const PrayerTimesView({key});

  @override
  State<PrayerTimesView> createState() => _PrayerTimesViewState();
}

class _PrayerTimesViewState extends State<PrayerTimesView> {
  bool switch1Value = false;
  bool switch2Value = false;
  bool switch3Value = false;
  bool switch4Value = false;
  bool switch5Value = false;
  bool switch6Value = true;

  late SharedPreferences prefs;
  StreamSubscription? internetconnection;
  bool isoffline = false;
  // Date nesnesi oluşturma
  void checkInternet() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });
  }

/*   BannerAd? _anchoredAdaptiveAd;
 */
  bool _isLoaded = false;
  var internetKontrol;
// Tarih bilgilerini yazdırma
  var fajrTime;
  var asrTime;
  var maghTime;
  var dhuhTime;
  var ishaTime;
  //late List<Times?> tesr222;
  var nextPrayer;
  var nextPrayer2;
  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  var prayerDate = DateFormat('HH:mm').format(DateTime.now());
  late String formattedDate;
  late Timer timer;
  var lat;
  var lon;

  RewardedAd? _rewardedAd;

  Future<PrayerTimesModel3>? future;
  bool _showDialog = true;
  var _format = HijriCalendar.now();
  Future<void> checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showDialog = prefs.getBool('showDialog') ?? true;
    setState(() {
      _showDialog = showDialog;
    });
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDialog', false);
  }

  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  // bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
/*     _loadAd();
 */
  }
/* 
  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace these test ad units with your own ad unit.
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4477240702665629/6792395591'
          : 'ca-app-pub-5179056129905268/3407985675',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }
/*  */
  BannerAd bannerReklam(AdSize size) {
    return BannerAd(
      // TODO: replace this test ad unit with your own ad unit.
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5179056129905268/1367261213'
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
  } */

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
/*   BannerAd? _bannerAd;
 */
  void initState() {
    _loadData();
    /*   
    BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5179056129905268/1367261213'
          : 'ca-app-pub-5179056129905268/3407985675',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load(); */
    checkIfFirstTime().then((value) {
      if (_showDialog) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog2());
      } else {
        print("oddd");
      }
    });

    getLocation().then(
      (value) {
        print(value.latitude);
      },
    );
    checkInternet(); // using
    future = fetchData();
    formattedDate = getDate();
    _screenTimer();

    loadSharedPreferences();

    super.initState();
  }

  List<DateTime?> namazTime = [];
  // SharedPreferences nesnesini yükleme
  void loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      // SharedPreferences'den switch değerlerini yükleme
      switch1Value = prefs.getBool('switch1') ?? false;
      switch2Value = prefs.getBool('switch2') ?? false;
      switch3Value = prefs.getBool('switch3') ?? false;
      switch4Value = prefs.getBool('switch4') ?? false;
      switch5Value = prefs.getBool('switch5') ?? false;
      switch6Value = prefs.getBool('switch6') ?? false;
    });
    await fetchData();
    if (switch6Value) {
      if (switch1Value) {
        fajrTime = fajrTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleSabah'.tr(),
            body: 'main.bodySabah45'.tr(),
            id: int.parse("99"),
            min: fajrTime.minute,
            hours: fajrTime.hour);
      }
      if (switch2Value) {
        dhuhTime = dhuhTime.subtract(Duration(minutes: 45));
        print("kemal bu" + dhuhTime.toString());
        NotificationService().showNotification(
            title: 'main.titleOgle'.tr(),
            body: 'main.bodyOglen45'.tr(),
            id: int.parse("98"),
            min: dhuhTime.minute,
            hours: dhuhTime.hour);
      }
      if (switch3Value) {
        asrTime = asrTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleIk'.tr(),
            body: 'main.bodyIk45'.tr(),
            id: int.parse("97"),
            min: asrTime.minute,
            hours: asrTime.hour);
      }
      if (switch4Value) {
        maghTime = maghTime.subtract(Duration(minutes: 45));

        NotificationService().showNotification(
            title: 'main.titleAksam'.tr(),
            body: 'main.bodyAksam45'.tr(),
            id: int.parse("96"),
            min: maghTime.minute,
            hours: maghTime.hour);
      }
      if (switch5Value) {
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
    await prefs.setBool('switch1', switch1Value);
    await prefs.setBool('switch2', switch2Value);
    await prefs.setBool('switch3', switch3Value);
    await prefs.setBool('switch4', switch4Value);
    await prefs.setBool('switch5', switch5Value);
    await prefs.setBool('switch6', switch6Value);
  }

  void savePrayerTimes(String imsak, sabah, ogle, ikindin, aksam, yatsi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imsak', imsak);
    await prefs.setString('sabah', sabah);
    await prefs.setString('ogle', ogle);
    await prefs.setString('ikindin', ikindin);
    await prefs.setString('aksam', aksam);
    await prefs.setString('yatsi', yatsi);
  }

  void _screenTimer() {
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var perviousMinute = DateTime.now().add(Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (perviousMinute != currentMinute)
        setState(() {
          formattedTime = DateFormat('HH:mm').format(DateTime.now());
        });
    });
  }

  void dispose() {
    _rewardedAd?.dispose();
    internetconnection!.cancel();
    timer.cancel(); // Timer'ı iptal edin
    super.dispose();
  }

  _loadData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      namazTime.add(DateTime.parse(prefs.getString('imsak') ?? ''));
      namazTime.add(DateTime.parse(prefs.getString('sabah') ?? ''));
      namazTime.add(DateTime.parse(prefs.getString('ogle') ?? ''));
      namazTime.add(DateTime.parse(prefs.getString('ikindin') ?? ''));
      namazTime.add(DateTime.parse(prefs.getString('aksam') ?? ''));
      namazTime.add(DateTime.parse(prefs.getString('yatsi') ?? ''));

      // namazTime[0] = DateTime.parse(prefs.getString('imsak') ?? '');
      // namazTime[1] = DateTime.parse(prefs.getString('sabah') ?? '');
      // namazTime[2] = DateTime.parse(prefs.getString('ogle') ?? '');
      // namazTime[3] = DateTime.parse(prefs.getString('ikindin') ?? '');
      // namazTime[4] = DateTime.parse(prefs.getString('aksam') ?? '');
      // namazTime[5] = DateTime.parse(prefs.getString('yatsi') ?? '');

      // login = prefs.getString('login') ?? '';
      // id = prefs.getString('id') ?? '';
    });
    print(namazTime);
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
      ishaTime = times[5];
      asrTime = times[3];
      maghTime = times[4];
      print("baaakkk");

      print(times[0]);
      savePrayerTimes(
        times[0].toString(),
        times[1].toString(),
        times[2].toString(),
        times[3].toString(),
        times[4].toString(),
        times[5].toString(),
      );
      if (switch6Value) {
        print("alamr Kuruldu");
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
      print("Şimdiki namaz vakti :" + nextPrayer.toString());
      nextPrayer2 = nextPrayer.difference(now);
      namazTime.add(fajrTime);
      namazTime.add(dhuhTime);
      namazTime.add(asrTime);
      namazTime.add(maghTime);
      namazTime.add(ishaTime);
      internetKontrol =
          PrayerTimesModel3.fromJson(jsonDecode(response.body), formattedDate);
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

  PageController _pageController = PageController();
  void _showDialog2() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
          height: 360,
          width: 200,
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16)),
                              color: Color.fromRGBO(27, 41, 86, 1),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  "Uygulamayı reklamsız deneyin",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Image.asset(
                                  "assets/ads_not3.png",
                                  fit: BoxFit.cover,
                                  height: 100,
                                )
                              ],
                            )),
                      ],
                    ),
                    Positioned(
                      top: 90,
                      left: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ),
                    Positioned(
                      top: 90,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Uygulama da premiuma geçerek reklamları kaldırabilirsin ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
              // Text(
              //     "Uygulama da premiuma geçerek reklamları geçebilir ve widget özelliğine sahip olabilirsin")
              ,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        onPressed: () {
                          savePreferences();
                          Navigator.pop(context);
                        },
                        child: Text("İptal")),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuyyingView()));
                        },
                        child: Text("Premium Ol")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
    var now = DateTime.now();

    // Yerel ayarları al
    var locale = Localizations.localeOf(context);

    // Yerel tarihi biçimlendirme
    var formatter = DateFormat.yMMMMd(locale.toString());
    String formattedDate = formatter.format(now);
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Column(
            children: [
              Text(
                formattedDate,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                _format.hDay.toString() +
                    " " +
                    _format.longMonthName +
                    " " +
                    _format.hYear.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                    ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BuyyingView())),
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 39, 50, 173).withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Color.fromARGB(255, 8, 31, 108),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'main.get_premium_now'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 52),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            ListView(
              children: [
                FutureBuilder<PrayerTimesModel3>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DateTime> times = snapshot.data!.times!.l20230312!
                          .map((timeString) =>
                              DateTime.parse('2022-03-10 $timeString'))
                          .toList();
                      times.sort((b, a) => b.compareTo(a));
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            welcomeWidget(context),
                            const SizedBox(
                              height: 16,
                            ),
                            prayerTimesContainer(context, times),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ErrorWidget2(context);
                    } else {
                      return SizedBox(
                          width: 400,
                          height: 400,
                          child: Center(child: CircularProgressIndicator()));
                    }
                  },
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                //   child: WelcomeWidget(
                //     future: fetchData(),
                //     formattedDate: formattedDate,
                //     nextPrayer: (nextPrayer2 ?? now),
                //     time: formattedTime.toString(),
                //   ),
                // ),

                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                //   child: Center(
                //     child: PrayerTodaysTimesContainer(
                //       switch1Value: switch1Value,
                //       switch2Value: switch2Value,
                //       switch3Value: switch3Value,
                //       switch4Value: switch4Value,
                //       switch5Value: switch5Value,
                //       prayers: fetchData(),
                //     ),
                //   ),
                // ),
              ],
            ),
            /*  if (_anchoredAdaptiveAd != null && _isLoaded)
              Container(
                color: Colors.white,
                width: _anchoredAdaptiveAd!.size.width.toDouble(),
                height: _anchoredAdaptiveAd!.size.height.toDouble(),
                child: AdWidget(ad: _anchoredAdaptiveAd!),
              ) */
          ],
        ),
      ),
    );
  }

  Padding ErrorWidget2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          errmsg("İnternet Bağlantınızı kontrol edin", true),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 14, 31, 216).withOpacity(0.2),
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
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Assalamu Aleikum",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      formattedTime,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minWidth: 350.0,
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'main.prayer_times_title'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Color.fromARGB(26, 42, 49, 153),
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(Icons.settings_suggest_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingsView(
                                          switchValue6: switch6Value,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Color.fromARGB(26, 42, 49, 153),
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(Icons.notifications_on_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AlarmView(
                                            switch6Value: switch6Value,
                                            switch1Value: switch1Value,
                                            switch2Value: switch2Value,
                                            switch3Value: switch3Value,
                                            switch4Value: switch4Value,
                                            switch5Value: switch5Value,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          PrayerTimes(
                            iconTitle: "assets/fajrIcon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[0] ?? DateTime.now(),
                            title: 'main.fajr'.tr(),
                          ),
                          const Divider(
                            height: 7,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          PrayerTimes(
                            iconTitle: "assets/fajrIcon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[1] ?? DateTime.now(),
                            title: 'main.sun'.tr(),
                          ),
                          const Divider(
                            height: 7,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          PrayerTimes(
                            iconTitle: "assets/dhuhrIcon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[2] ?? DateTime.now(),
                            title: 'main.dhuhr'.tr(),
                          ),
                          const Divider(
                            height: 7,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          PrayerTimes(
                            iconTitle: "assets/arsIcon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[3] ?? DateTime.now(),
                            title: 'main.ars'.tr(),
                          ),
                          const Divider(
                            height: 7,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          PrayerTimes(
                            iconTitle: "assets/maghrebIcon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[4] ?? DateTime.now(),
                            title: 'main.maghreb'.tr(),
                          ),
                          const Divider(
                            height: 7,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          PrayerTimes(
                            iconTitle: "assets/ishaicon.svg",
                            times: namazTime.isEmpty
                                ? DateTime.now()
                                : namazTime[5] ?? DateTime.now(),
                            title: 'main.isha'.tr(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container prayerTimesContainer(BuildContext context, List<DateTime> times) {
    return Container(
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: 350.0,
        ),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'main.prayer_times_title'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Color.fromARGB(26, 42, 49, 153),
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(Icons.settings_suggest_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsView(
                                    switchValue6: switch6Value,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Color.fromARGB(26, 42, 49, 153),
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(Icons.notifications_on_outlined),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlarmView(
                                      switch6Value: switch6Value,
                                      switch1Value: switch1Value,
                                      switch2Value: switch2Value,
                                      switch3Value: switch3Value,
                                      switch4Value: switch4Value,
                                      switch5Value: switch5Value,
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    PrayerTimes(
                      iconTitle: "assets/fajrIcon.svg",
                      times: times[0],
                      title: 'main.fajr'.tr(),
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    PrayerTimes(
                      iconTitle: "assets/fajrIcon.svg",
                      times: times[1],
                      title: 'main.sun'.tr(),
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    PrayerTimes(
                      iconTitle: "assets/dhuhrIcon.svg",
                      times: times[2],
                      title: 'main.dhuhr'.tr(),
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    PrayerTimes(
                      iconTitle: "assets/arsIcon.svg",
                      times: times[3],
                      title: 'main.ars'.tr(),
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    PrayerTimes(
                      iconTitle: "assets/maghrebIcon.svg",
                      times: times[4],
                      title: 'main.maghreb'.tr(),
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    PrayerTimes(
                      iconTitle: "assets/ishaicon.svg",
                      times: times[5],
                      title: 'main.isha'.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container welcomeWidget(BuildContext context) {
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
              const SizedBox(
                height: 8,
              ),
              Text(
                "Assalamu Aleikum",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                formattedTime,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              Text(
                "Namaza Kalan Süre : " +
                    nextPrayer2.inHours.toString() +
                    ":" +
                    nextPrayer2.inMinutes.remainder(60).toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Color.fromARGB(255, 217, 216, 216),
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget errmsg(String text, bool show) {
    //error message widget.
    if (show == true) {
      //if error is true then show error message box
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(10.00),
          margin: EdgeInsets.only(bottom: 10.00),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 222, 20, 5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Container(
              margin: EdgeInsets.only(right: 6.00),
              child: Icon(Icons.info, color: Colors.white),
            ), // icon for error message

            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white)),
            //show error message text
          ]),
        ),
      );
    } else {
      return Container();
      //if error is false, return empty container.
    }
  }
}

class AlarmCrate extends StatefulWidget {
  AlarmCrate(
      {key,
      required this.valueDe,
      this.onChanged,
      required this.title,
      required this.image});
  bool valueDe;
  final String title, image;
  final void Function(bool)? onChanged;
  @override
  State<AlarmCrate> createState() => _AlarmCrateState();
}

class _AlarmCrateState extends State<AlarmCrate> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SvgPicture.asset(widget.image),
      SizedBox(
        width: 12,
      ),
      Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      Spacer(),
      CupertinoSwitch(
          activeColor: const Color.fromRGBO(146, 164, 222, 1),
          value: widget.valueDe,
          onChanged: widget.onChanged),
    ]);
  }
}

class SwitchValue with ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  set value(bool newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class AlarmCenter extends StatelessWidget {
  AlarmCenter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 80,
      width: 300,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 14, 31, 216).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          color: Color.fromARGB(255, 245, 162, 9),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Namaz vakitleri için hatırlacı oluşturabilir ve 45 dakika önce bildirim alabilirsiniz',
              style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(width: 10), // Some space between Text and Icon
          Container(
            width: 24,
            height: 24,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              FontAwesomeIcons.hourglassEnd,
              size: 16,
              color: Colors.amber,
            ),
          )
        ],
      ),
    );
  }
}
