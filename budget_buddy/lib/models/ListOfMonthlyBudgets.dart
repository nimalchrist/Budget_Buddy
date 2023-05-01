import 'package:meta/meta.dart';
import 'dart:convert';

List<ListOfMonthlyBudgets> listOfMonthlyBudgetsFromJson(String str) =>
    List<ListOfMonthlyBudgets>.from(json.decode(str).map((x) => ListOfMonthlyBudgets.fromJson(x)));

String listOfMonthlyBudgetsToJson(List<ListOfMonthlyBudgets> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfMonthlyBudgets {
  final dynamic amount;
  final DateTime incomeDate;

  ListOfMonthlyBudgets({
    required this.amount,
    required this.incomeDate,
  });

  factory ListOfMonthlyBudgets.fromJson(Map<String, dynamic> json) => ListOfMonthlyBudgets(
        amount: json["amount"],
        incomeDate: DateTime.parse(json["income_date"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "income_date": incomeDate.toIso8601String(),
      };
}
