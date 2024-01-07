import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleDividerWidget extends StatelessWidget {
  final String text;

  const TitleDividerWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: Colors.white,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w100,
                color: Colors.white
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Colors.white,),
          ),
        ],
      ),
    );
  }
}