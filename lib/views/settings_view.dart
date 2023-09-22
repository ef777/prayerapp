import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/widgets/buyying_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../service/notifi_service.dart';

// ignore: must_be_immutable
class SettingsView extends StatefulWidget {
  SettingsView({Key? key, required this.switchValue6}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
  bool switchValue6;
}

class _SettingsViewState extends State<SettingsView> {
  late SharedPreferences _prefs;

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
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.switchValue6 = _prefs.getBool('switch6') ?? false;
    });
  }

  void _savePrefs(bool value) {
    _prefs.setBool('switch6', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBarView(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Settings"),
        backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.notifications_none_sharp),
                SizedBox(
                  width: 6,
                ),
                Text(
                    "Bildirimleri Açarak Namaz Vakitlerinde \nHaber Alabilirsin"),
                Spacer(),
                CupertinoSwitch(
                  value: widget.switchValue6,
                  onChanged: (bool newValue) {
                    setState(() {
                      widget.switchValue6 = newValue;
                    });
                    if (!newValue) {
                      NotificationService().cancelAllNotifications();
                      print("bildirim kapatıldı");
                    }
                    _savePrefs(newValue);
                  },
                ),
              ],
            ),
            BuyyingWidget(),
            _getAdWidget()
          ],
        ),
      ),
    );
  }
}
