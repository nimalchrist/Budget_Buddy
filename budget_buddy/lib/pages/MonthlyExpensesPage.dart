import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:budget_buddy/models/ListOfMonthlyExpenses.dart';
import 'package:budget_buddy/theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyExpensePage extends StatefulWidget {
  final int authorisedUser;
  const MonthlyExpensePage({super.key, required this.authorisedUser});

  @override
  State<MonthlyExpensePage> createState() => _MonthlyExpensePageState(userId: authorisedUser);
}

class _MonthlyExpensePageState extends State<MonthlyExpensePage> {
  final int userId;
  late HttpService httpService;
  List<ListOfMonthlyExpenses>? _listOfExpenses;
  _MonthlyExpensePageState({required this.userId});

  void fetchListOfMonthlyExpenses(int userId) async {
    List<ListOfMonthlyExpenses>? listOfExpenses =
        await httpService.getListOfMonthlyExpenses(userId);

    setState(() {
      _listOfExpenses = listOfExpenses;
    });
  }

  String getMonthName(int month) {
    DateTime dateTime = DateTime(2000, month);
    String monthName = DateFormat('MMMM').format(dateTime);
    return monthName;
  }

  @override
  void initState() {
    super.initState();
    httpService = HttpService();
    fetchListOfMonthlyExpenses(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: const Text(
          "Expenses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _listOfExpenses != null
          ? _listOfExpenses!.isNotEmpty
              ? Container(
                  color: grey.withOpacity(0.05),
                  child: ListView.builder(
                    itemCount: _listOfExpenses!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 25,
                              bottom: 25,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Monthly expenses",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Rs. ${_listOfExpenses![index].totalExpenses}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Month",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: white,
                                      ),
                                    ),
                                    Text(
                                      getMonthName(_listOfExpenses![index].month),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("No data found"),
                )
          : const Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ),
    );
  }
}
