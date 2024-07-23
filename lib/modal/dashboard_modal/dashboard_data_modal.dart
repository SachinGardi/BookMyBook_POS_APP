class DashboardDataModal {
  double? totalSales;
  double? totalProfit;
  double? avgSaleValue;
  int? totalTransactions;
  int? totalCancleOrder;
  double? totalCancleOrderAmount;
  double? totalUpi;
  double? totalCard;
  double? totalCash;
  double? totalOtherPayment;

  DashboardDataModal({
    this.totalSales,
    this.totalProfit,
    this.avgSaleValue,
    this.totalTransactions,
    this.totalCancleOrder,
    this.totalCancleOrderAmount,
    this.totalUpi,
    this.totalCard,
    this.totalCash,
    this.totalOtherPayment,
  });

  factory DashboardDataModal.fromJson(Map<String, dynamic> json) => DashboardDataModal(
    totalSales: json["totalSales"]?.toDouble(),
    totalProfit: json["totalProfit"]?.toDouble(),
    avgSaleValue: json["avgSaleValue"]?.toDouble(),
    totalTransactions: json["totalTransactions"],
    totalCancleOrder: json["totalCancleOrder"],
    totalCancleOrderAmount: json["totalCancleOrderAmount"]?.toDouble(),
    totalUpi: json["totalUPI"]?.toDouble(),
    totalCard: json["totalCard"]?.toDouble(),
    totalCash: json["totalCash"]?.toDouble(),
    totalOtherPayment: json["totalOtherPayment"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "totalSales": totalSales,
    "totalProfit": totalProfit,
    "avgSaleValue": avgSaleValue,
    "totalTransactions": totalTransactions,
    "totalCancleOrder": totalCancleOrder,
    "totalCancleOrderAmount": totalCancleOrderAmount,
    "totalUPI": totalUpi,
    "totalCard": totalCard,
    "totalCash": totalCash,
    "totalOtherPayment": totalOtherPayment,
  };
}
