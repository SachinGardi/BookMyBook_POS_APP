import 'package:flutter/material.dart';

Widget profileInfo(BuildContext context,
        {String labelName = '', String labelValue = ''}) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex:0,
          child: Text(
            labelName,
            style:
            TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width/60,
                fontFamily: 'NotoSans',
                color: const Color(0xaa616161)),
          ),

        ),
        Expanded(
          flex: 0,
          child: Text(
            ' : ',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/60,
                fontWeight: FontWeight.w500,
                color: const Color(0xaa616161),

            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            labelValue,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/60,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSans',
                color: const Color(0xff3B3B3B)),

          ),
        ),
      ],
    );
