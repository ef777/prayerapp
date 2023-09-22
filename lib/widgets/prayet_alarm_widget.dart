import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class PrayerAlarmWidget extends StatefulWidget {
  PrayerAlarmWidget({
    Key? key,
    required this.fajrSwitch,
    required this.arsSwitch,
    required this.dhuhrSwitch,
    required this.maghrebSwitch,
    required this.ishaSwitch,
    required this.ishaTime,
  }) : super(key: key);
  final String ishaTime;
  final bool fajrSwitch;
  final bool arsSwitch;
  final bool dhuhrSwitch;
  final bool maghrebSwitch;
  bool ishaSwitch;

  @override
  State<PrayerAlarmWidget> createState() => _PrayerAlarmWidgetState();
}

var min;
var hours;

class _PrayerAlarmWidgetState extends State<PrayerAlarmWidget> {
  @override
  void initState() {
    var parsedTime = DateFormat('HH:mm').parse(widget.ishaTime);
    parsedTime = parsedTime.subtract(Duration(seconds: 30));
    min = parsedTime.minute;
    hours = parsedTime.hour;
    print(parsedTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            "Namaz Hatırlatıcı Oluştur",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            widget.fajrSwitch.toString(),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: 16,
          ),
          PrayerAlarms(
            image: "assets/fajrIcon.svg",
            title: 'main.fajr'.tr() + " " + 'main.prayer'.tr(),
            isSwitch: widget.fajrSwitch,
          ),
          PrayerAlarms(
            image: "assets/arsIcon.svg",
            title: 'main.ars'.tr() + " " + 'main.prayer'.tr(),
            isSwitch: widget.arsSwitch,
          ),
          PrayerAlarms(
            image: "assets/dhuhrIcon.svg",
            title: 'main.dhuhr'.tr() + " " + 'main.prayer'.tr(),
            isSwitch: widget.dhuhrSwitch,
          ),
          PrayerAlarms(
            image: "assets/maghrebIcon.svg",
            title: 'main.maghreb'.tr() + " " + 'main.prayer'.tr(),
            isSwitch: widget.maghrebSwitch,
          ),

          // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //   SvgPicture.asset("assets/ıshaIcon.svg"),
          //   SizedBox(
          //     width: 12,
          //   ),
          //   Text(
          //     " assets/ıshaIcon.svg",
          //     style: Theme.of(context)
          //         .textTheme
          //         .headlineSmall
          //         ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          //   ),
          //   Spacer(),
          //   CupertinoSwitch(
          //     activeColor: const Color.fromRGBO(146, 164, 222, 1),
          //     value: widget.ishaSwitch,
          //     onChanged: (newValue) => setState(() {
          //       widget.ishaSwitch = newValue;
          //       if (newValue) {
          //         NotificationService()
          //             .showNotification(id: 7, min: min, hours: hours);
          //         print("kuruldu");
          //       } else {
          //         NotificationService().cancelNotification(7);
          //         print("iptal edildi");
          //       }
          //     }),
          //   ),
          // ])
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PrayerAlarms extends StatefulWidget {
  PrayerAlarms({
    Key? key,
    required this.title,
    required this.image,
    required this.isSwitch,
    this.fn,
  }) : super(key: key);
  final String title;
  final String image;
  bool isSwitch;
  final void Function()? fn;
  @override
  State<PrayerAlarms> createState() => _PrayerAlarmsState();
}

class _PrayerAlarmsState extends State<PrayerAlarms> {
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
        value: widget.isSwitch,
        onChanged: (newValue) => setState(() {
          widget.isSwitch = newValue;
        }),
      ),
    ]);
  }
}
