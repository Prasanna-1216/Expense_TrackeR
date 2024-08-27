import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // G E T T E R S
  List<Expense> get allExpense => _allExpenses;

  //OPERATIONS

  //Create - add a new expense
  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    //re-read from database
    readExpenses();
  }

  //READ -expense from db
  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();
    //give to local expense list

    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    //update UI
    notifyListeners();
  }

  //Update -edit an expense in db
  Future<void> updateExpense(int id, Expense updatedExpense) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpenses();
  }

  //calculate total expense for each month
  Future<Map<String, double>> calculateMonthlyTotals() async {
    //ensure the expense are read from the db
    await readExpenses();

    //create a map to keep track of total expense per month
    Map<String, double> monthlyTotals = {};
    for (var expense in _allExpenses) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';

      //if the yearmonth is not yet in the map, initialize to 0
      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      // add the expense amount to the total for the month
      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }
    return monthlyTotals; 
  }

  //calculate current  month total
  Future<double> calculateCurrentMonthTotal() async {
    //ensure expense are read from db first
    await readExpenses();
    //get current month,year
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    //filter the expense to include only  those for this month this year
    List<Expense> currentMonthExpenses = _allExpenses.where((expense) {
      return expense.date.month == currentMonth &&
          expense.date.year == currentYear;
    }).toList();

    //calculate total amount for the current month
    double total =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return total;
  }

  //get start month
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now()
          .month; //default to current month is no expense are recorded
    }

    //sort expense by date to find the earlist
    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.month;
  }

  //get start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now()
          .year; //default to current year is no expense are recorded
    }

    //sort expense by date to find the earlist
    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.year;
  }
}
