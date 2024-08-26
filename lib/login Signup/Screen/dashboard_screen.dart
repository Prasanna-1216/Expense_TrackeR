import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/my_list_tile.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper_function.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  //open new expense box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: "Amount"),
            ),
          ],
        ),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _createNewExpenseButton()
        ],
      ),
    );
  }

//open edit box
  void openEditBox(Expense expense) {
    // pre-fill existing valuesz into textfields
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: existingName),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: existingAmount),
            ),
          ],
        ),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _editExpenseButton(expense),
        ],
      ),
    );
  }

//open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete expense?"),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _deleteExpenseButton(expense.id),
        ],
      ),
    );
  }

  int monthTrack = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      // get dates
      int startMonth = value.getStartMonth();
      print(startMonth.toString() + 'check===');
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
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
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
                          // print(monthlyTotals.toString() +
                          //     monthlyTotals.length.toString() +
                          //     monthCount.toString() +
                          //     "check===");
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

                const SizedBox(height: 25),

                //Expense List UI
                Expanded(
                  child: ListView.builder(
                    itemCount: currentMonthExpense.length,
                    itemBuilder: (context, index) {
                      //reverse the index to show last item first
                      int reversedIndex =
                          currentMonthExpense.length - 1 - index;

                      //get individual expense
                      Expense individualExpense =
                          currentMonthExpense[reversedIndex];

                      //return list title UI
                      return MyListTile(
                        title: individualExpense.name,
                        trailing: formatAmount(individualExpense.amount),
                        onEditPressed: (context) =>
                            openEditBox(individualExpense),
                        onDeletePressed: (context) =>
                            openDeleteBox(individualExpense),
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }

//CANCEL BUTTON

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        //pop box
        Navigator.pop(context);

        //clear controller
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  //SAVE BUTTON
  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);

          //create new expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );
          // save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          // refresh graph
          refreshData();

          // clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  //SAVE BUTTON-> EDIT EXISTING EXPENSE
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        //save as long as at least one textfield has been changes
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop box

          Navigator.pop(context);

          //create a new updated expense
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            amount: amountController.text.isNotEmpty
                ? convertStringToDouble(amountController.text)
                : expense.amount,
            date: DateTime.now(),
          );
          //old expense
          int existingId = expense.id;

          //save to db
          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updatedExpense);

          // refresh graph
          refreshData();
        }
      },
      child: const Text("Save"),
    );
  }

  //DELETE BUTTON
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        //pop box
        Navigator.pop(context);

        //delete expense from db
        await context.read<ExpenseDatabase>().deleteExpense(id);

        // refresh graph
        refreshData();
      },
      child: const Text("Delete"),
    );
  }
}
