import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/main.dart';

import 'intro_view_1.dart';

class IntoView3 extends StatelessWidget {
  const IntoView3({key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: OntroWidget(
                desc: 'main.teshibIntro'.tr(),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomBarView())),
                image: "assets/5.png",
                title: "Tasbeeh Counter"),
          ),
        ),
      ],
    );
  }
}
