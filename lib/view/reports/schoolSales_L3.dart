import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';

import '../../modal/reports_modal/salesBySchool_Level3_modal.dart';
import '../../view_modal/reports/salesBySchool_Level3Vm.dart';



var searchString = ''.obs;
void salesBySchoolFilterL3Books(String query) {
  searchString.value = query;
}

List<SchoolReportsLevel3Modal> getSalesBySchoolL3Books() {
  if (searchString.isEmpty) {
    return salesBySchoolL3Vm.getSchoolSales3List;
  } else {
    return salesBySchoolL3Vm.getSchoolSales3List.where((book) {
      return book.division.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}

class ThirdListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        ModalProgressHUD(
            inAsyncCall: salesBySchoolL3Vm.isLoading.value == true,
            progressIndicator: const Text(""),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/540, horizontal: MediaQuery.of(context).size.width/100),
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
                                  child: Text("School : ${salesSchoolName!}")),
                              Expanded(
                                  flex:4,
                                  child: Text("Std : ${salesSchoolStd!}")),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/100),
                          Row(
                            children: [
                              Expanded(
                                  flex:3,
                                  child: Text("Location : ${salesSchoolLocation!}")),
                              Expanded(
                                  flex:4,
                                  child: Text("Total Division : ${totalDivisionCount == null?"":totalDivisionCount!}")),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/100),
                          Row(
                            children: [
                              Expanded(
                                  flex:3,
                                  child: Text("Total Students : ${totalDivStudentCount == null?"":totalDivStudentCount!}")),
                              Expanded(
                                  flex:4,
                                  child: Text("Total Sale  : ₹ ${salesSchoolTotalSales!}")),
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF7367F0).withOpacity(0.2),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),

                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70),
                                child: const Row(
                                  children: [
                                    Expanded(
                                        flex:2,
                                        child: Center(child: Text("Sr No.",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                    Expanded(
                                        flex:2,
                                        child: Center(child: Text("Division",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
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
                            const Divider(height: 0,color: Color(0xFF7367F0)),

                            Card(
                                elevation: 0,
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height/3.5,
                                    child: ListView.builder(
                                        itemCount: getSalesBySchoolL3Books().length,
                                        itemBuilder: (BuildContext context,index){
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex:2,
                                                      child: Center(child: Text("${index +1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                  Expanded(
                                                      flex:2,
                                                      child: Center(child: Text(getSalesBySchoolL3Books()[index].division,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                  Expanded(
                                                      flex:2,
                                                      child: Center(child: Text(getSalesBySchoolL3Books()[index].students.toString(),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                  Expanded(
                                                      flex:2,
                                                      child: Center(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(getSalesBySchoolL3Books()[index].date.toString())),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                  Expanded(
                                                      flex:2,
                                                      child: Center(child: Text("₹ ${getSalesBySchoolL3Books()[index].totalSale}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          );
                                        })))
                          ],
                        ))),
              ],
            )));
  }
}