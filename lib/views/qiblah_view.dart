import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:namazvakitleri/loading_indicator.dart';
import 'package:namazvakitleri/views/qiblah_compass.dart';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/model/counter_model.dart';
import 'package:namazvakitleri/views/counter_view/add_counter.dart';
import 'package:namazvakitleri/views/counter_view/counter_list_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vibration/vibration.dart';
import '../../databases.dart';
import '../qiblah_maps.dart';

class QiblahView extends StatefulWidget {
  const QiblahView({key});

  @override
  State<QiblahView> createState() => _QiblahViewState();
}

final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

class _QiblahViewState extends State<QiblahView> {
  InterstitialAd? _interstitialAd;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;

  bool _isInterstitialAdReady = false;
  @override
  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;
  void initState() {
    super.initState();
  }

/* 
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5179056129905268/2735970206'
          : "ca-app-pub-5179056129905268/6439126082",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {},
      );
      _interstitialAd!.show();
      _createInterstitialAd();
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _deviceSupport,
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingIndicator();
        if (snapshot.hasError) {
          print("hata error");

          return Center(
            child: Text("Error: ${snapshot.error.toString()}"),
          );
        }
        if (snapshot.data == null)
          return Center(
            child: Text("Error: ${snapshot.error.toString()}"),
          );
        if (snapshot.hasData) {
          print("data geldi");
          print(snapshot.data.toString());
        }
        if (snapshot.data == true) {
          print("data" + snapshot.data.toString());
          print("kıble tamam");
          return QiblahCompass();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Desteklenmeyen Cihaz'),
                content: Text('Pusula Desteklenmiyor'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Tamam'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
          print("kıble hata");
          return QiblahMaps();
        }
      },
    );
  }
}

void showTopSnackBar(BuildContext context, Widget child) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold
      .showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: child,
        ),
      )
      .closed
      .then((reason) {
    if (reason != SnackBarClosedReason.action) {
      scaffold.hideCurrentSnackBar();
    }
  });
}
