import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import '../../modal/reports_modal/salesBySchool_Level2_modal.dart';
import '../../view_modal/reports/salesBySchool_Level2Vm.dart';



var searchString = ''.obs;
void salesBySchoolFilterL2Books(String query) {
  searchString.value = query;
}

List<SchoolReportsLevel2Modal> getSalesBySchoolL2Books() {
  if (searchString.isEmpty) {
    return salesBySchoolL2Vm.getSchoolSales2List;
  } else {
    return salesBySchoolL2Vm.getSchoolSales2List.where((book) {
      return book.standard.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}

class SecondListWidget extends StatefulWidget {
  final Function(int) onSwitch;

  const SecondListWidget({required this.onSwitch});

  @override
  State<SecondListWidget> createState() => _SecondListWidgetState();
}

sales3ApiCalling() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    salesBySchoolL3Vm.getSchoolSales3List.clear();
    salesBySchoolL3Vm.isLoading.value = true;
    await salesBySchoolL3Vm.getSchoolSalesDetails2(
        pref.getInt('userId')!, salesSchoolIdL1!, salesSchoolStdId!, 0, "", "");
  });
}
class _SecondListWidgetState extends State<SecondListWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        ModalProgressHUD(
          inAsyncCall: salesBySchoolL2Vm.isLoading.value == true,
          progressIndicator: const Text(""),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/140, horizontal: MediaQuery.of(context).size.width/100),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/130, horizontal: MediaQuery.of(context).size.width/100),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text("School     : ${salesSchoolName!}")),
                            Expanded(
                                flex:4,
                                child: Text("Total Std   : ${totalStandardCount!}")),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/100),
                        Row(
                          children: [
                            Expanded(
                                flex:3,
                                child: Text("Location : ${salesSchoolLocation == null?const Text(""):salesSchoolLocation!}")),
                            Expanded(
                                flex:4,
                                child: Text("Total Sale : ₹ ${salesSchoolTotalSales!}")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80,vertical: MediaQuery.of(context).size.height/100),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF7367F0)),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xFF7367F0).withOpacity(0.2),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70),
                              child: const Row(
                                children: [
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Sr No.",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Standard",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Total Students",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Last Transaction Date",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Total Sale",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 0,color: Color(0xFF7367F0))
                        ],
                      ),
                      Card(
                        elevation: 0,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height/3.12,
                          child: ListView.builder(
                              itemCount: getSalesBySchoolL2Books().length,
                              itemBuilder: (BuildContext context,index){
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          salesBySchoolL1Controller.clear();
                                          salesBySchoolL2Controller.clear();
                                          salesBySchoolL3Controller.clear();
                                          salesSchoolStd = getSalesBySchoolL2Books()[index].standard;
                                          salesSchoolStdId = getSalesBySchoolL2Books()[index].id;
                                          sales3ApiCalling();
                                          widget.onSwitch(2);
                                        });
                                        print(salesSchoolStd);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("${index + 1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text(getSalesBySchoolL2Books()[index].standard,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text(getSalesBySchoolL2Books()[index].totalStudent.toString(),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(getSalesBySchoolL2Books()[index].date.toString())),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("₹ ${getSalesBySchoolL2Books()[index].totalSale}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}