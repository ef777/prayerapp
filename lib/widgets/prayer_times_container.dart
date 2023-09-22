import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/prayet_times_model_3.dart';
import '../views/alarm_view.dart';

// ignore: must_be_immutable
class PrayerTodaysTimesContainer extends StatelessWidget {
  PrayerTodaysTimesContainer({
    Key? key,
    this.prayers,
    required this.switch1Value,
    required this.switch2Value,
    required this.switch3Value,
    required this.switch4Value,
    required this.switch5Value,
    required this.switch6Value,
  }) : super(key: key);
  final Future<PrayerTimesModel3>? prayers;
  bool switch1Value;
  bool switch2Value;
  bool switch3Value;
  bool switch4Value;
  bool switch5Value;
  bool switch6Value;

  @override
  Widget build(BuildContext context) {
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
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                FutureBuilder<PrayerTimesModel3>(
                  future: prayers,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("İnternet Bağlantısını Kontrol Ediniz");
                    }
                    if (snapshot.hasData) {
                      List<DateTime> times = snapshot.data!.times!.l20230312!
                          .map((timeString) =>
                              DateTime.parse('2022-03-10 $timeString'))
                          .toList();

                      times.sort((b, a) => b.compareTo(a));
                      return Column(
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
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({
    Key? key,
    required this.title,
    required this.times,
    required this.iconTitle,
  }) : super(key: key);
  final String title;
  final DateTime times;
  final String iconTitle;
  @override
  Widget build(BuildContext context) {
    var formattedTime = (DateTime.now());
    TimeOfDay ilkSaat =
        TimeOfDay(hour: formattedTime.hour, minute: formattedTime.minute);
    TimeOfDay ikinciSaat =
        TimeOfDay(hour: times.hour, minute: times.hour); // Saat 14:45
    int saatFarki = (ikinciSaat.hour * 60 + ikinciSaat.minute) -
        (ilkSaat.hour * 60 + ilkSaat.minute);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            iconTitle,
            color: saatFarki > 0 ? Colors.black : Colors.grey,
          ),
          saatFarki > 0
              ? Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
          saatFarki > 0
              ? Text(
                  DateFormat('HH:mm').format(times),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                )
              : Text(
                  DateFormat('HH:mm').format(times),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )

          // Text(
          //   DateFormat('HH:mm').format(times),
          //   style: formattedTime.isBefore(times)
          //       ? Theme.of(context)
          //           .textTheme
          //           .headlineSmall
          //           ?.copyWith(color: Colors.grey)
          //       : Theme.of(context)
          //           .textTheme
          //           .headlineSmall
          //           ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          // )
        ],
      ),
    );
  }
}
