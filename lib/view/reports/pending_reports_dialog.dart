import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tuck_shop/view/reports/pending_books.dart';
import 'package:tuck_shop/view/reports/pending_booksL2.dart';

import '../../view_modal/reports/pending_dialogVm.dart';

Future<void> showPendingDialogL2(BuildContext context) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: const EdgeInsets.only(bottom: 2,),
          actionsPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height/80
          ),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40,
                    left: MediaQuery.of(context).size.width / 40,
                    bottom: MediaQuery.of(context).size.height /90,
                    right:MediaQuery.of(context).size.width / 40
                ),
                child: Row(
                  children: [
                    Text(
                      'Pending Items',
                      style: TextStyle(
                          fontFamily: "NotoSans",
                          color: const Color(0xFF5448D2),
                          fontSize: MediaQuery.of(context).size.height /35,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child:  Icon(
                          Icons.cancel,color: const Color(0xff7367F0),
                          size: MediaQuery.of(context).size.height /20,
                        ))
                  ],
                ),
              ),
              const Divider(
                thickness: 2.5,
                color: Color(0xaaB5B5B5),
              )
            ],
          ),
          content: Obx(()=> pendingDialogVm.isLoading.value == true?const Text(("")): NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height/1.6,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width/50),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: Color(0xffE0DDFC)
                                )
                            ),
                            elevation: 0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width/50,
                                      vertical: MediaQuery.of(context).size.height/80,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:4,
                                          child: Text("${pendingStudentName!}  (${pendingOrderNo!})",style: TextStyle(
                                              fontFamily: 'NotoSansSemiBold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height/40,
                                              color: const Color(0xff3B3B3B)
                                          ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          flex:4,
                                          child: Text(pendingLevel1SchoolName!,style: TextStyle(
                                              fontFamily: 'NotoSansSemiBold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height/40,
                                              color: const Color(0xff3B3B3B)
                                          ),
                                          textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex:4,
                                          child: Text("Pending",style: TextStyle(
                                              fontFamily: 'NotoSansSemiBold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height/40,
                                              color: const Color(0xffBE5151)
                                          ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                    thickness:1,
                                    color: Color.fromRGBO(224, 221, 252, 1)),
                                  ///standard and invoice row
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: MediaQuery.of(context).size.height/80,
                                        horizontal: MediaQuery.of(context).size.width/50),
                                    child:  Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context).size.height/150),
                                          child:  Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex:2,
                                                        child: Text('Order ID',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 0,
                                                        child: Text(':',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43))),
                                                    SizedBox(width: MediaQuery.of(context).size.width/50),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Text(pendingOrderNo!,style: TextStyle(
                                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        )))
                                                  ],
                                                )),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex:2,
                                                        child: Text('Mob',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(':',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 8,
                                                        child: Text(pendingMobileNo!,style: TextStyle(
                                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                                            fontSize: MediaQuery.of(context).size.height/43,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Align(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex:5,
                                                          child: Text('Date',style: TextStyle(
                                                              color: const Color.fromRGBO(129, 129, 129, 1),
                                                            fontSize: MediaQuery.of(context).size.height/43,
                                                          ),
                                                            textAlign: TextAlign.end,
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(':',style: TextStyle(
                                                              color: const Color.fromRGBO(129, 129, 129, 1),
                                                            fontSize: MediaQuery.of(context).size.height/43,
                                                          ),
                                                              textAlign: TextAlign.center
                                                          )),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(pendingDate!.toIso8601String())),style: TextStyle(
                                                              color: const Color.fromRGBO(59, 59, 59, 1),
                                                            fontSize: MediaQuery.of(context).size.height/43,
                                                          )))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],

                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/150),
                                          child:  Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex:2,
                                                        child: Text('Std',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 0,
                                                        child: Text(':',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    SizedBox(width: MediaQuery.of(context).size.width/50),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Text(pendingLevel1Std!,style: TextStyle(
                                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex:2,
                                                        child: Text('Div',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(':',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ))),
                                                    Expanded(
                                                        flex: 8,
                                                        child: Text(pendingDivision!,style: TextStyle(
                                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex:5,
                                                        child: Text('Order Value',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        ),
                                                          textAlign: TextAlign.end,
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(':',style: TextStyle(
                                                            color: const Color.fromRGBO(129, 129, 129, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43),
                                                            textAlign: TextAlign.center
                                                        )),
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text("₹ ${pendingOrderValue!}",style: TextStyle(
                                                            color: const Color.fromRGBO(59, 59, 59, 1),
                                                          fontSize: MediaQuery.of(context).size.height/43,
                                                        )))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                    thickness:1,
                                    color: Color.fromRGBO(224, 221, 252, 1),
                                  ),
                                  ///label for Rows
                                  Padding(
                                    padding:  EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width/50,
                                      vertical: MediaQuery.of(context).size.height/80,
                                    ),
                                    child: Row(

                                      children: [
                                        ///SrNo
                                        Expanded(
                                          flex:2,
                                          child: Text('Sr.No.',style: TextStyle(
                                              fontFamily: 'NotoSansSemiBold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height/45,
                                              color: const Color(0xff3B3B3B)
                                          ))),
                                        ///Book Name
                                        Expanded(
                                          flex: 6,
                                          child: Text('Pending Items',style: TextStyle(
                                              fontFamily: 'NotoSansSemiBold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height/45,
                                              color: const Color(0xff3B3B3B)
                                          ),),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/150),
                                        ///Publication
                                        Expanded(
                                          flex: 6,
                                          child: Text('Publication',style: TextStyle(
                                            fontFamily: 'NotoSansSemiBold',
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context).size.height/45,
                                          ))),

                                        ///Amount
                                        Expanded(
                                          flex: 2,
                                          child: Text('Amount',style: TextStyle(
                                            fontFamily: 'NotoSansSemiBold',
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context).size.height/45,

                                          ),),
                                        ),
                                        ///Quantity
                                        Expanded(
                                          flex: 0,
                                          child: Text('Quantity',style: TextStyle(
                                            fontFamily: 'NotoSansSemiBold',
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context).size.height/45,
                                          ))),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                    thickness:1,
                                    color: Color.fromRGBO(224, 221, 252, 1)),
                                  Container(
                                    height: MediaQuery.of(context).size.height/2.45,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: pendingDialogVm.pendingBookListVm.length,
                                      shrinkWrap: true,
                                      itemBuilder:(context, index) => Card(
                                        elevation: 0,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width/50,
                                            vertical: MediaQuery.of(context).size.height/80,
                                          ),
                                          child: Row(

                                            children: [
                                              ///SrNo
                                              Expanded(
                                                flex:2,
                                                child: Text('${index + 1}',style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: MediaQuery.of(context).size.height/43,
                                                    color: const Color(0xff616161)
                                                ),
                                                )),
                                              ///Book Name
                                              Expanded(
                                                flex: 7,
                                                child: Text(pendingDialogVm.pendingBookListVm[index].bookName,style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: MediaQuery.of(context).size.height/43,
                                                    color: const Color(0xff616161)
                                                ),
                                                    textAlign: TextAlign.left)),
                                              ///Publication
                                              Expanded(
                                                flex: 7,
                                                child: Text(pendingDialogVm.pendingBookListVm[index].publication,style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: MediaQuery.of(context).size.height/43,
                                                    color: const Color(0xff616161),
                                                ),
                                                    textAlign: TextAlign.left
                                                ),
                                              ),

                                              ///Amount
                                              Expanded(
                                                flex: 2,
                                                child: Text(pendingDialogVm.pendingBookListVm[index].amount.toString(),style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: MediaQuery.of(context).size.height/43,
                                                    color: const Color(0xff616161)),
                                                )),
                                              ///Quantity
                                              Expanded(
                                                flex: 1,
                                                child: Text(pendingDialogVm.pendingBookListVm[index].qty.toString(),style: TextStyle(
                                                    fontFamily: 'NotoSans',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: MediaQuery.of(context).size.height/43,
                                                    color: const Color(0xff616161)),
                                                  textAlign: TextAlign.left,
                                                )),
                                            ],
                                          ))))),
                                ],
                              ))))))));
      });
}
