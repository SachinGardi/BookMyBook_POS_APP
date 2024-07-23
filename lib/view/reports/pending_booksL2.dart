import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tuck_shop/view/reports/pending_books.dart';
import 'package:tuck_shop/view/reports/pending_reports_dialog.dart';
import 'package:tuck_shop/view/reports/reports_widget.dart';
import '../../modal/reports_modal/pending_Level2_modal.dart';
import '../../view_modal/reports/pending_dialogVm.dart';




TextEditingController pendingBooksL2Controller = TextEditingController();
var searchString = ''.obs;
void pendingBooksL2(String query) {
  searchString.value = query;
}
List<PendingReportsLevel2Modal> getPendingBooksL2() {
  if (searchString.isEmpty) {
    return pendingLevel2ReportVm.pendingLevel2List;
  } else {
    return pendingLevel2ReportVm.pendingLevel2List.where((book) {
      return book.orderId.toLowerCase().contains(searchString.toLowerCase()) ||
          book.studentName.toLowerCase().contains(searchString.toLowerCase()) ||
          book.mobileNo.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}

String? pendingStudentName;
String? pendingOrderNo;
String? pendingMobileNo;
DateTime? pendingDate;
String? pendingDivision;
PendingDialogVm pendingDialogVm = Get.put(PendingDialogVm());

class PendingSecondListWidget extends StatefulWidget {
  const PendingSecondListWidget({super.key});

  @override
  State<PendingSecondListWidget> createState() => _PendingSecondListWidgetState();
}

class _PendingSecondListWidgetState extends State<PendingSecondListWidget> {
  int? pendingOrderId;

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        ModalProgressHUD(
          color: Colors.white,
          inAsyncCall: pendingLevel1Vm.isLoading.value == true,
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
                            child: Text("School :-   ${pendingLevel1SchoolName!}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans"))),
                            Expanded(
                                flex:2,
                                child: labelValue("Std :- ",pendingLevel1Std!)),
                            Expanded(
                                flex:2,
                                child: labelValue("Location :- ",pendingLevel1Location!)),
                    ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/100),
                        Row(
                          children: [
                            Expanded(
                                flex:3,
                                child: labelValue("Book Set Name :- ",pendingLevel1BookSetName!)),
                            Expanded(
                                flex:4,
                                child: labelValue("Qty. Pending :- ",pendingLevel1QtyPending!.toString())),
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
                                      child: Center(child: Text("Order ID",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Student Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Date",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Mobile No.",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                  Expanded(
                                      flex:2,
                                      child: Center(child: Text("Quantity",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                                ],
                              ))),
                          const Divider(height: 0,color: Color(0xFF7367F0))
                        ],
                      ),
                      Card(
                        elevation: 0,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height/3.25,
                          child: Obx(()=>
                              ModalProgressHUD(
                                inAsyncCall: pendingLevel2ReportVm.isLoading.value == true,
                                progressIndicator: const Text(""),
                                child: getPendingBooksL2().isEmpty?const Center(child: Text("No data found")):ListView.builder(
                                    itemCount: getPendingBooksL2().length,
                                    itemBuilder: (BuildContext context,index){
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              print(getPendingBooksL2()[index].oId);
                                              pendingStudentName = getPendingBooksL2()[index].studentName;
                                              pendingOrderNo = getPendingBooksL2()[index].orderId;
                                              pendingOrderId = getPendingBooksL2()[index].oId;
                                              pendingMobileNo = getPendingBooksL2()[index].mobileNo;
                                              pendingDate = getPendingBooksL2()[index].date;
                                              pendingDivision = getPendingBooksL2()[index].division;
                                              pendingDialogVm.pendingDialogListVm.clear();
                                              pendingDialogVm.isLoading.value = true;
                                              await pendingDialogVm.getPendingBookDetail(pendingOrderId!);
                                              showPendingDialogL2(context);
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text("${index+1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text(getPendingBooksL2()[index].orderId,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text(getPendingBooksL2()[index].studentName,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(getPendingBooksL2()[index].date.toString())),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text(getPendingBooksL2()[index].mobileNo,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                                Expanded(
                                                    flex:2,
                                                    child: Center(child: Text(getPendingBooksL2()[index].qtyPending.toString(),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                              ],
                                            )),
                                          const Divider(),
                                        ],
                                      );
                                    })))))
                    ],
                  ))),
            ],
          )));
  }
}