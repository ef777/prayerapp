import 'package:flutter/material.dart';
import 'package:namazvakitleri/views/intro_view/intro_view_1.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import 'intro_view/intro_view_3.dart';
import 'intro_view/intro_view_2.dart';

class IntroView extends StatefulWidget {
  const IntroView({key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  late int selectedPage;
  late final PageController _pageController;
  late final List<Widget> screenList;
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    screenList = [
      // ignore: todo
      //TODO:
      // projectler gönderilecek

      IntoView1(
        pageController: _pageController,
      ),
      IntoView2(
        pageController: _pageController,
      ),
      IntoView3()
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: screenList.length,
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                selectedPage = page;
              });
            },
            itemBuilder: (context, index) {
              return screenList[index];
            },
          ),
          Positioned(
            bottom: 30,
            child: PageViewDotIndicator(
              currentItem: selectedPage,
              count: screenList.length,
              unselectedColor: Color.fromARGB(255, 196, 138, 138),
              selectedColor: Color.fromARGB(255, 52, 53, 145),
              duration: Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
