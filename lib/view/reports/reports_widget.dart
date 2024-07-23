

import 'package:flutter/material.dart';

Widget labelValue(String key,String value)=>Row(
  children: [
    Text(key,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")),
    Text(value,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")),
  ],
);