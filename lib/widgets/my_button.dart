import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Color colour;
  final String text;
  final Function() onPress;

  MyButton({required this.colour, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),
          ),
        ),
      ),
    );
  }
}