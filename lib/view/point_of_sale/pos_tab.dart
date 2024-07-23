import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';
import 'package:tuck_shop/view/point_of_sale/pos_widgets.dart';
import '../../modal/pos_modal/bookset_modal.dart';
import '../../modal/pos_modal/orderdetail_modal.dart';
import '../../view_modal/pos_view_modal/counter_vm.dart';
import '../common_widgets/progress_indicator.dart';


var posPendingStatus= false.obs;
var currentIndexPos = 0.obs;
String posSearchString = '';

TextEditingController posSearchController = TextEditingController();






class PosTab extends StatefulWidget  {
  const PosTab({super.key});
  @override
  State<PosTab> createState() => PosTabState();
}
class PosTabState extends State<PosTab> with SingleTickerProviderStateMixin {
  ScrollController scrollControllerAll = ScrollController();
  ScrollController scrollControllerNOAll = ScrollController();
  late TabController tabController;

  int lastTappedIndex = 0;
  ///For Elastic book search
  void _filterBooks(String query) {
    setState(() {
      posSearchString = query;
    });
  }
  List<PosBookSetModal> getPosFilteredBooks() {
    if (posSearchString.isEmpty) {
      return posBookSetVM.bookSetList;
    } else {
      return posBookSetVM.bookSetList.where((book) {
        return book.bookName != null && book.bookName!.toLowerCase().contains(posSearchString.toLowerCase());
      }).toList();
    }
  }



