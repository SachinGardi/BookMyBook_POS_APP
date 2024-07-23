import 'package:flutter/material.dart';

Widget progressIndicator() => Center(
  child: Container(
    decoration: BoxDecoration(
        color:const Color(0xff7367F0), borderRadius: BorderRadius.circular(10)),
    height:80,
    width: 80,
    child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1,
          ),
          Text(
            "Please wait",
            style: TextStyle(color: Colors.white, fontSize:10, decoration: TextDecoration.none),
          ),
        ]),
  ),
);