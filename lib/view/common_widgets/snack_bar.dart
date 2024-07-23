import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> toastMessage(
        BuildContext context, String message,
        {color = Colors.black}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/5,
        right: MediaQuery.of(context).size.width/5,
        bottom: MediaQuery.of(context).size.height/40),
    shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none
    ),
    duration:const Duration(seconds:2),
    content: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            message,
            style:  TextStyle(
                fontFamily: "NotoSans",
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height/42,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),

        ),

        GestureDetector(
          onTap: () {
            // Dismiss the Snackbar.
            scaffoldMessenger.hideCurrentSnackBar();
          },
          child:  Icon(Icons.cancel,size: MediaQuery.of(context).size.height/25,),
        )

      ],
    ),

    backgroundColor: const Color(0xff7367F0),
  );
      return scaffoldMessenger.showSnackBar(snackBar);
}





Flushbar<void>? _currentFlushbar;

Flushbar<void> snackbar(BuildContext context, String message,
    {Color color = Colors.black}) {
  _currentFlushbar?.dismiss();
  _currentFlushbar = Flushbar<void>(
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 100),

    flushbarStyle: FlushbarStyle.FLOATING,
    messageText: Text(
      message,
      style:  TextStyle(
          fontFamily: "NotoSans",
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height/43,
          color: Colors.white),
      textAlign: TextAlign.center,
    ),
    margin: EdgeInsets.only(
      left: MediaQuery.of(context).size.width /4.8,
      right: MediaQuery.of(context).size.width /4.8,
      bottom: MediaQuery.of(context).size.height /20,
    ),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: const Color(0xff7367F0),
    mainButton: TextButton(
      onPressed: () {
        _currentFlushbar?.dismiss(); 
      },
      child: Icon(
        Icons.cancel,
        size: MediaQuery.of(context).size.height / 25,
        color: Colors.black54,
      ),
    ),
  )..show(context);

  return _currentFlushbar!;
}