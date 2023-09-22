import 'package:flutter/material.dart';

class SelectedConteiner extends StatefulWidget {
  SelectedConteiner(
      {key,
      required this.planTitle,
      required this.price,
      required this.isMon,
      required this.selected,
      this.onPressed});
  final String planTitle;
  final int price;
  final bool isMon;
  final bool selected;
  final void Function()? onPressed;

  @override
  State<SelectedConteiner> createState() => _SelectedConteinerState();
}

class _SelectedConteinerState extends State<SelectedConteiner> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 80,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
            border: widget.selected
                ? Border.all(
                    width: 2,
                    color: Color.fromRGBO(27, 41, 86, 1),
                  )
                : Border.all(
                    width: 0, color: Color.fromARGB(255, 165, 92, 24))),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.planTitle,
                style: Theme.of(context).textTheme.button,
              ),
              Center(
                child: widget.isMon
                    ? Text(
                        "₺" + widget.price.toString() + "/aylık",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "₺" + widget.price.toString() + "/yıllık",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
              ),
              Visibility(
                visible: !widget.isMon,
                child: Text(
                  (widget.price / 12).toString() + "/aylık",
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Visibility(
                visible: !widget.isMon,
                child: Center(
                  child: Container(
                    width: 140,
                    height: 22,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(27, 41, 86, 1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                        child: Text(
                      "%7 Daha Uygun",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
