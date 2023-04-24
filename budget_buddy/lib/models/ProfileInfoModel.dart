import 'package:meta/meta.dart';
import 'dart:convert';

class ProfileInfoModel {
  ProfileInfoModel({
    required this.userName,
    required this.email,
    required this.registeredAt,
  });

  final String userName;
  final String email;
  final DateTime registeredAt;

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) => ProfileInfoModel(
        userName: json["user_name"],
        email: json["email"],
        registeredAt: DateTime.parse(json["registered_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "registered_at": registeredAt.toIso8601String(),
      };
}
