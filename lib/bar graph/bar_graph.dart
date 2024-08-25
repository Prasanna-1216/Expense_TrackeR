import 'package:expense_tracker/bar%20graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  final List<int> months;
  final Function(int month) onBarTapped;
  const MyBarGraph(
      {super.key,
      required this.monthlySummary,
      required this.startMonth,
      required this.months,
      required this.onBarTapped});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  //this list will hold the data for each bar
  List<IndividualBar> barData = [];

  @override
  void initState() {
    super.initState();

    //we need to scroll to the latest month automatically
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => scrolltoEnd(),
    );
  }

  //initialize bar data
  void initializeBarData() {
    // print("checkgheree==");
    // print(widget.monthlySummary);

    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: widget.months[index],
        y: widget.monthlySummary[index],
      ),
    );
  }

  // scroll controller to make sure it scrolld to the end /latest month
  final ScrollController _scrollController = ScrollController();
  void scrolltoEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    //initialization
    initializeBarData();

    //calculate max for upper limit of graph
    double calculateMax() {
      double max = 500;
      widget.monthlySummary.sort();
      max = widget.monthlySummary.last * 1.05;
      if (max < 500) {
        return 500;
      }

      return max;
    }

    // bar dimension
    double barwidth = 20;
    double spaceBetweenBars = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width: barwidth * barData.length +
              spaceBetweenBars * (barData.length - 1),
          child: BarChart(BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 24,
                  ),
                ),
              ),
              barGroups: barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.y,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.shade800,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: calculateMax(),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
              barTouchData: BarTouchData(
                touchCallback:
                    (FlTouchEvent event, BarTouchResponse? response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.spot == null) {
                    return;
                  }
                  final barIndex = response.spot!.touchedBarGroupIndex;
                  final month = widget.months[barIndex];
                  widget.onBarTapped(month);
                },
              ))),
        ),
      ),
    );
  }
}

//BOTTOM - TITLES
Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'Jan';
      break;
    case 1:
      text = 'F';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'Ap';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'Jun';
      break;
    case 6:
      text = 'Jul';
      break;
    case 7:
      text = 'Au';
      break;
    case 8:
      text = 'S';
      break;
    case 9:
      text = 'O';
      break;
    case 10:
      text = 'N';
      break;
    case 11:
      text = 'D';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(child: Text(text), axisSide: meta.axisSide);
}
