import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget totalCountDashboard(BuildContext context, String title, String count,
        String img, Color color) =>
    Container(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 4.33,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFFFFFFF)),
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
              // spreadRadius: 2, // Adjust the spread radius
              blurRadius: 5, // Adjust the blur radius
              // offset: const Offset(0, 3), // Adjust the offset
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width /60,
                      vertical: MediaQuery.of(context).size.height / 106),
                  child: Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: MediaQuery.of(context).size.height/36.5,
                          fontFamily: "NotoSans")),
                ),
                const Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: SvgPicture.asset(img,fit: BoxFit.contain,color: Colors.white,),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/130),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width /50,
            ),
            child: Text(count,
                style: TextStyle(
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height /35)),
          )
        ],
      ),
    );
