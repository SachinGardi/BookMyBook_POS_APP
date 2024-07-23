import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/pending_books.dart';
import 'package:tuck_shop/view/reports/pending_booksL2.dart';
import '../../modal/reports_modal/pending_Level1_modal.dart';
import '../../view_modal/reports/pending_level1Vm.dart';



var searchString = ''.obs;
void pendingBooksL1(String query) {
  searchString.value = query;
}
List<PendingLevel1Modal> getPendingBooksL1() {
  if (searchString.isEmpty) {
    return pendingLevel1Vm.pendingLevel1List;
  } else {
    return pendingLevel1Vm.pendingLevel1List.where((book) {
      return book.schoolName.toLowerCase().contains(searchString.toLowerCase()) ||
          book.location.toLowerCase().contains(searchString.toLowerCase());
    }).toList();
  }
}
class PendingFirstListWidget extends StatefulWidget {
  final Function(int) onSwitch;

  const PendingFirstListWidget({required this.onSwitch});

  @override
  State<PendingFirstListWidget> createState() => _PendingFirstListWidgetState();
}

class _PendingFirstListWidgetState extends State<PendingFirstListWidget> {

  int _page = 1;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      {
        Timer(const Duration(milliseconds: 800), () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pendingLevel1Vm.pendingLevel1List.clear();
          pendingLevel1Vm.isLoading.value = true;
          await pendingLevel1Vm.getPendingLevel1Detail(_page.toString(),"10",pref.getInt('userId')!,0,0,0,"","");

        });
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pendingLevel1Vm.getPendingLevel1Detail(_page.toString(),"10",pref.getInt('userId')!,0,0,0,"","");
        print(pendingL1Count);
        if (_page == pendingL1Count) {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }


  ScrollController scrollController1 = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCalling();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
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
                                child: Center(child: Text("School Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                            Expanded(
                                flex:2,
                                child: Center(child: Text("Location",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                            Expanded(
                                flex:2,
                                child: Center(child: Text("Standard",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                            Expanded(
                                flex:2,
                                child: Center(child: Text("Book Set Name",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
                            Expanded(
                                flex:2,
                                child: Center(child: Text("Qty. Pending",textAlign:TextAlign.center,style: TextStyle(fontFamily: "NotoSansSemiBold")))),
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
                        ModalProgressHUD(
                          inAsyncCall: pendingLevel1Vm.isLoading.value == true,
                          progressIndicator: const Text(""),
                          child: Scrollbar(
                            child: ListView.builder(
                                controller: _controller,
                                itemCount: getPendingBooksL1().length,
                                itemBuilder: (BuildContext context,index){
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          pendingLevel1SchoolId = pendingLevel1Vm.pendingLevel1List[index].schoolId;
                                          pendingLevel1Std = pendingLevel1Vm.pendingLevel1List[index].standard;
                                          pendingLevel1SchoolName = pendingLevel1Vm.pendingLevel1List[index].schoolName;
                                          pendingLevel1Location = pendingLevel1Vm.pendingLevel1List[index].location;
                                          pendingLevel1BookSetName = pendingLevel1Vm.pendingLevel1List[index].bookSetName;
                                          pendingLevel1QtyPending = pendingLevel1Vm.pendingLevel1List[index].qtyPending;
                                          pendingLevel1BookSetID = pendingLevel1Vm.pendingLevel1List[index].bookSetId;
                                          print(pendingLevel1SchoolId);
                                          getPendingBooksL2().clear();
                                          pendingLevel2ReportVm.isLoading.value = true;
                                          pendingLevel2ReportVm.getReportLevel2Detail("1","300",pref.getInt('userId')!, pendingLevel1SchoolId!,0,pendingLevel1BookSetID!,0,"","");
                                          widget.onSwitch(1);
                                          pendingBookClick = true;
                                          print(pendingLevel1Vm.pendingLevel1List[index].schoolId);
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text("${index+1}",style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text(getPendingBooksL1()[index].schoolName.toString(),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text(getPendingBooksL1()[index].location,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text(getPendingBooksL1()[index].standard,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text(getPendingBooksL1()[index].bookSetName,style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                            Expanded(
                                                flex:2,
                                                child: Center(child: Text(getPendingBooksL1()[index].qtyPending.toString(),style: const TextStyle(color: Colors.black,fontFamily: "NotoSans")))),
                                          ],
                                        )),
                                      const Divider(),
                                    ],
                                  );
                                }))))))
              ],
            ))),
      ],
    );
  }
}