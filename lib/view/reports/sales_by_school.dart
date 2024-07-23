import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_modal/reports/salesBySchool_Level1Vm.dart';
import 'salesByschool_Listview_switcher.dart';


class SaleBySchool extends StatefulWidget {
  const SaleBySchool({Key? key}) : super(key: key);

  @override
  State<SaleBySchool> createState() => _SaleBySchoolState();
}


final salesBySchoolLevel1Vm = Get.put(SalesBySchoolLevel1Vm());

class _SaleBySchoolState extends State<SaleBySchool> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: ListViewSwitcher(),
      ),
    );
  }
}
