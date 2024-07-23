import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/common_widgets/snack_bar.dart';
import 'package:tuck_shop/view/profile_screen/profile_screen.dart';
import 'package:tuck_shop/view_modal/profile/profile_vm.dart';
import '../order_history_screen/order_history_screen.dart';
import '../point_of_sale/pos_design.dart';
import '../reports/reports_tabbar.dart';
import 'dashboard_design.dart';

int currentIndex = 3;


class TabbarView extends StatefulWidget {
  const TabbarView({super.key});

  @override
  _TabbarViewState createState() => _TabbarViewState();
}

class _TabbarViewState extends State<TabbarView> {
  @override
  void initState() {
    currentIndex = 0;
    if (Get.arguments == 1) {
      currentIndex = 1;
    }
    else if (Get.arguments == 2) {
      currentIndex = 2;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 9.5),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            backgroundColor: const Color(0xFF7367F0),
            flexibleSpace: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                              height: MediaQuery.of(context).size.height / 9,
                              color: const Color(0xFFD8D5FF),
                              child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width / 130),
                                  SvgPicture.asset(
                                      "assets/images/dashboard_img/home.svg",
                                      height:
                                          MediaQuery.of(context).size.height /
                                              16),
                                  SizedBox(width: MediaQuery.of(context).size.width / 120),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Book',
                                        style: TextStyle(
                                            color: const Color(0xff5448D2),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                26.5,
                                            fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: 'My',
                                            style: TextStyle(
                                                color: const Color(0xffFF7630),
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    26.5,
                                                fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: 'Books',
                                        style: TextStyle(
                                            color: const Color(0xff5448D2),
                                            fontSize: MediaQuery.of(context).size.height / 26.5,
                                            fontWeight: FontWeight.bold)),
                                  ])),
                                ],
                              )))),
                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 4, // Number of tabs
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> tabs = [
                              {
                                "label": "Dashboard",
                                "icon":
                                    "assets/images/dashboard_img/dashboard_icon.svg"
                              },
                              {
                                "label": "POS",
                                "icon":
                                    "assets/images/dashboard_img/pos_icon.svg"
                              },
                              {
                                "label": "Order History",
                                "icon":
                                    "assets/images/dashboard_img/orderhistory_icon.svg"
                              },
                              {
                                "label": "Reports",
                                "icon":
                                    "assets/images/dashboard_img/reports_icon.svg"
                              },
                            ];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 45,
                                  vertical: MediaQuery.of(context).size.height / 55),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width / 68),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: currentIndex == index
                                          ? const Color(0xffE0DDFC)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(tabs[index]["icon"],
                                          color: currentIndex == index
                                              ? const Color(0xFF7367F0)
                                              : const Color(0xffE0DDFC)),
                                      // Prefix icon
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              70),
                                      // Spacer
                                      Text(tabs[index]["label"],
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  36,
                                              color: currentIndex == index
                                                  ? const Color(0xFF7367F0)
                                                  : const Color(0xffE0DDFC),
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "NotoSans")),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () {
                                showMenu(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(
                                      100, 90, 0, 0),
                                  items: <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1950),
                                        leading: SvgPicture.asset(
                                            "assets/images/dashboard_img/user_icon.svg"),
                                        title: Text(userName! ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF7367F0),
                                                fontFamily: "NotoSans")),
                                        // subtitle:  Text('xyz',style: TextStyle(color: Color(0xFF7367F0),fontFamily: "NotoSans")),
                                      ),
                                    ),
                                    const PopupMenuDivider(),
                                    PopupMenuItem(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1950),
                                        leading: const Icon(Icons.person,
                                            color: Color(0xFF7367F0)),
                                        title: const Text('Profile',
                                            style: TextStyle(
                                                color: Color(0xFF7367F0),
                                                fontFamily: "NotoSans")),
                                        onTap: () {
                                          setState(() {
                                            currentIndex = 4;
                                            selectedIndex = 1;
                                            profileBtn = const Color.fromRGBO(243, 242, 255, 0.85);
                                            changePassBtn = null;
                                            Get.back(result: const ProfileScreen());
                                          });
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1950),
                                        leading: const Icon(Icons.lock_outline,
                                            color: Color(0xFF7367F0)),
                                        title: const Text('Change Password',
                                            style: TextStyle(
                                                color: Color(0xFF7367F0),
                                                fontFamily: "NotoSans")),
                                        onTap: () {
                                          setState(() {
                                            currentIndex = 4;
                                            selectedIndex = 2;
                                            changePassBtn = const Color.fromRGBO(243, 242, 255, 0.85);
                                            profileBtn = null;
                                            Get.back(result: const ProfileScreen());
                                            oldPasswordController.text = "";
                                            newPasswordController.text = "";
                                            confirmPasswordController.text = "";
                                          });
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1950),
                                        leading: const Icon(
                                            Icons.power_settings_new_rounded,
                                            color: Color(0xFF7367F0)),
                                        title: const Text('Logout',
                                            style: TextStyle(
                                                color: Color(0xFF7367F0),
                                                fontFamily: "NotoSans")),
                                        onTap: () async {
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          pref.remove('userId');
                                          toastMessage(context, 'Logged out successfully!');
                                          standardVM.posStandardList.clear();
                                          standardVM.isLoading.value = true;
                                          getSchoolByUserVM.schoolDetailList.clear();
                                          getSchoolByUserVM.isLoading.value = true;
                                          posBookSetVM.bookSetList.clear();
                                          posBookSetVM.isLoading.value = true;
                                          posOrderDetails.clear();
                                          posSelectedStandard.value = "";
                                          getSchoolByUserVM.schoolDetailList.clear();
                                          getSchoolByUserVM.isLoading.value = true;
                                          posSelectedSchool.value= "";
                                          drawerSelectedSchool.value = "";
                                          dashboardStandardVM.dashboardStandardList.clear();
                                          dashboardStandardVM.isLoading.value = true;
                                          getDashboardSchoolVM.dashboardSchoolDetailList.clear();
                                          getDashboardSchoolVM.isLoading.value = true;
                                          posSelectedSchoolId.value = "";
                                          posStandardId = null;
                                          Get.offAllNamed('/');
                                        },
                                      ),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                  "assets/images/dashboard_img/user_icon.svg",
                                  height: MediaQuery.of(context).size.height /
                                      14))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: _buildPage(currentIndex)),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const PointOfSale();
        case 2:
        return const OrderHistoryScreen();
      case 3:
        return ReportsPage();
      case 4:
        return  ProfileScreen();
      default:
        return const SizedBox
            .shrink(); // Return an empty container if the index is out of bounds
    }
  }
}
