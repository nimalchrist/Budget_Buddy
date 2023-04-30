import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:budget_buddy/models/GraphDataModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseLineChart extends StatefulWidget {
  final int authorisedUser;
  ExpenseLineChart({Key? key, required this.authorisedUser});
  @override
  State<ExpenseLineChart> createState() => ExpenseLineChartState(userId: authorisedUser);
}

class ExpenseLineChartState extends State<ExpenseLineChart> {
  List<GraphDataModel>? _graphData;
  final int userId;
  HttpService httpService = HttpService();
  ExpenseLineChartState({required this.userId});

  void fetchGraphData() async {
    List<GraphDataModel>? graphData = await httpService.fetchGraphData(userId);
    setState(() {
      _graphData = graphData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGraphData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.pink,
      onRefresh: () async {
        fetchGraphData();
      },
      child: _graphData != null
          ? SfCartesianChart(
              plotAreaBorderWidth: 0,
              tooltipBehavior: TooltipBehavior(
                header: 'Expense',
                enable: true,
                format: 'date: point.x\n Rs. point.y',
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
              ),
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(
                  width: 0,
                ),
                title: AxisTitle(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  text: 'Expense Date',
                ),
              ),
              primaryYAxis: NumericAxis(
                majorTickLines: const MajorTickLines(width: 0),
                title: AxisTitle(
                  text: 'Expense Amount',
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              series: <ChartSeries>[
                LineSeries<GraphDataModel, int>(
                  animationDuration: 3,
                  color: Colors.pink,
                  dataSource: _graphData!,
                  xValueMapper: (GraphDataModel data, _) => data.day,
                  yValueMapper: (GraphDataModel data, _) => data.dailyTotal,
                )
              ],
            )
          : const Padding(
              padding: EdgeInsets.only(
                left: 100.0,
                bottom: 30,
              ),
              child: Center(
                child: Text(
                  "Turn on network",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
    );
  }
}
