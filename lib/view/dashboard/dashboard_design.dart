import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view_modal/dashboard_vm/bargraph_vm.dart';
import '../../view_modal/dashboard_vm/dashboard_data_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_division_dropdown_vm.dart';
import '../../view_modal/dashboard_vm/dashboardSchoolVm.dart';
import '../../view_modal/dashboard_vm/dashboard_standard_vm.dart';
import '../../view_modal/pos_view_modal/standard_vm.dart';
import '../../view_modal/profile/profile_vm.dart';
import '../common_widgets/progress_indicator.dart';
import '../common_widgets/snack_bar.dart';
import '../point_of_sale/pos_design.dart';
import 'bar-graph.dart';
import 'dashboard_widgets.dart';

final DashboardDataVm dashboardDataVm = Get.put(DashboardDataVm());
final BarGraphVM barGraphVM = Get.put(BarGraphVM());
final DashboardSchoolByUserVM getDashboardSchoolVM = Get.put(DashboardSchoolByUserVM());
final dashboardStandardVM = Get.put(DashboardStandardVM());
int dashboardSelectedFilter = 1;


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ProfileVM profileVM =Get.put(ProfileVM());
  DateTime? fromDate;
  DateTime? toDate;
  var dashboardSelectedSchool = ''.obs;
  var dashboardSelectedStandard = ''.obs;
  var dashboardSelectedDivision = ''.obs;
  final dashboardDivisionVM = Get.put(OrderHistorySchoolDivisionVm());
  bool isCustomDateSelected = false;
  TextEditingController dashboardFromToDateController = TextEditingController();
  List<Color> colorList = const [
    Color(0xFF77658B),
    Color(0xFFEF994B),
    Color(0xFF46A6EA),
    Color(0xFFf69697),
  ];

  final TextEditingController fromController = TextEditingController();
  Rx<DateTime?> calendarFromDate = DateTime.now().obs; // Initialize with current date
  Rx<DateTime?> calendarToDate = DateTime.now().obs; // Initialize with current date




  Future<void> customDate(BuildContext context) async {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: const Color(0xFF5448D2),
      weekdayLabelTextStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.height / 40,
        fontFamily: "NotoSans",
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(
              bottom: 2,
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              color: const Color(0xFFE7E5FF),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 40,
                        left: MediaQuery.of(context).size.width / 40,
                        bottom: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.width / 40),
                    child: Row(
                      children: [
                        Text(
                          'Calendar',
                          style: TextStyle(
                              color: const Color(0xFF5448D2),
                              fontSize: MediaQuery.of(context).size.height / 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSans"),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Get.back();
                              });

                            },
                            child: const Icon(Icons.cancel_outlined,
                                color: Colors.redAccent))
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2.9,
              height: MediaQuery.of(context).size.height / 1.4,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.9,
                height: MediaQuery.of(context).size.height / 1.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.7,
                      height: MediaQuery.of(context).size.height /1.7,
                      child: Obx(
                          ()=> CalendarDatePicker2(
                            config: config,
                            value: [calendarFromDate.value, calendarToDate.value],

                            onValueChanged: (dates) {
                              setState(() {
                                if (dates.isNotEmpty && dates.length == 2) {
                                  if (dates[1]!.isBefore(dates[0]!)) {
                                    calendarToDate.value = calendarFromDate.value;
                                  } else {
                                    calendarFromDate.value = dates[0]!;
                                    calendarToDate.value = dates[1]!;
                                  }
                                }
                              });
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 50,
                        right: MediaQuery.of(context).size.width / 50,
                        bottom: MediaQuery.of(context).size.height / 30,

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                calendarFromDate.value = DateTime.now();
                                calendarToDate.value = DateTime.now();



                              });
                              setState(() {

                              });

                            },
                            child: Center(
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  width: MediaQuery.of(context).size.width / 8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          // Adjust shadow color and opacity
                                          spreadRadius: 2,
                                          // Adjust the spread radius
                                          blurRadius: 5,
                                          // Adjust the blur radius
                                          offset: const Offset(0, 3), // Adjust the offset
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                        "Clear",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height / 50,
                                            fontFamily: "NotoSans",
                                            color: Colors.black),
                                      )),
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                apiFromDate = DateFormat('yyyy-MM-dd').format(calendarFromDate.value!);
                                apiToDate = DateFormat('yyyy-MM-dd').format(calendarToDate.value!);
                                String fromDateTitle = DateFormat('d MMM y').format(calendarFromDate.value!);
                                String toDateTitle = DateFormat('d MMM y').format(calendarToDate.value!);
                                dateTitleData = "$fromDateTitle to $toDateTitle";
                                dashboardApiIntegration("0", "0", "0", apiFromDate!, apiToDate!);
                                Get.back();
                              });
                            },
                            child: Center(
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  width: MediaQuery.of(context).size.width / 8,
                                  decoration: BoxDecoration(

                                    ///confirm
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          // Adjust shadow color and opacity
                                          spreadRadius: 2,
                                          // Adjust the spread radius
                                          blurRadius: 5,
                                          // Adjust the blur radius
                                          offset: const Offset(0, 3), // Adjust the offset
                                        ),
                                      ],
                                      color: const Color(0xFF7367F0),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height / 50,
                                            fontFamily: "OpenSans",
                                            color: Colors.white),
                                      )),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  String? dateTitleData;
  String? apiFromDate;
  String? apiToDate;

  dashboardApiIntegration(String schoolId, String stdId, String divId,
      String fromdate, String todate) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dashboardDataVm.dashboardDatavmList.clear();
    dashboardDataVm.isLoading.value = true;
    await dashboardDataVm.getDashboardDataVm(pref.getInt('userId').toString(), schoolId, stdId, divId, fromdate, todate);
    barGraphVM.barDataList.clear();
    barGraphVM.isLoading.value = true;
    await barGraphVM.getBarGraphData(pref.getInt('userId').toString(),fromdate, todate,schoolId, stdId, divId);
    seriesList = createRandomData();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    dashboardStandardVM.dashboardStandardList.clear();
    dashboardStandardVM.isLoading.value = true;
    getDashboardSchoolVM.dashboardSchoolDetailList.clear();
    getDashboardSchoolVM.isLoading.value = true;
    dashboardSelectedFilter=1;
    DateTime currentDate = DateTime.now();
    calendarFromDate.value = DateTime.now();
    calendarToDate.value = DateTime.now();
    DateTime firstDateOfMonth =
        DateTime(currentDate.year, currentDate.month, 1);
    apiFromDate = DateFormat('yyyy-MM-dd').format(firstDateOfMonth);
    apiToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dashboardApiIntegration("0", "0", "0", apiFromDate!, apiToDate!);
    String fromDateTitle = DateFormat('d MMM y').format(firstDateOfMonth);
    String toDateTitle = DateFormat('d MMM y').format(currentDate);
    dateTitleData = "$fromDateTitle to $toDateTitle";
    isCustomDateSelected = false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F6),
      endDrawer: GestureDetector(
        onHorizontalDragUpdate: (details) {
          print(details);
        },
        child: Obx(
          ()=> (getDashboardSchoolVM.isLoading.value == true)?CircularProgressIndicator(color: Colors.transparent,) :
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 40,
                  vertical: MediaQuery.of(context).size.height / 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.redAccent,
                              size: MediaQuery.of(context).size.height / 20,
                            ))
                      ],
                    ),
                  ),

                  ///Select School drawer dropdown
                  Text(
                    "Select School",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 35,
                        fontFamily: "NatoSans",
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Obx(
                    () => getDashboardSchoolVM.isLoading.value == true
                        ? const Text("")
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                "Select School",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    fontFamily: "NatoSans",
                                    color: const Color(0xFF3B3B3B),
                                    fontWeight: FontWeight.w400),
                              ),
                              items: getDashboardSchoolVM.dashboardSchoolDetailList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(item.schools.toString(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40,
                                                fontFamily: "NatoSans",
                                                color: (dashboardSelectedSchool
                                                            .value ==
                                                        "")
                                                    ? Colors.black
                                                    : const Color(0xFF4D3FD9),
                                                fontWeight: FontWeight.w600)),
                                      ))
                                  .toList(),
                              value: dashboardSelectedSchool.value == '' ? null : dashboardSelectedSchool.value,
                              onChanged: (String? value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) async {
                                  dashboardSelectedSchool.value = value!;
                                  dashboardSelectedStandard.value = '';
                                  dashboardSelectedDivision.value = '';
                                  dashboardDivisionVM.ohSchoolDivisionDropListVm.clear();
                                  dashboardDivisionVM.isLoading.value = true;

                                  dashboardStandardVM.dashboardStandardList.clear();
                                  dashboardStandardVM.isLoading.value = true;

                                  await dashboardStandardVM.getDashboardStandardInfo(int.parse(dashboardSelectedSchool.value));
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: (dashboardSelectedSchool.value == "")
                                            ? CupertinoColors.black
                                            : const Color(0xFF7367F0))),
                                height: MediaQuery.of(context).size.height / 14,
                                width: MediaQuery.of(context).size.width / 2.5,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2.5,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black87, width: 1.5))),
                              menuItemStyleData: MenuItemStyleData(
                                height: MediaQuery.of(context).size.height / 15,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),

                  ///Select Standard drawer dropdown
                  Text(
                    "Select Standard",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 35,
                        fontFamily: "NatoSans",
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Obx(
                    () => dashboardStandardVM.isLoading.value == true
                        ? Container(
                            height: MediaQuery.of(context).size.height / 14,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width / 52),
                            margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width / 200),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              children: [
                                Text(
                                  "Select standard",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height / 40,
                                      fontFamily: "NatoSans",
                                      color: const Color(0xFF3B3B3B),
                                      fontWeight: FontWeight.w400),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                "Select Standard",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    fontFamily: "NatoSans",
                                    color: const Color(0xFF3B3B3B),
                                    fontWeight: FontWeight.w400),
                              ),
                              items: dashboardStandardVM.dashboardStandardList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(item.text.toString(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40,
                                                fontFamily: "NatoSans",
                                                color: (dashboardSelectedStandard
                                                            .value ==
                                                        "")
                                                    ? Colors.black
                                                    : const Color(0xFF4D3FD9),
                                                fontWeight: FontWeight.w600)),
                                      ))
                                  .toList(),
                              value: dashboardSelectedStandard.value == ''
                                  ? null
                                  : dashboardSelectedStandard.value,
                              onChanged: (String? value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) async {
                                  dashboardSelectedStandard.value = value!;
                                  dashboardSelectedDivision.value = '';
                                  dashboardDivisionVM.ohSchoolDivisionDropListVm
                                      .clear();
                                  dashboardDivisionVM.isLoading.value = true;
                                  await dashboardDivisionVM
                                      .getOhSchoolDivisionDropdown(int.parse(
                                          dashboardSelectedStandard.value));
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color:
                                            (dashboardSelectedStandard.value == "")
                                                ? CupertinoColors.black
                                                : const Color(0xFF7367F0))),
                                height: MediaQuery.of(context).size.height / 14,
                                width: MediaQuery.of(context).size.width / 2.5,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2.5,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black87, width: 1.5))),
                              menuItemStyleData: MenuItemStyleData(
                                height: MediaQuery.of(context).size.height / 15,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),

                  ///Select Division drawer dropdown
                  Text(
                    "Select Division",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 35,
                        fontFamily: "NatoSans",
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Obx(
                    () => dashboardDivisionVM.isLoading.value == true
                        ? Container(
                            height: MediaQuery.of(context).size.height / 14,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width / 52),
                            margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width / 200),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              children: [
                                Text(
                                  "Select division",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height / 40,
                                      fontFamily: "NatoSans",
                                      color: const Color(0xFF3B3B3B),
                                      fontWeight: FontWeight.w400),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                "Select division",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    fontFamily: "NatoSans",
                                    color: const Color(0xFF3B3B3B),
                                    fontWeight: FontWeight.w400),
                              ),
                              items: dashboardDivisionVM.ohSchoolDivisionDropListVm
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(item.text.toString(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40,
                                                fontFamily: "NatoSans",
                                                color: (dashboardSelectedDivision
                                                            .value ==
                                                        "")
                                                    ? Colors.black
                                                    : const Color(0xFF4D3FD9),
                                                fontWeight: FontWeight.w600)),
                                      ))
                                  .toList(),
                              value: dashboardSelectedDivision.value == ''
                                  ? null
                                  : dashboardSelectedDivision.value,
                              onChanged: (String? value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) async {
                                  selectedItemId = -1;
                                  dashboardSelectedDivision.value = value!;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color:
                                            (dashboardSelectedDivision.value == "")
                                                ? CupertinoColors.black
                                                : const Color(0xFF7367F0))),
                                height: MediaQuery.of(context).size.height / 14,
                                width: MediaQuery.of(context).size.width / 2.5,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2.5,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black87, width: 1.5))),
                              menuItemStyleData: MenuItemStyleData(
                                height: MediaQuery.of(context).size.height / 15,
                              ),
                            ),
                          ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                getDashboardSchoolVM.dashboardSchoolDetailList.clear();
                                getDashboardSchoolVM.isLoading.value = true;
                                dashboardSelectedSchool.value = "";
                                dashboardSelectedStandard.value = "";
                                dashboardSelectedDivision.value = "";
                                dashboardStandardVM.dashboardStandardList.clear;
                                dashboardStandardVM.isLoading.value = true;
                                dashboardDivisionVM.ohSchoolDivisionDropListVm.clear();
                                dashboardDivisionVM.isLoading.value = true;
                                dashboardDivisionVM.ohSchoolDivisionDropListVm.clear();
                                dashboardDivisionVM.isLoading.value = true;
                                await getDashboardSchoolVM.getDashboardSchoolByUser(pref.getInt("userId").toString());
                                  calendarFromDate.value = DateTime.now();
                                  calendarToDate.value = DateTime.now();
                                  dashboardSelectedFilter = 1;
                                  DateTime currentDate = DateTime.now();
                                  DateTime firstDateOfMonth = DateTime(currentDate.year, currentDate.month, 1);
                                  apiFromDate = DateFormat('yyyy-MM-dd').format(firstDateOfMonth);
                                  apiToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                  dashboardApiIntegration("0", "0", "0", apiFromDate!, apiToDate!);
                                  String fromDateTitle = DateFormat('d MMM y').format(firstDateOfMonth);
                                  String toDateTitle = DateFormat('d MMM y').format(currentDate);
                                  dateTitleData = "$fromDateTitle to $toDateTitle";
                                  isCustomDateSelected = false;
                                });
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
                                    "Clear",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                        MediaQuery.of(context).size.height /40,
                                        fontFamily: "NotoSans",
                                        color:   Colors.black54),
                                  )),
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if(dashboardSelectedSchool.value == "") {
                            toastMessage(context, "Please select school");
                          }else if (dashboardSelectedStandard.value == ""){
                            toastMessage(context, "Please select standard");
                          }
                          else if( dashboardSelectedDivision.value == ""){
                            toastMessage(context, "Please select division");
                          }
                          else {
                            dashboardApiIntegration(dashboardSelectedSchool.value,
                                dashboardSelectedStandard.value,
                                dashboardSelectedDivision.value, apiFromDate!,
                                apiToDate!);
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString("standardId", dashboardSelectedStandard.value);
                            pref.setString("schoolId", dashboardSelectedSchool.value);
                            pref.setString("divisionId", dashboardSelectedDivision.value);

                            Get.back();
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height /15,
                          width: MediaQuery.of(context).size.width /8,
                          decoration: BoxDecoration(
                              color: const Color(0xFF7367F0),
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
                                "Apply",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    MediaQuery.of(context).size.height /40,
                                    fontFamily: "NotoSans",
                                    color: Colors.white),
                              )),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/60,)
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: dashboardDataVm.isLoading.value == true || barGraphVM.isLoading.value == true,
          progressIndicator: progressIndicator(),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 80,
                horizontal: MediaQuery.of(context).size.width / 80,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height /6,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
                            spreadRadius: 2, // Adjust the spread radius
                            blurRadius: 5, // Adjust the blur radius
                            offset: const Offset(0, 3), // Adjust the offset
                          ),
                        ],

                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 100),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/120),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/90),
                                    child: Text(dateTitleData!,
                                        style: TextStyle(
                                            color: const Color(0xFF5448D2),
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .height /
                                                40,
                                            fontFamily: "NotoSans")),
                                  ),

                                  ///Drawer Coding
                                  Builder(
                                    builder: (BuildContext context) =>
                                        InkWell(
                                          onTap: () async {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (timeStamp) async {
                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  getDashboardSchoolVM.dashboardSchoolDetailList.clear();
                                                  getDashboardSchoolVM.isLoading.value = true;
                                                  await getDashboardSchoolVM.getDashboardSchoolByUser(pref.getInt("userId").toString());

                                                 if( dashboardSelectedSchool.value != ''){
                                                  dashboardSelectedSchool.value = pref.getString("schoolId") ?? '';
                                                  dashboardSelectedDivision.value = pref.getString("divisionId") ?? '';
                                                  dashboardSelectedStandard.value = pref.getString("standardId") ?? '';
                                                  dashboardStandardVM.dashboardStandardList.clear();
                                                  dashboardStandardVM.isLoading.value = true;
                                                  await dashboardStandardVM.getDashboardStandardInfo(int.parse(dashboardSelectedSchool.value));
                                                  dashboardDivisionVM.ohSchoolDivisionDropListVm
                                                      .clear();
                                                  dashboardDivisionVM.isLoading.value = true;
                                                  await dashboardDivisionVM
                                                      .getOhSchoolDivisionDropdown(int.parse(
                                                      dashboardSelectedStandard.value));
                                                 }

                                                  Scaffold.of(context).openEndDrawer();
                                                });
                                          },
                                          child: Padding(
                                            padding:  EdgeInsets.only(bottom:MediaQuery.of(context).size.height/150),
                                            child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    32,
                                                backgroundColor:
                                                const Color(0xFFE0DDFC),
                                                child: SvgPicture.asset(
                                                  "assets/images/dashboard_img/filter_icon.svg",
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /35,
                                                )),
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1,color: Colors.grey,),
                             SizedBox(
                               height: MediaQuery.of(context).size.height /80),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 17,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context)
                                            .size
                                            .height /
                                        18,
                                    width: MediaQuery.of(context)
                                            .size
                                            .width /
                                        7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: dashboardSelectedFilter == 1
                                              ? const Color(0xFFFF7630)
                                              : const Color(
                                                  0xFF5448D2)),
                                      color: dashboardSelectedFilter == 1
                                          ? const Color(0xFFFFECE4)
                                          : Colors.white,
                                      // This line has been modified
                                      borderRadius:
                                          const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          calendarFromDate.value = DateTime.now();
                                          calendarToDate.value = DateTime.now();
                                          dashboardSelectedFilter = 1;
                                          DateTime currentDate = DateTime.now();
                                          DateTime firstDateOfMonth = DateTime(currentDate.year, currentDate.month, 1);
                                          apiFromDate = DateFormat('yyyy-MM-dd').format(firstDateOfMonth);
                                          apiToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                          dashboardApiIntegration("0", "0", "0", apiFromDate!, apiToDate!);
                                          String fromDateTitle = DateFormat('d MMM y').format(firstDateOfMonth);
                                          String toDateTitle = DateFormat('d MMM y').format(currentDate);
                                          dateTitleData = "$fromDateTitle to $toDateTitle";
                                          isCustomDateSelected = false;
                                        });

                                      },
                                      child: Center(
                                          child: Text('This Month',
                                              style: TextStyle(
                                                  fontFamily: "NotoSans",
                                                  color: Colors.black,
                                                  fontWeight: dashboardSelectedFilter == 1?FontWeight.w600:FontWeight.w400,
                                                  fontSize: dashboardSelectedFilter == 1?MediaQuery.of(context).size.height /42:MediaQuery.of(context).size.height /40)
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context)
                                            .size
                                            .height /
                                        18,
                                    width: MediaQuery.of(context)
                                            .size
                                            .width /
                                        7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: dashboardSelectedFilter == 2
                                              ? const Color(0xFFFF7630)
                                              : const Color(
                                                  0xFF5448D2)),
                                      color: dashboardSelectedFilter == 2
                                          ? const Color(0xFFFFECE4)
                                          : Colors.white,
                                      // This line has been modified
                                      borderRadius:
                                          const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          calendarFromDate.value = DateTime.now();
                                          calendarToDate.value = DateTime.now();
                                          dashboardSelectedFilter = 2;
                                          isCustomDateSelected = false;
                                          DateTime currentDate = DateTime.now();
                                          DateTime firstDateOfPreviousMonth = DateTime(currentDate.year, currentDate.month - 1, 1);
                                          DateTime lastDateOfPreviousMonth = DateTime(currentDate.year, currentDate.month, 0);
                                          apiFromDate = DateFormat('yyyy-MM-dd').format(firstDateOfPreviousMonth);
                                          apiToDate = DateFormat('yyyy-MM-dd').format(lastDateOfPreviousMonth);
                                          dashboardApiIntegration(
                                              "0",
                                              "0",
                                              "0",
                                              apiFromDate!,
                                              apiToDate!);
                                          String fromDateTitle =
                                              DateFormat('d MMM y').format(
                                                  firstDateOfPreviousMonth);
                                          String toDateTitle = DateFormat(
                                                  'd MMM y')
                                              .format(
                                                  lastDateOfPreviousMonth);
                                          dateTitleData =
                                              "$fromDateTitle to $toDateTitle";
                                        });
                                      },
                                      child: Center(
                                          child: Text('Last Month',
                                              style: TextStyle(
                                                  fontFamily: "NotoSans",
                                                  fontWeight: dashboardSelectedFilter == 2?FontWeight.w600:FontWeight.w400,
                                                  fontSize: dashboardSelectedFilter == 2?MediaQuery.of(context).size.height /42:MediaQuery.of(context).size.height /40)
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context)
                                            .size
                                            .height /
                                        18,
                                    width: MediaQuery.of(context)
                                            .size
                                            .width /
                                        7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: dashboardSelectedFilter == 3
                                              ? const Color(0xFFFF7630)
                                              : const Color(
                                                  0xFF5448D2)),
                                      color: dashboardSelectedFilter == 3
                                          ? const Color(0xFFFFECE4)
                                          : Colors.white,
                                      // This line has been modified
                                      borderRadius:
                                          const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          calendarFromDate.value = DateTime.now();
                                          calendarToDate.value = DateTime.now();
                                          dashboardSelectedFilter = 3;
                                          isCustomDateSelected = false;
                                          final now = DateTime.now();
                                          final currentQuarter =
                                              (now.month - 1) ~/ 3;
                                          final startMonth =
                                              currentQuarter * 3 + 1;
                                          final firstDayOfQuarter =
                                              DateTime(now.year,
                                                  startMonth, 1);
                                          final lastDayOfQuarter =
                                              DateTime.now();
                                          final DateFormat formatter =
                                              DateFormat('yyyy-MM-dd');
                                          apiToDate = formatter
                                              .format(lastDayOfQuarter);
                                          apiFromDate =
                                              formatter.format(
                                                  firstDayOfQuarter);
                                          dashboardApiIntegration(
                                              "0",
                                              "0",
                                              "0",
                                              apiFromDate!,
                                              apiToDate!,);
                                          String fromDateTitle =
                                              DateFormat('d MMM y')
                                                  .format(
                                                      firstDayOfQuarter);
                                          String toDateTitle =
                                              DateFormat('d MMM y')
                                                  .format(
                                                      lastDayOfQuarter);
                                          dateTitleData =
                                              "$fromDateTitle to $toDateTitle";
                                        });
                                      },
                                      child: Center(
                                          child: Text('This Quarter',
                                              style: TextStyle(
                                                  fontFamily:
                                                      "NotoSans",
                                                  fontWeight: dashboardSelectedFilter == 3?FontWeight.w600:FontWeight.w400,
                                                  fontSize: dashboardSelectedFilter == 3?MediaQuery.of(context).size.height /42:MediaQuery.of(context).size.height /40)
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height / 18,
                                    width: MediaQuery.of(context).size.width / 7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: dashboardSelectedFilter == 4
                                              ? const Color(0xFFFF7630)
                                              : const Color(
                                                  0xFF5448D2)),
                                      color: dashboardSelectedFilter == 4
                                          ? const Color(0xFFFFECE4)
                                          : Colors.white,
                                      borderRadius:
                                          const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          dashboardSelectedFilter = 4;
                                          isCustomDateSelected = false;
                                          calendarFromDate.value = DateTime.now();
                                          calendarToDate.value = DateTime.now();
                                          final now = DateTime.now();
                                          final currentQuarter = (now.month - 1) ~/ 3; // Determine the current quarter (0, 1, 2, 3).
                                          final endMonthOfPreviousQuarter = currentQuarter * 3;
                                          final startMonthOfPreviousQuarter = endMonthOfPreviousQuarter - 2;
                                          final firstDayOfPreviousQuarter = DateTime(now.year, startMonthOfPreviousQuarter, 1);
                                          final lastDayOfPreviousQuarter = DateTime(now.year, endMonthOfPreviousQuarter + 1, 0);
                                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                          apiFromDate = formatter.format(firstDayOfPreviousQuarter);
                                          apiToDate = formatter.format(lastDayOfPreviousQuarter);
                                          dashboardApiIntegration("0", "0", "0", apiFromDate!, apiToDate!);
                                          String fromDateTitle = DateFormat('d MMM y').format(firstDayOfPreviousQuarter);
                                          String toDateTitle = DateFormat('d MMM y').format(lastDayOfPreviousQuarter);
                                          dateTitleData = "$fromDateTitle to $toDateTitle";
                                        });
                                      },
                                      child: Center(
                                          child: Text('Last Quarter',
                                              style: TextStyle(
                                                  fontFamily: "NotoSans",
                                                  fontWeight: dashboardSelectedFilter == 4?FontWeight.w600:FontWeight.w400,
                                                  fontSize: dashboardSelectedFilter == 4?MediaQuery.of(context).size.height /42:MediaQuery.of(context).size.height /40)
                                          )))),
                                  Row(
                                    mainAxisAlignment: isCustomDateSelected == true ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
                                    children: [
                                      isCustomDateSelected == false
                                          ? SizedBox(
                                        width: MediaQuery.of(context).size.width / 70)
                                          : const SizedBox(
                                        width: 0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            dashboardSelectedFilter = 5;
                                            isCustomDateSelected = true;
                                            customDate(context);
                                          });
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context).size.height / 18,
                                          width: MediaQuery.of(context).size.width / 6.4,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: dashboardSelectedFilter == 5 ? const Color(0xFFFF7630) : const Color(0xFF5448D2)),
                                            color: dashboardSelectedFilter == 5 ? const Color(0xFFFFECE4) : Colors.white,
                                            // This line has been modified
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 9,
                                                child: Center(
                                                  child: Text('Custom Date',
                                                      style: TextStyle(
                                                          fontFamily: "NotoSans",
                                                          fontWeight: dashboardSelectedFilter == 5?FontWeight.w600:FontWeight.w400,
                                                          fontSize: dashboardSelectedFilter == 5?MediaQuery.of(context).size.height /42:MediaQuery.of(context).size.height /40)),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                      height: MediaQuery.of(context).size.height / 18,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color: Color(0xFFE0DDFC),
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomLeft: Radius.circular(5))),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: MediaQuery.of(context).size.width / 250,
                                                            vertical: MediaQuery.of(context).size.height / 250),
                                                        child: SvgPicture.asset("assets/images/order_history_images/calendar.svg"))))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height /50),
                      child: SingleChildScrollView(clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            totalCountDashboard(
                                context,
                                "Total Sale",
                                "₹ ${(totalSale == 0.0 || totalSale == null)?"0.0":
                                NumberFormat('#,##0.00', 'en_US').format(totalSale)}",
                                "assets/images/dashboard_img/totalSale_icon.svg",
                                const Color(0xFF4D3FD9)),
                            SizedBox(width: MediaQuery.of(context).size.width/62),
                            totalCountDashboard(
                                context,
                                "Total Profit",
                                "₹ ${(totalProfit == 0.0 || totalProfit == null)?"0.0":
                                    NumberFormat('#,##0.00', 'en_US').format(totalProfit)}",
                                "assets/images/dashboard_img/totalProfit_icon.svg",
                                const Color(0xFF37B2FF)),
                            SizedBox(width: MediaQuery.of(context).size.width/62),
                            totalCountDashboard(
                                context,
                                "Avg Sales Value",
                                "₹ ${(avgSaleValue == 0.0 || avgSaleValue == null)?"0.0":
                                NumberFormat('#,##0.00', 'en_US').format(avgSaleValue)}",
                                "assets/images/dashboard_img/average_icon.svg",
                                // const Color(0xFFFF7630)),
                                const Color(0xff318A58)),
                            SizedBox(width: MediaQuery.of(context).size.width/62),
                            totalCountDashboard(
                                context,
                                "Total Transactions",
                                (totalTransactions == 0.0 || totalTransactions == null)?"0.0":
                                NumberFormat('#,##0.##', 'en_US').format(totalTransactions),
                                "assets/images/dashboard_img/transaction_icon.svg",
                                const Color(0xFFFF346F)),
                            SizedBox(width: MediaQuery.of(context).size.width/62),
                            totalCountDashboard(
                                context,
                                "Cancelled Amount",
                                "₹ ${(totalCancleOrderAmount == 0.0 || totalCancleOrderAmount == null)?"0.0":
                                NumberFormat('#,##0.##', 'en_US').format(totalCancleOrderAmount)}",
                                "assets/images/dashboard_img/cancelled amount.svg",
                                // const Color(0xFFed1b24)),
                                const Color(0xFFFF3434)),
                            SizedBox(width: MediaQuery.of(context).size.width/62),
                            totalCountDashboard(
                                context,
                                "Total Cancellations",
                                (totalCancleOrder == 0.0 || totalCancleOrder == null)?"0.0":
                                NumberFormat('#,##0.##', 'en_US').format(totalCancleOrder),
                                "assets/images/dashboard_img/Cancellation.svg",
                                // const Color(0xFFD2042D)),
                                const Color(0xFFFF6230)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.1,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          ///Container for pie chart
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.1,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
                                      spreadRadius: 2, // Adjust the spread radius
                                      blurRadius: 5, // Adjust the blur radius
                                      offset: const Offset(0, 3), // Adjust the offset
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(15),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                80),
                                    child: Text(
                                      'Payment Details',
                                      style: TextStyle(
                                          color:  Colors.black,
                                          fontSize: MediaQuery.of(context).size.height /35,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "NotoSans"),
                                    ),
                                  ),
                                  PieChart(
                                    dataMap: {
                                      "Cash": totalCash == null ? 0.0 : totalCash!,
                                      "UPI": totalUpi == null ? 0.0 : totalUpi!,
                                      "Card": totalCard == null ? 0.0 : totalCard!,
                                      "Other": totalOtherPayment == null ? 0.0 : totalOtherPayment!,
                                    },
                                    animationDuration:
                                        const Duration(milliseconds: 800),
                                    chartLegendSpacing:
                                        MediaQuery.of(context).size.height / 15,
                                    chartRadius:
                                        MediaQuery.of(context).size.height / 4,
                                    colorList: colorList,
                                    initialAngleInDegree: 0,
                                    chartType: ChartType.ring,
                                    ringStrokeWidth:
                                        MediaQuery.of(context).size.height / 20,
                                    legendOptions: const LegendOptions(
                                      showLegendsInRow: true,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      legendShape: BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    formatChartValues:(double value) {
                                      return '\u20B9 ${value.toStringAsFixed(1)}'; // Rupee symbol: \u20B9
                                    },
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: false,
                                      showChartValuesOutside: true,

                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 55),
                          ///Container for bar chart
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.1,
                              decoration:  BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3), // Adjust shadow color and opacity
                                      spreadRadius: 2, // Adjust the spread radius
                                      blurRadius: 5, // Adjust the blur radius
                                      offset: const Offset(0, 3), // Adjust the offset
                                    ),
                                  ],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(15))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width / 80),
                                    child: Text(
                                      'Sales Progress',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              35,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "NotoSans"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.height / 60),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'Sales  (₹)',
                                              style: TextStyle(
                                                  color: const Color(0xFF5448D2),
                                                  fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      50,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "NotoSans"),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 15,
                                          child: SizedBox(
                                              height: MediaQuery.of(context).size.height / 2.9,
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                child:SizedBox(
                                                  height: MediaQuery.of(context).size.height / 2.9,
                                                  width: MediaQuery.of(context).size.width/2.4,
                                                  child:  barChart(context) ,
                                              )
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Center(
                                      child: Text(barGraphVM.barLabelName ?? '' ,
                                        style: TextStyle(
                                            color: const Color(0xFF5448D2),
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .height /55,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "NotoSans"),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
