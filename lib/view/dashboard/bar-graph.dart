import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dashboard_design.dart';

List<ChartSeries<OrdinalSales, String>> seriesList = [];

SfCartesianChart barChart(BuildContext context) {
  return SfCartesianChart(
    series: seriesList,
    plotAreaBorderWidth: 0,
    plotAreaBackgroundColor: Colors.transparent,
    primaryXAxis: CategoryAxis(
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (MediaQuery.of(context).size.width /100).round().toDouble(),
      ),
      majorGridLines:   MajorGridLines(color: Colors.transparent),


    ),
    primaryYAxis: NumericAxis(
      axisLine: AxisLine(width: 0),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (MediaQuery.of(context).size.width / 100).round().toDouble(),
      ),
      labelPosition: ChartDataLabelPosition.outside,
    ),
     isTransposed: true,
    tooltipBehavior: TooltipBehavior(
      enable: true,
      header: '',
      format: '₹point.y',

    ),
    selectionGesture: ActivationMode.singleTap,







  );
}



List<ChartSeries<OrdinalSales, String>> createRandomData() {
  final data = barGraphVM.barDataList.map((barData) {
    return OrdinalSales(barData.label!, barData.totalsale!);
  }).toList();
  return [
    BarSeries<OrdinalSales, String>(
      dataSource: data,
      xValueMapper: (OrdinalSales sales, _) => sales.label,
      yValueMapper: (OrdinalSales sales, _) => sales.salesCount,
      color: const Color.fromRGBO(204, 204, 255, 1),
      width:0.4,
      borderWidth: 0,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10), // Set top border radius
        bottom: Radius.circular(0), // Set bottom border radius (0 to remove vertical lines)
      ),
      animationDuration: 1
    ),
  ];
}

class OrdinalSales {
  final String label;
  final double salesCount;
  OrdinalSales(this.label, this.salesCount);
}
