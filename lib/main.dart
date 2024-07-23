import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/dashboard/tabbar_dashboard_view.dart';
import 'package:tuck_shop/view/login_screen/login_screen.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import 'package:tuck_shop/view/point_of_sale/receipt_webview.dart';
import 'package:tuck_shop/view/profile_screen/profile_screen.dart';


Future<int?> getLogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId');
}

Future<void> requestPermissions() async {
  Permission.location.request();
  Permission.bluetooth.request();
}
///Permission Request
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  getLogin().then((value) =>
  {
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: value != null ? "/dashboard" : "/",
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen(), transition: Transition.leftToRight),
        GetPage(name: "/dashboard", page: () => const TabbarView(), transition: Transition.leftToRight),
        GetPage(name: "/pointOfSale", page: () => const PointOfSale(), transition: Transition.leftToRight),
        GetPage(name: "/profileScreen", page: () => const ProfileScreen(), transition: Transition.topLevel),
        GetPage(name: "/receiptWebView", page: () => const ReceiptWebView(), transition: Transition.leftToRight),
      ],
    ))
  });
}









