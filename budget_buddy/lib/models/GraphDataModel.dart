import 'package:meta/meta.dart';
import 'dart:convert';

class GraphDataModel {
  GraphDataModel({
    required this.day,
    required this.dailyTotal,
  });

  final int day;
  final double dailyTotal;

  factory GraphDataModel.fromJson(Map<String, dynamic> json) => GraphDataModel(
        day: json["day"],
        dailyTotal: json["daily_total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "daily_total": dailyTotal,
      };
}
