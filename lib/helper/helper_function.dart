/*
these are some helpful function used across the app
*/

//convert string to a double

import 'package:intl/intl.dart';

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: "en_IND", symbol: "₹", decimalDigits: 2);
  return format.format(amount);
}

//calculate the number of months since the first start month
int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth) {
  int monthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthCount;
}

// get current month name
String getCurrentMonthName(int monthTrack) {
  List<String> months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  return months[monthTrack];
}
