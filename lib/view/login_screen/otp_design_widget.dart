import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  bool fill = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      width: MediaQuery.of(context).size.width / 20,
      child: TextField(
        style: TextStyle(
            color: Colors.black,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height / 30),
        //autofocus: autoFocus,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[0-9]')),
        ],
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Colors.black,
        cursorWidth: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 1),
          filled: true,
          focusColor: Colors.black,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          counterText: '',
          hintStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
            fill = true;
          }
          if (value.isEmpty ) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}