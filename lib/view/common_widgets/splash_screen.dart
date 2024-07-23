
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height/1,
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/images/login_images/TuckShop.png',height:MediaQuery.of(context).size.height/6 ,)),
              
              const CircularProgressIndicator(
                strokeWidth: 6.0, // Adjust the thickness of the circle
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4D3FD9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
