import 'dart:convert';
import 'package:budget_buddy/main.dart';
import 'package:budget_buddy/models/CategoryModel.dart';
import 'package:budget_buddy/models/DailyTransactionModel.dart';
import 'package:budget_buddy/models/GraphDataModel.dart';
import 'package:budget_buddy/models/ListOfMonthlyBudgets.dart';
import 'package:budget_buddy/models/ListOfMonthlyExpenses.dart';
import 'package:budget_buddy/models/ProfileInfoModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  final String ip = "ec2-107-23-86-177.compute-1.amazonaws.com";

// get all the posts
  Future<List<DailyTransactionModel>> getDailyTransactions(int userId, String date) async {
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

  Future<Map<String, dynamic>?> getMonthlyTotal(int userId, int month, int year) async {
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

  Future<dynamic> getCurrentMonthBalance(int userId, int month, int year) async {
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

  Future<List<String>> addExpense(int userId, int categoryId, String amount, String date) async {
    final url = Uri.parse('http://$ip:3000/$userId/addExpense');
    var map = <String, dynamic>{};
    map["category_id"] = categoryId.toString();
    map["amount"] = amount;
    map["date"] = date;

    final response = await http.post(url, body: map);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
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

  Future<List<GraphDataModel>?> fetchGraphData(int userId) async {
    try {
      final url = Uri.parse('http://$ip:3000/fetchGraphData/$userId');
      http.Response response = await http.post(url);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List<dynamic> data = jsonDecode(response.body);
          List<GraphDataModel> graphdata = data
              .map(
                (dynamic item) => GraphDataModel.fromJson(item),
              )
              .toList();
          return graphdata;
        } else {
          return null;
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error while fetching graph data: $e');
      return null;
    }
  }

  Future<bool?> isButgetSetted(int userId) async {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    final url = Uri.parse('http://$ip:3000/budgets/$userId/$month/$year');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isSet'];
    } else {
      return null;
    }
  }

  Future<List<String>> addBudget(int userId, String amount, String date) async {
    final url = Uri.parse('http://$ip:3000/$userId/addBudget');
    var map = <String, dynamic>{};
    map["budget_amount"] = amount;
    map["budget_setting_date"] = date;

    final response = await http.post(url, body: map);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ["200", data[0]['msg']];
    } else {
      return [data[0]['msg']];
    }
  }

  Future<List<String>?> deleteExpense(int expenseId) async {
    final url = Uri.parse('http://$ip:3000/deleteExpense/$expenseId');

    http.Response response = await http.post(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ["success", data["msg"]];
    }
    return null;
  }

  Future<List<String>?> editExpense(int expenseId, dynamic expenseAmount) async {
    final url = Uri.parse('http://$ip:3000/editExpense/$expenseId');
    var map = <String, dynamic>{};
    map["amount"] = expenseAmount;

    http.Response response = await http.post(url, body: map);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ["Success", data['msg']];
    }
    return null;
  }

  // register user
  Future<List<dynamic>> registerUser(String username, String email, String password) async {
    print("Method called");
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://$ip:3000/register');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String registerMessage = loginResponseData["msg"];
    try {
      if (res.statusCode == 200) {
        int authorisedUser = loginResponseData["user_id"];
        // local storage of the user.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_id', authorisedUser);

        return [registerMessage, authorisedUser];
      } else {
        return [registerMessage];
      }
    } catch (e) {
      return [e];
    }
  }

  // login user
  Future<List<dynamic>> loginUser(String email, String password) async {
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://$ip:3000/login');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String loginMessage = loginResponseData["msg"];
    try {
      if (res.statusCode == 200) {
        int authorisedUser = loginResponseData["user_id"];
        // local storage of the user.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_id', authorisedUser);
        return [loginMessage, authorisedUser];
      } else {
        return [loginMessage];
      }
    } catch (e) {
      return [e];
    }
  }

  Future<dynamic> getBudgetAmount(int userId) async {
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    var map = Map<String, dynamic>();
    map["current_month"] = month.toString();
    map["current_year"] = year.toString();

    var url = Uri.parse('http://$ip:3000/budget/$userId');
    http.Response res = await http.post(url, body: map);
    dynamic rawData = jsonDecode(res.body);
    if (res.statusCode == 200) {
      int? budget = rawData['budget'];
      return budget;
    } else {
      return null;
    }
  }

  Future<ProfileInfoModel?> getProfileInfo(int userId) async {
    var url = Uri.parse('http://$ip:3000/profileInfo/$userId');
    http.Response res = await http.post(url);

    if (res.statusCode == 200) {
      dynamic rawData = jsonDecode(res.body);
      Map<String, dynamic> data = rawData[0];
      ProfileInfoModel profileInfo = ProfileInfoModel.fromJson(data);

      return profileInfo;
    } else {
      return null;
    }
  }

  Future<List<ListOfMonthlyBudgets>> getListOfMonthlyBudgets(int userId) async {
    var url = Uri.parse('http://$ip:3000/$userId/listOfBudgets');
    http.Response res = await http.post(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<ListOfMonthlyBudgets> listOfBudgets = body
          .map(
            (dynamic item) => ListOfMonthlyBudgets.fromJson(item),
          )
          .toList();
      return listOfBudgets;
    } else {
      throw Exception('Failed to get list of budgets');
    }
  }

  Future<List<ListOfMonthlyExpenses>> getListOfMonthlyExpenses(int userId) async {
    var url = Uri.parse('http://$ip:3000/$userId/listOfExpenses');
    http.Response res = await http.post(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<ListOfMonthlyExpenses> listOfExpenses = body
          .map(
            (dynamic item) => ListOfMonthlyExpenses.fromJson(item),
          )
          .toList();
      return listOfExpenses;
    } else {
      throw Exception('Failed to get list of expenses');
    }
  }
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
