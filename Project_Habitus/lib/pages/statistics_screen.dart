import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsScreen extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StatisticsScreen({required this.seriesList, this.animate = false});

  factory StatisticsScreen.withSampleData() {
    return StatisticsScreen(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: charts.BarChart(
                seriesList,
                animate: animate,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: charts.LineChart(
                seriesList,
                animate: animate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('2017', 5),
      OrdinalSales('2018', 25),
      OrdinalSales('2019', 100),
      OrdinalSales('2020', 75),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
