import 'dart:convert';
import 'dart:io';
import 'package:budget_buddy/models/CategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/DailyTransactionModel.dart';

class HttpService {
  final String ip = "192.168.178.221";

// get all the posts
  Future<List<DailyTransactionModel>> getDailyTransactions(
      int userId, String date) async {
    var url = Uri.parse('http://$ip:3000/$userId/$date');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<DailyTransactionModel> transactions = body
          .map(
            (dynamic item) => DailyTransactionModel.fromJson(item),
          )
          .toList();
      return transactions;
    } else {
      throw Exception('Failed to get daily transactions');
    }
  }

  Future<Map<String, dynamic>?> getMonthlyTotal(
      int userId, int month, int year) async {
    var map = <String, dynamic>{};
    map["current_month"] = month.toString();
    map["current_year"] = year.toString();
    var url = Uri.parse('http://$ip:3000/monthlytotal/$userId');
    http.Response res = await http.post(url, body: map);
    var rawJsonTotalResponse = jsonDecode(res.body);

    dynamic totalMonthIncome = rawJsonTotalResponse[0]["total_income"];
    dynamic totalMonthExpense = rawJsonTotalResponse[0]["total_expenses"];
    if (totalMonthExpense != null && totalMonthIncome != null) {
      return {
        "expenses": totalMonthExpense,
        "incomes": totalMonthIncome,
      };
    } else {
      return null;
    }
  }

  Future<dynamic> getCurrentMonthBalance(
      int userId, int month, int year) async {
    final url = Uri.parse('http://$ip:3000/balance/$userId');
    final response = await http.post(url, body: {
      'current_month': month.toString(),
      'current_year': year.toString(),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]['balance'];
    } else {
      return null;
    }
  }

  Future<List<String>> addExpense(
      int userId, int categoryId, String amount, String date) async {
    final url = Uri.parse('http://$ip:3000/$userId/addExpense');
    var map = <String, dynamic>{};
    map["category_id"] = categoryId.toString();
    map["amount"] = amount;
    map["date"] = date;

    final response = await http.post(url, body: map);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.headers);
      print(response.body);
      return ["200", data[0]['msg']];
    } else {
      return [data[0]['msg']];
    }
  }

  Future<List<CategoryModel>?> fetchCategories() async {
    final url = Uri.parse('http://$ip:3000/categories');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<CategoryModel> categories = data
          .map(
            (dynamic item) => CategoryModel.fromJson(item),
          )
          .toList();
      return categories;
    } else {
      return null;
    }
  }
  // register user
  // Future<List<dynamic>> registerUser(
  //     String username, String email, String password) async {
  //   var map = Map<String, dynamic>();
  //   map["username"] = username;
  //   map["email"] = email;
  //   map["password"] = password;

  //   var url = Uri.parse('http://$ip:8000/register');
  //   http.Response res = await http.post(url, body: map);
  //   var loginResponseData = jsonDecode(res.body);

  //   String registerMessage = loginResponseData["message"];
  //   try {
  //     if (res.statusCode == 200) {
  //       int authorisedUser = loginResponseData["user_id"];

  //       return [registerMessage, authorisedUser];
  //     } else {
  //       return [registerMessage];
  //     }
  //   } catch (e) {
  //     return [e];
  //   }
  // }

  // login user
  // Future<List<dynamic>> loginUser(String email, String password) async {
  //   var map = Map<String, dynamic>();
  //   map["email"] = email;
  //   map["password"] = password;

  //   var url = Uri.parse('http://$ip:8000/login');
  //   http.Response res = await http.post(url, body: map);
  //   var loginResponseData = jsonDecode(res.body);

  //   String loginMessage = loginResponseData["message"];
  //   try {
  //     if (res.statusCode == 200) {
  //       int authorisedUser = loginResponseData["user_id"];
  //       return [loginMessage, authorisedUser];
  //     } else {
  //       return [loginMessage];
  //     }
  //   } catch (e) {
  //     return [e];
  //   }
  // }

// otp verification
  // Future<List<dynamic>> otpVerification(String otp, int userId) async {
  //   try {
  //     // Make the HTTP request to the server
  //     var url = Uri.parse('http://$ip:8000/otp');
  //     var map = Map<String, dynamic>();
  //     map["otp"] = otp;
  //     map["id"] = userId.toString();
  //     var response = await http.post(url, body: map);

  //     // Handle the response
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //       var authorisedUser = responseData['user_id'];
  //       var message = responseData['message'];

  //       // local storage of the user.
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setInt('user_id', authorisedUser);

  //       return [message, authorisedUser];
  //     } else {
  //       // Handle the error response
  //       var responseData = jsonDecode(response.body);
  //       var message = responseData['message'];

  //       return [message];
  //     }
  //   } catch (e) {
  //     // Handle any exceptions that may occur
  //     return [e];
  //   }
  // }

// get the other user
  // Future<OtherUserModel> getOtherUser(int userId) async {
  //   var url = Uri.parse('http://$ip:8000/users/$userId');
  //   http.Response res = await http.get(url);

  //   if (res.statusCode == 200) {
  //     final body = json.decode(res.body);
  //     OtherUserModel OtherUser = OtherUserModel.fromJson(body[0]);

  //     return OtherUser;
  //   }
  //   throw "Error while calling";
  // }

  //get the authorised user
  // Future<AuthorisedUserModel> getAuthorisedUser(int userId) async {
  //   var url = Uri.parse('http://$ip:8000/auth_user/$userId');
  //   http.Response res = await http.get(url);

  //   if (res.statusCode == 200) {
  //     final body = json.decode(res.body);
  //     AuthorisedUserModel AuthUser = AuthorisedUserModel.fromJson(body[0]);

  //     return AuthUser;
  //   }
  //   throw "Error while calling";
  // }

  //upload post to the server
  // Future<List<String>> uploadPost(int userId, String postTitle,
  //     String postSummary, File postContent) async {
  //   Uri url = Uri.parse('http://$ip:8000/$userId/upload_post');
  //   var request = http.MultipartRequest('POST', url);

  //   request.fields['post_title'] = postTitle;
  //   request.fields['author_id'] = userId.toString();
  //   request.fields['post_summary'] = postSummary;
  //   request.files.add(
  //     await http.MultipartFile.fromPath('uploadedFile', postContent.path),
  //   );
  //   var getResponse = await request.send();
  //   var response = await http.Response.fromStream(getResponse);
  //   dynamic rawMessage = jsonDecode(response.body);
  //   String message = rawMessage['message'];
  //   if (response.statusCode == 200) {
  //     return [message, "success"];
  //   }
  //   return [message];
  // }

  //edit profile request
  // Future<String?> editProfile(
  //     int userId, File? userProfile, String userName, String userAbout) async {
  //   Uri url = Uri.parse('http://$ip:8000/edit_profile/$userId');
  //   var request = http.MultipartRequest('POST', url);

  //   if (userProfile != null) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath('profilePic', userProfile.path),
  //     );
  //   }
  //   request.fields['userName'] = userName;
  //   request.fields['profileSummary'] = userAbout;

  //   var getResponse = await request.send();
  //   var response = await http.Response.fromStream(getResponse);
  //   dynamic rawMessage = jsonDecode(response.body);
  //   String message = rawMessage['message'];

  //   if (response.statusCode == 200) {
  //     return message;
  //   } else {
  //     return null;
  //   }
  // }
}
