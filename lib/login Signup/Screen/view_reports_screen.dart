import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper_function.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  State<ViewReportsScreen> createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

// future to load graph data &month total
  Future<Map<String, double>>? _monthlyTotalsFuture;
  Future<double>? _calculateCurrentMonthTotal;

  @override
  void initState() {
    //read db on initial startup

    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    //load future

    refreshData();
    super.initState();
  }

  //refresh graph data
  void refreshData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
    _calculateCurrentMonthTotal =
        Provider.of<ExpenseDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  int monthTrack = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      // get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      void _handleBarTap(int month) {
        setState(() {
          monthTrack = month;
        });
      }

      //calculate the number ofmonths since the first month
      int monthCount =
          calculateMonthCount(startYear, startMonth, currentYear, currentMonth);
      //only display the expense for the current month
      List<Expense> currentMonthExpense = value.allExpense.where((expense) {
        return expense.date.year == currentYear &&
            expense.date.month == monthTrack + 1;
      }).toList();

      //return UI

      return Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: FutureBuilder<double>(
                  future: _calculateCurrentMonthTotal,
                  builder: (context, snapshot) {
                    //loaded
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //amount total
                          Text('\₹${snapshot.data!.toStringAsFixed(2)}'),
                          //month
                          Text(getCurrentMonthName(monthTrack)),
                        ],
                      );
                    } else {
                      return const Text("loading");
                    }
                  })),
          body: SafeArea(
            child: Column(
              children: [
                //Graph UI
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                      future: _monthlyTotalsFuture,
                      builder: (context, snapshot) {
                        //data is loading
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, double> monthlyTotals =
                              snapshot.data ?? {};
                          //create the list of monthly summary
                          List<double> monthlySummary = List.generate(
                            monthCount,
                            (index) {
                              //calculate year-month considering startMonth & index
                              int year =
                                  startYear + (startMonth + index - 1) ~/ 12;
                              int month = (startMonth + index - 1) % 12 + 1;

                              // create the key in the format 'year-month'
                              String yearMonthKey = '$year-$month';

                              //return the total for year-month or 0.0 if non-existent
                              return monthlyTotals[yearMonthKey] ?? 0.0;
                            },
                          );
                          List<int> months = List.generate(monthCount, (index) {
                            int month = (startMonth + index - 1) % 12;
                            return month;
                          });

                          return MyBarGraph(
                            monthlySummary: monthlySummary,
                            startMonth: startMonth,
                            months: months,
                            onBarTapped: _handleBarTap,
                          );
                        }

                        //loading
                        else {
                          return const Center(
                            child: Text("Loading..."),
                          );
                        }
                      }),
                ),
              ],
            ),
          ));
    });
  }
}
