import 'package:flutter/material.dart';

const String checkAll = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
const String checkSpecial = r'^(?=.*?[!@#\$&*~])';
const String checkCapitalLetters = r'^(?=.*?[A-Z])';
const String checkSmallLetters = r'^(?=.*?[a-z])';
const String checkNumbers = r'^(?=.*?[0-9])';

String? validation(String? value, TextEditingController controller){
  if(controller.text.isEmpty){
    return 'Please enter password!';
  }
  else if(value!.trim().length < 8){
    return 'Password must contain atleast 8 character!';
  }
  else if(!RegExp(checkSmallLetters).hasMatch(value)){
    return 'Password must contain at least 1 small character!';
  }
  else if(!RegExp(checkCapitalLetters).hasMatch(value)){
    return 'Password must contain at least 1 capital character!';
  }
  else if (!RegExp(checkNumbers).hasMatch(value)) {
    return 'password must contain at least 1 number!';
  }
  else if (!RegExp(checkSpecial).hasMatch(value)) {
    return 'password must contain at least 1 special character!';
  }
  return null;
}

Widget commonButton(BuildContext context,String name)=>
    Padding(
      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height/100 ),
      child: Container(
        height: MediaQuery.of(context).size.height/12,
        width:  double.infinity,
        decoration:  BoxDecoration(
           color: const Color.fromRGBO(115, 103, 240, 1),
            borderRadius: BorderRadius.circular(5)),
        child: Center(child: Text(name,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSans',
              fontSize: MediaQuery.of(context).size.height / 35),)),
      ),
    );



