// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressed,
    this.title,
    required this.color,
  }) : super(key: key);
  final void Function()? onPressed;
  final String? title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: color),
          onPressed: onPressed,
          child: Text(
            title ?? "Hadi Başlıyalım",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
