import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartAxis extends StatelessWidget {
  final Color? bgcolor;
  final Color bordercolor;
  final List<int> weekBookings;

  const ChartAxis(
      {super.key,
      required this.bgcolor,
      required this.bordercolor,
      required this.weekBookings});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <ChartSeries>[
        AreaSeries<SalesData, String>(
          dataSource: <SalesData>[
            SalesData('pon.', weekBookings[0]),
            SalesData('wt.', weekBookings[1]),
            SalesData('śr.', weekBookings[2]),
            SalesData('czw.', weekBookings[3]),
            SalesData('pt.', weekBookings[4]),
            SalesData('sob.', weekBookings[5]),
            SalesData('ndz.', weekBookings[6]),
          ],
          borderWidth: 2,
          borderColor: bordercolor,
          xValueMapper: (SalesData sales, _) => sales.month,
          yValueMapper: (SalesData sales, _) => sales.sales,
          name: 'Liczba rezerwacji',
          isVisibleInLegend: false,
          markerSettings: const MarkerSettings(isVisible: true),
          color: bgcolor,
        ),
      ],
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final int sales;
}
