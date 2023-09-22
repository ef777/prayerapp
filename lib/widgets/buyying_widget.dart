import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/views/buyying_view/buying_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuyyingWidget extends StatelessWidget {
  const BuyyingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => BuyyingView())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 105,
        width: 346,
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
                  'main.get_premium_now'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'main.ad_free_and_more'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: Colors.grey, fontSize: 14),
                )
              ],
            ),
            Container(
              width: 52,
              height: 52,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(FontAwesomeIcons.dollarSign),
            )
          ],
        ),
      ),
    );
  }
}
