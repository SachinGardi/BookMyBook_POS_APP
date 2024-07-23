import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuck_shop/view/reports/pending_books.dart';
import 'package:tuck_shop/view/reports/salesByschool_Listview_switcher.dart';
import 'package:tuck_shop/view/reports/sales_by_school.dart';
import 'package:tuck_shop/view/reports/transaction_history.dart';
import '../../view_modal/order_history_view_modal/order_history_school_division_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_school_standard_dropdown_vm.dart';
import '../../view_modal/order_history_view_modal/order_history_timer_filter_vm.dart';
import '../../view_modal/reports/transaction_historyVm.dart';
import '../common_widgets/progress_indicator.dart';


final TransactionHistoryVm transactionHistoryVm = Get.put(TransactionHistoryVm());
int reportsSelectedIndex = 0;
class ReportsPage extends StatefulWidget {

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with SingleTickerProviderStateMixin {

  String? selectedSchool;
  int? selectedSchoolId;
  String? selectedStd;
  int? selectedStdId;
  String? selectedDiv;
  int? selectedDivId;
  String? selectedTime;
  int? timeId;
  TextEditingController transactionController = TextEditingController();
  final orderHistorySchoolDropdownVM = Get.put(OrderHistorySchoolDropdownVM());
  final orderHistorySchoolStandardDropdownVM = Get.put( OrderHistorySchoolStandardDropdownVM());
  final orderHistorySchoolDivisionVm = Get.put(OrderHistorySchoolDivisionVm());
  final orderHistoryTimerFilterVm = Get.put(OrderHistoryTimerFilterVm());
  final GlobalKey<ScaffoldState> _scaffoldKeys =  GlobalKey<ScaffoldState>();

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    reportsSelectedIndex = 0;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      orderHistorySchoolDropdownVM.getSchoolDropdown(pref.getInt('userId')!);
      orderHistoryTimerFilterVm.getOhTimerFilter();
      orderHistorySchoolStandardDropdownVM.isLoading.value = false;
      orderHistoryTimerFilterVm.isLoading.value = false;
      orderHistorySchoolDivisionVm.isLoading.value = false;
      orderHistorySchoolDivisionVm.ohSchoolDivisionDropListVm.clear();
      orderHistorySchoolStandardDropdownVM.ohSchoolStdListVm.clear();
    });
  }

  void _handleTabChange() {
    setState(() {
      reportsSelectedIndex = _tabController.index;
    });
    print("Current Index: ${_tabController.index}");
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  DateTime? fromDate;
  DateTime? toDate;


  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate ? fromDate ?? DateTime.now() : toDate ?? DateTime.now();
    DateTime firstCalendarDate = DateTime(1900);
    DateTime lastCalendarDate = DateTime(2101);

    if (isFromDate) {
      lastCalendarDate = DateTime.now(); // Limit the first date picker to the current date
    } else if (fromDate != null) {
      firstCalendarDate = fromDate!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstCalendarDate,
      lastDate: lastCalendarDate,
      helpText: 'Select ${isFromDate ? 'from' : 'to'} date',
      initialEntryMode: DatePickerEntryMode.calendarOnly, // Set initial entry mode
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF7367F0),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          if (fromDate != null && picked.isBefore(fromDate!)) {
            toDate = fromDate;
            fromDate = picked;
          } else {
            toDate = picked;
          }
        }
      });
    }
  }
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fromController.text = fromDate == null ? '' : formatDate(fromDate!);
    toController.text = toDate == null ? '' : formatDate(toDate!);
    return Scaffold(
      key: _scaffoldKeys,
      backgroundColor: const Color(0xFFFBFBFB),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/9,
              color: const Color(0xFFEDEBFF),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF4D3FD9),
                tabs: [
                  Tab(child: Text("Transaction History",style: TextStyle(color: reportsSelectedIndex == 0?const Color(0xFF4D3FD9):const Color(0xFF616161),fontFamily: "NotoSansSemiBold"))),
                  Tab(child: Text("Sales by School",style: TextStyle(color: reportsSelectedIndex == 1?const Color(0xFF4D3FD9):const Color(0xFF616161),fontFamily: "NotoSansSemiBold"))),
                  Tab(child: Text("Pending Books",style: TextStyle(color: reportsSelectedIndex == 2?const Color(0xFF4D3FD9):const Color(0xFF616161),fontFamily: "NotoSansSemiBold"))),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  TransactionHistory(),
                  SaleBySchool(),
                  PendingBooks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





