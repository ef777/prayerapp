import 'package:flutter/material.dart';

class WidgetBuyying extends StatelessWidget {
  const WidgetBuyying({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      body: Container(
        width: double.infinity,
        height: 300,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Text(
              "Widget",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Namaz vakitleri güncel olarak her zaman \n ana ekranında",
              style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            Image.asset(
              "assets/widget.png",
              fit: BoxFit.cover,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
