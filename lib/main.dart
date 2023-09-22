import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:namazvakitleri/service/local_lang_service.dart';
import 'package:namazvakitleri/service/notifi_service.dart';
import 'package:namazvakitleri/views/counter_view/counter_view.dart';
import 'package:namazvakitleri/views/intro_view.dart';
import 'package:namazvakitleri/views/prayer_times_view.dart';
import 'package:namazvakitleri/views/qiblah_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:namazvakitleri/service/local_lang_service.dart';
import 'package:namazvakitleri/service/notifi_service.dart';
import 'package:namazvakitleri/views/counter_view/counter_view.dart';
import 'package:namazvakitleri/views/intro_view.dart';
import 'package:namazvakitleri/views/prayer_times_view.dart';
import 'package:namazvakitleri/views/qiblah_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'model/counter_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();
  MobileAds.instance.initialize();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seen = prefs.getBool('seen');
  Widget _screen;
  if (seen == null) {
    _screen = IntroView();
    await prefs.setBool('seen', true);
  } else {
    _screen = BottomBarView();
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: AppConstant.SUPPORTED_LOCALE,
    child: MyApp(_screen),
    path: AppConstant.LANG_PATH,
    fallbackLocale: AppConstant.TR_LOCALE,
  ));
}

class MyApp extends StatelessWidget {
  final Widget _screen;
  MyApp(this._screen);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Color.fromARGB(255, 255, 255, 255),
            filled: true,
            labelStyle: const TextStyle(
                fontSize: 14, color: Color.fromRGBO(179, 179, 179, 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    width: 2, color: Color.fromARGB(255, 255, 255, 255))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    width: 2, color: Color.fromARGB(255, 255, 255, 255))),
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(250, 251, 255, 1)),
      home: _screen,
    );
  }
}

class BottomBarView extends StatefulWidget {
  const BottomBarView({key, this.selected, this.counterModel});
  final int? selected;
  final CounterModel? counterModel;

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  late List<Widget> _widgetOptions;
  late int _selectedIndex;
  final _formKey = GlobalKey<FormState>();
  bool _isInterstitialAdReady = false;

  InterstitialAd? myInterstitial;
  DateTime? lastAdShow;
  /* Future.delayed(Duration(seconds: 5), () {
      _showInterstitialAd();
    }); */

  void initState() {
    _selectedIndex = widget.selected ?? 0;
    _widgetOptions = <Widget>[
      PrayerTimesView(),
      QiblahView(),
      CounterView(
        counterModel: widget.counterModel,
      )
    ];
    super.initState();

    lastAdShow = DateTime.now();
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5179056129905268/2735970206'
          : "ca-app-pub-5179056129905268/6439126082",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          myInterstitial = ad;
          _isInterstitialAdReady = true;
          print("geçişli reklam yüklendi");
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgImage.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: CustomNavigationBar(
              iconSize: 30.0,
              selectedColor: Color.fromARGB(255, 123, 128, 223),
              strokeColor: Color(0x300c18fb),
              unSelectedColor: Colors.grey[600],
              backgroundColor: Colors.white,
              borderRadius: Radius.circular(20.0),
              items: [
                CustomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.mosque,
                    size: 23,
                  ),
                ),
                CustomNavigationBarItem(
                    icon: Icon(
                  FontAwesomeIcons.compass,
                  size: 26,
                )),
                CustomNavigationBarItem(
                  icon: Icon(Icons.timer_sharp),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                final now = DateTime.now();
                if (myInterstitial != null &&
                    index != _selectedIndex &&
                    myInterstitial!.responseInfo != null &&
                    now.difference(lastAdShow!).inSeconds > 60) {
                  myInterstitial!.show();
                  if (_isInterstitialAdReady) {
                    myInterstitial!.fullScreenContentCallback =
                        FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (InterstitialAd ad) {},
                    );
                    myInterstitial!.show();
                  }
                  myInterstitial = null;
                  lastAdShow = now;
                  InterstitialAd.load(
                      adUnitId: Platform.isAndroid
                          ? 'ca-app-pub-5179056129905268/2735970206'
                          : "ca-app-pub-5179056129905268/6439126082",
                      request: AdRequest(),
                      adLoadCallback: InterstitialAdLoadCallback(
                          onAdLoaded: (InterstitialAd ad) {
                        myInterstitial = ad;
                        _isInterstitialAdReady = true;
                        print("geçişli reklam yüklendi");
                      }, onAdFailedToLoad: (LoadAdError error) {
                        print('InterstitialAd failed to load: $error');
                        _isInterstitialAdReady = false;
                      }));
                } else {
                  print("reklam uygun değil");
                }

                setState(() {
                  _selectedIndex = index;
                });
              },
              isFloating: true,
            ),
          ),
        )
      ],
    );
  }
}
