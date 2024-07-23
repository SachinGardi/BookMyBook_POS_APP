import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import '../../modal/reports_modal/salesBySchool_Level1_modal.dart';



var searchString = ''.obs;
void salesBySchoolFilterL1Books(String query) {
  searchString.value = query;
}

List<SchoolSalesLevel1Modal> getSalesBySchoolL1Books() {
  if (searchString.isEmpty) {
    return salesBySchoolLevel1Vm.getSchoolSalesLevel1List;
  } else {
    return salesBySchoolLevel1Vm.getSchoolSalesLevel1List.where((book) {
      return book.schoolName.toLowerCase().contains(searchString.toLowerCase()) ||
          book.location.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}



class FirstListWidget extends StatefulWidget {
  final Function(int) onSwitch;

  const FirstListWidget({required this.onSwitch});

  @override
  State<FirstListWidget> createState() => _FirstListWidgetState();
}

class _FirstListWidgetState extends State<FirstListWidget> {

  apiCalling() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    salesBookClick = false;
    salesBySchoolL1Controller.clear();
    salesBySchoolL2Controller.clear();
    salesBySchoolL3Controller.clear();
    salesBySchoolLevel1Vm.getSchoolSalesLevel1List.clear();
    salesBySchoolLevel1Vm.isLoading.value = true;
    await salesBySchoolLevel1Vm.getSchoolSalesDetails(pref.getInt('userId')!,0,0,0,"","","");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCalling();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
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
                          // border: Border.all(color: const Color(0xFF7367F0)),
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
                                child: Center(child: Text("School Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                            Expanded(
                                flex:2,
                                child: Center(child: Text("Location",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
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
                    height: MediaQuery.of(context).size.height/2.32,
                    child: Obx(()=>
                        ModalProgressHUD(color: Colors.white,
                          inAsyncCall: salesBySchoolLevel1Vm.isLoading.value == true,
                          progressIndicator: const Text(""),
                          child: getSalesBySchoolL1Books().isEmpty?const Center(child: Text("No Data Found")):ListView.builder(
                              itemCount: getSalesBySchoolL1Books().length,
                              itemBuilder: (BuildContext context,index){
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        setState(() async {
                                          salesSchoolIdL1 = getSalesBySchoolL1Books()[index].id;
                                          salesSchoolName = getSalesBySchoolL1Books()[index].schoolName;
                                          salesSchoolLocation = getSalesBySchoolL1Books()[index].location;
                                          salesSchoolTotalSales = getSalesBySchoolL1Books()[index].totalSale;
                                          getSalesBySchoolL1Books().clear();
                                          salesBySchoolL2Vm.getSchoolSales2List.clear();
                                          salesBySchoolL2Vm.isLoading.value = true;
                                         await salesBySchoolL2Vm.getSchoolSalesDetails2(pref.getInt('userId')!, salesSchoolIdL1!,0,0,"","");
                                          widget.onSwitch(1);
                                        });
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("${index+1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Text(getSalesBySchoolL1Books()[index].schoolName,style: TextStyle(color: Colors.black,fontFamily: "NotoSans"))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text(getSalesBySchoolL1Books()[index].location,style: TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(getSalesBySchoolL1Books()[index].date.toString())),style: TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          Expanded(
                                              flex:2,
                                              child: Center(child: Text("₹ ${getSalesBySchoolL1Books()[index].totalSale}",style: TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }),
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}