  Future<void> loadBookSetData() async {
    posBookSetVM.bookSetList.clear();
    getPosFilteredBooks().clear();
    posBookSetVM.isLoading.value = true;
    FocusScope.of(context).unfocus();
    posSearchController.clear();
    posSearchString = '';
    lastTappedIndex = tabController.index; // Update the last tapped index
    currentIndexPos.value = tabController.index;
    await posBookSetVM.getBookSet(
      "1",
      "500",
      "",
      posSelectedSchoolId.toString(),
      posStandardId.toString(),
      getCategoryFromIndex(currentIndexPos.value),
    );

    // Update the counter only for new keys
    controller.initialController();

    getPosFilteredBooks();

    if (getCategoryFromIndex(currentIndexPos.value) == "") {
      posOrderDetails.clear();
      for (var element in posBookSetVM.bookSetList) {
        posOrderDetails.add(OrderDetailModal(
          bookId: element.id,
          bookType: element.type,
          id: element.sellingPrice!,
          bookName: element.bookName == null ? "" : element.bookName!,
          taxRate: element.taxRate!,
        ));
      }
    }
  }
  @override
  void initState() {
    super.initState();
    posBookSetVM.isLoading.value = false;
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadBookSetData();
    });

    tabController.addListener(() {
      if (lastTappedIndex != tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await loadBookSetData();
        });
      }
    });
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final CounterController controller = Get.put(CounterController());



  Future<void> pendingDialogue(BuildContext context,int id,String bookName,String type) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          String keyToCheck = '$type-$id';
          bool? itemStatus = controller.pendingStatusList[keyToCheck];
          print(keyToCheck);
          print(controller.pendingStatusList);
          print("itemStatus$itemStatus");
          return SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: AlertDialog(
              contentPadding: const EdgeInsets.only(bottom: 2),
              titlePadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 40,
                left: MediaQuery.of(context).size.width / 40,
                bottom: MediaQuery.of(context).size.height /30,
              ),
              title: Text(
                (itemStatus == null || itemStatus == false)?'Mark as pending':"Revert Back" ,
                style: TextStyle(
                    color: const Color(0xFF5448D2),
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w600),
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height/4,
                child: Column(
                    children: [
                      SvgPicture.asset("assets/images/pos_images/pendingBooks.svg",
                        height: MediaQuery.of(context).size.height/10,),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/30,
                      ),
                      Text(bookName,
                          style: TextStyle(
                              color: const Color(0xFFFF7630),
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontWeight: FontWeight.w400))
                      ,
                      SizedBox(
                        height: MediaQuery.of(context).size.height/50,
                      ),

                      Text( (itemStatus == null || itemStatus == false)?'Are you sure to mark this $type as pending ? ':"Are you sure to revert back this changes" ,
                          style: TextStyle(
                              color: const Color(0xFF3B3B3B),
                              fontSize: MediaQuery.of(context).size.height / 45,
                              fontWeight: FontWeight.w500)),
                    ]),

              ),

              actions: <Widget>[
                Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height /15,
                              width: MediaQuery.of(context).size.width /8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                      spreadRadius: 2, // Adjust the spread radius
                                      blurRadius: 5, // Adjust the blur radius
                                      offset: const Offset(0, 3), // Adjust the offset
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height /45,
                                        fontFamily: "NotoSans",
                                        color: Colors.black),
                                  )),
                            )),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/50,
                      ),
                      GestureDetector(
                        onTap: () {
                          (itemStatus == null || itemStatus == false)?
                          controller.updatePendingStatus(id.toString(),type):
                          controller.updateAvailableStatus(id.toString(),type);
                          Get.back();
                        },
                        child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height /15,
                              width: MediaQuery.of(context).size.width /8,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF7367F0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:  Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                      spreadRadius: 2, // Adjust the spread radius
                                      blurRadius: 5, // Adjust the blur radius
                                      offset: const Offset(0, 3), // Adjust the offset
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize:
                                        MediaQuery.of(context).size.height / 50,
                                        fontFamily: "OpenSans",
                                        color: Colors.white),
                                  )),
                            )),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 45),
              ],
            ),
          );
        });
  }


  ///For Switching Tabs
  String getCategoryFromIndex(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return 'Textbook';
      case 2:
        return 'Notebook';
      case 3:
        return 'Stationery';
      default:
        return '';
    }
  }






  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                 child: Padding(
                 padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height/70,),
                      schoolNameWidget(context),
                      SizedBox(height: MediaQuery.of(context).size.height/60,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
                                  spreadRadius: 2, // Adjust the spread radius
                                  blurRadius: 5, // Adjust the blur radius
                                  offset: const Offset(0, 3), // Adjust the offset
                                ),
                              ],
                                   color: const Color(0xFFFFFFFF),
                                  borderRadius:BorderRadius.circular(10),
                                 border: Border.all(color: const Color(0xFFE0DDFC))
                               ),
                          child: Column(
                            children: [
                              Padding(
                              padding:  EdgeInsets.symmetric(
                                    vertical:MediaQuery.of(context).size.height/90,
                                    horizontal: MediaQuery.of(context).size.width/35),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height /14,
                                  child: TabBar(
                                    controller: tabController,
                                    onTap: (value){

                                    },


                                    indicatorColor: const Color(0xFF4D3FD9),
                                    unselectedLabelStyle: TextStyle(
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NotoSans",
                                        fontSize: MediaQuery.of(context).size.height /40),
                                    labelColor: const Color(0xFF4D3FD9),
                                    unselectedLabelColor: const Color(0xFF818181),
                                   labelStyle:TextStyle(
                                       color: const Color(0xFF818181),
                                       fontWeight: FontWeight.bold,
                                       fontFamily: "NotoSans",
                                       fontSize: MediaQuery.of(context).size.height /40) ,
                                    tabs: const [
                                      Tab(text: 'All'),
                                      Tab(text: 'Textbooks'),
                                      Tab(text: 'Notebook'),
                                      Tab(text: 'Stationary'),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                  padding:  EdgeInsets.symmetric(
                                      vertical: MediaQuery.of(context).size.height/50,
                                  horizontal:MediaQuery.of(context).size.width/53),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height/15,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextField(
                                            controller: posSearchController,
                                            cursorColor: Colors.black54,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "NotoSans",
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context).size.height/40
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height/160),
                                              filled: true,
                                              fillColor: const Color(0xFFF3F3F3),

                                              hintStyle:
                                                  TextStyle(
                                                    color: const Color(0xFF818181),
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: "NotoSans",
                                                    fontSize: MediaQuery.of(context).size.height /35,

                                              ),
                                              hintText: 'Search Items ',
                                              prefixIcon:  Icon(Icons.search, color: Colors.grey,size: MediaQuery.of(context).size.height/20,),
                                              suffixIcon: posSearchController.text == ""?const Text(""):GestureDetector(
                                                onTap: (){
                                                 setState(() {
                                                   posSearchController.clear();
                                                   posSearchString = '';
                                                 });
                                                },
                                                  child:  Icon(Icons.cancel_outlined,
                                                      size: MediaQuery.of(context).size.height/25,
                                                      color: Colors.redAccent)),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                borderSide: BorderSide.none
                                              ),
                                            ),
                                              onChanged: (value) {
                                              _filterBooks(value);
                                                          },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              Expanded(
                                child:
                                   Obx(
                                     ()=> TabBarView(
                                       controller: tabController,
                                      children: [
                                        allBooksView(),
                                        filteredBookView(currentIndexPos.value),
                                        filteredBookView(currentIndexPos.value),
                                        filteredBookView(currentIndexPos.value),
                                      ],
                                  ),
                                   ),

                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          );
        }
    );
  }

  ///All Books Tab view
  Widget allBooksView() {
    return Obx(()=>ModalProgressHUD(
      inAsyncCall: posBookSetVM.isLoading.value == true,
      progressIndicator:progressIndicator() ,
        color: Colors.transparent,
        child: GetBuilder<CounterController>(
          builder: (controller) {

            return Scrollbar(
              thumbVisibility: true,
              thickness: 3,
              controller: scrollControllerAll,
              child: ListView.builder(
                controller: scrollControllerAll,
                itemCount:getPosFilteredBooks().length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String id = getPosFilteredBooks()[index].id!.toString();
                  String category = getPosFilteredBooks()[index].type!;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width /60),
                    child: Column(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            setState(() {
                              int bookPendingId = getPosFilteredBooks()[index].id!;
                              String bookName = getPosFilteredBooks()[index].bookName!;
                              String bookType = getPosFilteredBooks()[index].type!;
                              pendingDialogue(context, bookPendingId,bookName,bookType);
                            });
                          },
                          child: posBookSetVM.bookSetList.isEmpty
                              ? const Text(
                            "No data Found", style: TextStyle(
                              color: Colors.black
                          ))
                              : Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 9,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity
                                    spreadRadius: 2, // Adjust the spread radius
                                    blurRadius: 5, // Adjust the blur radius
                                    offset: const Offset(0, 3), // Adjust the offset
                                  ),
                                ],
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(
                                    4),
                                border: Border.all(
                                    color: const Color(0xFFF2F2F2))
                            ),

                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 90,),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            (getPosFilteredBooks()[index]
                                                .bookName == null)
                                                ? ""
                                                :
                                            getPosFilteredBooks()[index]
                                                .bookName!,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: const Color(0xFF272727),
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.height /45,
                                              fontFamily: "NotoSans"
                                            ),
                                          ),



                                          Row(
                                            children: [
                                              Text(
                                                (posBookSetVM
                                                    .bookSetList[index]
                                                    .pulicationName ==
                                                    null) ? "" :
                                                posBookSetVM
                                                    .bookSetList[index]
                                                    .pulicationName!,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                    fontFamily: "NotoSans",
                                                  fontSize: MediaQuery.of(context).size.height /55,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 50,),
                                              Obx(() {return  controller.pendingStatusList["$category-$id"] == true?SizedBox(
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height / 50,
                                                    child: SvgPicture
                                                        .asset(
                                                        "assets/images/pos_images/pendingBooks.svg"),
                                                  ):const Text("");

                                              }),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                                Text(
                                  (posBookSetVM.bookSetList[index]
                                      .sellingPrice == null) ? "" :
                                  "₹ ${posBookSetVM.bookSetList[index].sellingPrice!.toString()}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height /45,
                                      fontFamily: "NotoSans"
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 8.5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [
                                      IconButton(onPressed: () async {
                                        setState(() {
                                          controller.decrement(id, category);

                                        });
                                      },
                                          icon: SvgPicture.asset(
                                            "assets/images/pos_images/minus.svg"
                                            , height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 20,)),
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 150,
                                      ),
                                      Obx(()=> Text('${controller.counter['$category-$id'] ?? 0}  ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: MediaQuery.of(context).size.height /45,
                                          fontFamily: "NotoSans"
                                      ),)),
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 150,
                                      ),
                                      IconButton(onPressed: () {
                                        setState(() {
                                          controller.increment(id, category);

                                        });
                                      },
                                          icon: SvgPicture.asset(
                                            "assets/images/pos_images/plus.svg"
                                            , height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 20,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height / 50,)
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  ///Particular Books Tab view
  Widget filteredBookView(int tabIndex) {
    String category = getCategoryFromIndex(tabIndex);
    return
      Obx(() {
        return ModalProgressHUD(
            inAsyncCall: posBookSetVM.isLoading.value == true,
            color: Colors.transparent,
            dismissible: true,
            progressIndicator:progressIndicator() ,
            child: GetBuilder<CounterController>(
              builder: (controller) {
                return Scrollbar(
                  thumbVisibility: true,
                  thickness: 2,
                  controller: scrollControllerNOAll,
                  child: ListView.builder(
                    controller: scrollControllerNOAll,
                    scrollDirection: Axis.vertical,
                    itemCount: getPosFilteredBooks().length,
                    itemBuilder: (context, i) {
                      String id = getPosFilteredBooks()[i].id!.toString();
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery
                                .of(context)
                                .size
                                .width /60),
                        child: Column(
                          children: [
                            GestureDetector(
                              onLongPress: (){
                                setState(() {
                                  int bookPendingId = getPosFilteredBooks()[i].id!;
                                  String bookName = getPosFilteredBooks()[i].bookName!;
                                  String bookType = getPosFilteredBooks()[i].type!;
                                  pendingDialogue(context, bookPendingId,bookName,bookType);
                                });
                              },

                              child: posBookSetVM.bookSetList.isEmpty
                                  ? const Text(
                                "No data Found", style: TextStyle(
                                  color: Colors.black
                              ),)
                                  : Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 9,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 3),
                                          blurRadius: 6)
                                    ],
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(
                                        4),
                                    border: Border.all(
                                        color: const Color(0xFFF2F2F2))
                                ),

                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 90,),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                (getPosFilteredBooks()[i]
                                                    .bookName == null)
                                                    ? ""
                                                    :
                                                getPosFilteredBooks()[i]
                                                    .bookName!,
                                                softWrap: true,
                                                style:TextStyle(
                                                    color: const Color(0xFF272727),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.height /45,
                                                    fontFamily: "NotoSans"
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 80,),

                                              Row(
                                                children: [
                                                  Text(
                                                    (posBookSetVM
                                                        .bookSetList[i]
                                                        .pulicationName ==
                                                        null) ? "" :
                                                    posBookSetVM
                                                        .bookSetList[i]
                                                        .pulicationName!,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: MediaQuery.of(context).size.height /55,
                                                        fontFamily: "NotoSans"
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width / 50,),

                                                  Obx(() {
                                                    return  controller.pendingStatusList["$category-$id"] == true?SizedBox(
                                                      height: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height / 50,
                                                      child: SvgPicture
                                                          .asset(
                                                          "assets/images/pos_images/pendingBooks.svg"),
                                                    ):const Text("");

                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),


                                    Text(
                                      (posBookSetVM.bookSetList[i]
                                          .sellingPrice == null) ? "" :
                                      "₹ ${posBookSetVM.bookSetList[i].sellingPrice!.toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.height /45,
                                          fontFamily: "NotoSans"
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 8.5,
                                      color: Colors.grey.shade200,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: [
                                          IconButton(onPressed: () async {
                                            setState(() {
                                              controller.decrement(id, category);
                                            });
                                          },
                                              icon: SvgPicture.asset(
                                                "assets/images/pos_images/minus.svg"
                                                , height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height / 20,)),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width / 150,
                                          ),
                                          Obx(()=> Text('${controller.counter['$category-$id'] ??  0} ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context).size.height /45,
                                              fontFamily: "NotoSans"
                                          ),)),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width / 150,
                                          ),
                                          IconButton(onPressed: () {
                                            setState(() {
                                              controller.increment(id, category);
                                            });
                                          },
                                              icon: SvgPicture.asset(
                                                "assets/images/pos_images/plus.svg"
                                                , height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height / 20,))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery
                                .of(context)
                                .size
                                .height / 50,)
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
      });

  }
}
