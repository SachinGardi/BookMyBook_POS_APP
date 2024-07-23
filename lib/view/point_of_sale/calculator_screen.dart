import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dynamic_calculator/flutter_dynamic_calculator.dart';
import 'package:get/get.dart';

double? _currentValue = 0;
class CalculatorButton extends StatefulWidget {
  const CalculatorButton({super.key});

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  void handleTap(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,

      builder: (context) {
        return Dialog(

          child: SizedBox(
            width:MediaQuery.of(context).size.width/2.6, // Set your desired width
            height:MediaQuery.of(context).size.height/0.9, // Set your desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width:MediaQuery.of(context).size.width/2.9, // Set your desired width
                  height:MediaQuery.of(context).size.height/14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Calculator",
                          style: TextStyle(
                              color: const Color(0xFF5448D2),
                              fontFamily:"NotoSans",
                              fontSize: MediaQuery.of(context).size.height /35,
                              fontWeight: FontWeight.w600)
                      ),
                      IconButton(onPressed: (){
                        Get.back();
                      }, icon:  Icon(Icons.cancel_outlined,
                        color: Colors.redAccent,
                          size: MediaQuery.of(context).size.height/20,

                      ),
                        alignment: Alignment.topRight,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width:MediaQuery.of(context).size.width/2.9, // Set your desired width
                  height:MediaQuery.of(context).size.height/1.4,
                  child: DynamicCalculator(
                    value: _currentValue!,
                    hideExpression: false,
                    hideSurroundingBorder: true,
                    showCalculatorDisplay: true,

                    autofocus: true,
                    onChanged: (key, value, expression) {
                      setState(() {
                        _currentValue = value ?? 0;
                      });
                      if (kDebugMode) {
                        print('$key\t$value\t$expression');
                      }
                    },
                    onTappedDisplay: (value, details) {
                      if (kDebugMode) {
                        print('$value\t${details.globalPosition}');
                      }
                    },
                    theme:  CalculatorTheme(
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      displayCalculatorRadius: 0.0,
                      displayBackgroundColor: Colors.white,

                      displayStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/20, color: const Color(0xFF7367F0)),
                      expressionBackgroundColor: Colors.black12,

                      expressionStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/30, color: Colors.black),
                      operatorColor:  const Color(0xFF7367F0),
                      operatorStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/25, color: Colors.white),
                      commandColor: Colors.white,
                      commandStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/25, color: const Color(0xFF7367F0)),
                      numColor: Colors.white,

                      numStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/25, color: Colors.black87),

                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => handleTap(context),
      child: SvgPicture.asset(
        "assets/images/pos_images/calculator.svg",
        height: MediaQuery.of(context).size.height / 6,
      ),
    );
  }
}