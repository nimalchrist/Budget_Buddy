import 'package:meta/meta.dart';
import 'dart:convert';

List<ListOfMonthlyExpenses> listOfMonthlyExpensesFromJson(String str) =>
    List<ListOfMonthlyExpenses>.from(
        json.decode(str).map((x) => ListOfMonthlyExpenses.fromJson(x)));

String listOfMonthlyExpensesToJson(List<ListOfMonthlyExpenses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfMonthlyExpenses {
  final int month;
  final dynamic totalExpenses;

  ListOfMonthlyExpenses({
    required this.month,
    required this.totalExpenses,
  });

  factory ListOfMonthlyExpenses.fromJson(Map<String, dynamic> json) => ListOfMonthlyExpenses(
        month: json["month"],
        totalExpenses: json["total_expenses"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "total_expenses": totalExpenses,
      };
}
