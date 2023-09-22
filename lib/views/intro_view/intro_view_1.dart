import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntoView1 extends StatelessWidget {
  const IntoView1({key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromARGB(255, 239, 239, 239),
          body: SafeArea(
              bottom: false,
              child: OntroWidget(
                title: "Prayer Time",
                pageController: pageController,
                image: "assets/7.png",
                desc: 'main.prayerIntro'.tr(),
              )),
        ),
      ],
    );
  }
}

class OntroWidget extends StatelessWidget {
  const OntroWidget({
    Key? key,
    this.pageController,
    required this.image,
    required this.title,
    this.onPressed,
    required this.desc,
  }) : super(key: key);

  final PageController? pageController;

  final String image;
  final String desc;

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              top: 200,
              right: MediaQuery.of(context).size.width / 4.5,
              child: Image.asset(
                image,
                height: 200,
              ),
            ),
            Image.asset(
              "assets/olllll.png",
            ),
            SizedBox(
              height: 420,
            )
          ],
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(
          desc,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        SizedBox(
          width: 140,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Color.fromARGB(255, 0, 61, 111)),
              onPressed: onPressed ??
                  () {
                    pageController!.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
              child: Text("İleri")),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
        ),
      ],
    );
  }
}
