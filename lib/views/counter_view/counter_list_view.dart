import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../databases.dart';
import '../../main.dart';
import '../../model/counter_model.dart';

class CounterListView extends StatefulWidget {
  const CounterListView({key});

  @override
  State<CounterListView> createState() => _CounterListViewState();
}

class _CounterListViewState extends State<CounterListView> {
  @override
  List<CounterModel> _people = [];
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

  @override
  void initState() {
    _queryPeople();

    super.initState();
    // AdMob hesap kimliğinizi buraya ekleyin.
  }

  Future<void> _queryPeople() async {
    final people = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _people = people;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _people.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget(
                      finish: _people[index].finish,
                      title: _people[index].title,
                      start: _people[index].start,
                      counterModel: _people[index],
                      onPressed: () => setState(() {
                        DatabaseHelper.instance.delete(_people[index].id ?? 0);
                        _queryPeople();
                      }),
                    );
                  },
                ),
              ),
              _getAdWidget()
              // Container(
              //   width: _bannerAd!.size.width.toDouble(),
              //   height: 128,
              //   child: AdWidget(ad: _bannerAd!),
              // ),
            ],
          ),
        ));
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      elevation: 8,
      backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 175, 39, 39),
          ),
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.xmark,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      leadingWidth: 64,
      title: Text(
        'main.my_list_dhikrmatic'.tr(),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({
    Key? key,
    required this.title,
    required this.finish,
    required this.start,
    required this.counterModel,
    this.onPressed,
  }) : super(key: key);
  final String title;
  final String finish;
  final String start;
  final void Function()? onPressed;
  final CounterModel counterModel;

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    var deger = (
        // ignore: unnecessary_null_comparison
        (int.parse(widget.start != null ? widget.start : '0') * 100) /
            int.parse(widget.finish != null ? widget.finish : '0'));
    return TextButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBarView(
                    counterModel: widget.counterModel,
                    selected: 2,
                  ))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 105,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 14, 31, 216).withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            color: Color.fromRGBO(27, 41, 86, 1),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'main.target'.tr() + " : " + widget.finish,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Color.fromARGB(255, 203, 200, 200), fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                Center(
                  child: CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    percent: 0.240,
                    center: new Text(
                      // ignore: unnecessary_null_comparison
                      (
                              // ignore: unnecessary_null_comparison
                              (int.parse(widget.start != null
                                          ? widget.start
                                          : '0') *
                                      100) /
                                  int.parse(widget.finish != null
                                      ? widget.finish
                                      : '0'))
                          .toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    progressColor: Color.fromARGB(255, 249, 249, 249),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 175, 39, 39),
                  ),
                  child: Center(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.xmark,
                          color: Colors.white,
                        ),
                        onPressed: widget.onPressed),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
