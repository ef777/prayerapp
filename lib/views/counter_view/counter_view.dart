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

class CounterView extends StatefulWidget {
  const CounterView({key, this.counterModel});
  final CounterModel? counterModel;
  @override
  State<CounterView> createState() => _CounterViewState();
}

int counterText = 0;
BannerAd? _anchoredAdaptiveAd;
bool _isLoaded = false;

class _CounterViewState extends State<CounterView> {
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

/*   double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);
 */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
/*     _loadAd();
 */
  }

  /*  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

   /*  _anchoredAdaptiveAd = BannerAd(
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
 */
/*   BannerAd? _bannerAd;
 */   */

  void initState() {
    counterText = int.parse(widget.counterModel?.start ?? "0");
    endPoint = int.parse(widget.counterModel?.finish ?? "99999");
    /* BannerAd(
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
    _createInterstitialAd(); /*  
    Future.delayed(Duration(seconds: 6), () {
      _showInterstitialAd();
    }); */
    super.initState();
  }

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
  } /*
 
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

  void _showInterstitialAd2() {
    if (_isInterstitialAdReady) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {},
      );
      _interstitialAd!.show();
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  @override
  void dispose() {
    _interstitialAd!.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  var endPoint;
  void incrementCounter() {
    counterText++; // sayaç değişkenini arttır
    if (counterText == endPoint) {
      Vibration.vibrate();

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Belirlediğiniz durağa geldiniz',
          confirmBtnText: "Tamam");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CounterListView())),
              ),
            ),
          ),
          leadingWidth: 64,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    _showInterstitialAd2();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCounter(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          title: Text(
            'main.dhikrmatic'.tr(),
          )),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            ListView(
              children: [
                Center(
                  child: Text(
                    widget.counterModel?.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 245, 244, 244),
                      ),
                      onPressed: () {
                        _showInterstitialAd2();
                        QuickAlert.show(
                          title: 'Durak Ekle',
                          context: context,
                          type: QuickAlertType.custom,
                          barrierDismissible: true,
                          confirmBtnText: 'Kaydet',
                          customAsset: 'assets/mosque1.jpg',
                          widget: TextFormField(
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: 'Lütfen bir durak belirleyiniz',
                                hintStyle: Theme.of(context).textTheme.caption,
                                prefixIcon:
                                    Icon(FontAwesomeIcons.penNib, size: 16),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  endPoint = int.parse(value)),
                          onConfirmBtnTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            await QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: "Durak Eklendi",
                                confirmBtnText: "Tamam");
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Text(
                        "Durak Ekle",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                ),
                Container(
                  height: 400,
                  width: 360,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/zikirmatik.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 104,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 180,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 129, 129, 127),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  counterText.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                          ),
                          ButtonContainer(
                              onPressed: () => setState(() {
                                    if (counterText == 0) return;
                                    counterText--;
                                  }),
                              icon: Icon(
                                Icons.refresh,
                              )),
                          Spacer(),
                          ButtonContainer(
                              onPressed: () => setState(() {
                                    counterText = 0;
                                  }),
                              icon: Icon(
                                Icons.rotate_left_sharp,
                              )),
                          SizedBox(
                            width: 90,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () => setState(() {
                            incrementCounter();
                            DatabaseHelper.instance.update(
                                widget.counterModel?.id ?? 0,
                                counterText.toString());
                          }),
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                color: Color.fromARGB(255, 210, 210, 209),
                                shape: BoxShape.circle),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (_anchoredAdaptiveAd != null && _isLoaded)
              Container(
                color: Colors.white,
                width: _anchoredAdaptiveAd!.size.width.toDouble(),
                height: _anchoredAdaptiveAd!.size.height.toDouble(),
                child: AdWidget(ad: _anchoredAdaptiveAd!),
              )
          ],
        ),
      ),
    );
  }
}

class ButtonContainer extends StatefulWidget {
  const ButtonContainer({key, required this.icon, this.onPressed});
  final Icon icon;
  final void Function()? onPressed;
  @override
  State<ButtonContainer> createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 204, 203, 203).withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ], color: Color.fromARGB(255, 226, 224, 222), shape: BoxShape.circle),
      child: IconButton(onPressed: widget.onPressed, icon: widget.icon),
    );
  }
}
