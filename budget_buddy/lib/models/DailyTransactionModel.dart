import 'package:meta/meta.dart';
import 'dart:convert';

class DailyTransactionModel {
  DailyTransactionModel({
    required this.expenseId,
    required this.userId,
    required this.categoryName,
    required this.amount,
    required this.expenseDate,
    this.message,
  });

  final int expenseId;
  final int userId;
  final String categoryName;
  final int amount;
  final DateTime expenseDate;
  final String? message;

  factory DailyTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message')) {
      return DailyTransactionModel(
        expenseId: 0,
        userId: 0,
        categoryName: '',
        amount: 0,
        expenseDate: DateTime(0),
        message: json['message'],
      );
    } else {
      return DailyTransactionModel(
        expenseId: json["expense_id"],
        userId: json["user_id"],
        categoryName: json["category_name"],
        amount: json["amount"],
        expenseDate: DateTime.parse(json["expense_date"]),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "expense_id": expenseId,
        "user_id": userId,
        "category_name": categoryName,
        "amount": amount,
        "expense_date": expenseDate.toIso8601String(),
      };
}
