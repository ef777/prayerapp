import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:namazvakitleri/views/intro_view/intro_view_1.dart';

class IntoView2 extends StatelessWidget {
  const IntoView2({key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            bottom: false,
            child: OntroWidget(
                desc: 'main.qibleIntro'.tr(),
                pageController: pageController,
                image: "assets/6.png",
                title: "Qible Direction"),
          ),
        ),
      ],
    );
  }
}
