import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:budget_buddy/models/ListOfMonthlyBudgets.dart';
import 'package:budget_buddy/theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetsPage extends StatefulWidget {
  final int authorisedUser;
  const BudgetsPage({super.key, required this.authorisedUser});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState(userId: authorisedUser);
}

class _BudgetsPageState extends State<BudgetsPage> {
  final int userId;
  List<ListOfMonthlyBudgets>? _listOfBudgets;
  late HttpService httpService;

  _BudgetsPageState({required this.userId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpService = HttpService();
    fetchListOfMonthlyBudgets(userId);
  }

  void fetchListOfMonthlyBudgets(int userId) async {
    List<ListOfMonthlyBudgets>? listOfBudgets = await httpService.getListOfMonthlyBudgets(userId);

    setState(() {
      _listOfBudgets = listOfBudgets;
    });
  }

  String convertToTimeZone(String utcDateStr) {
    DateTime utcDate = DateTime.parse(utcDateStr);
    DateTime istDate = utcDate.add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('dd-MM-yyyy').format(istDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: const Text(
          "Budgets",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _listOfBudgets != null
          ? _listOfBudgets!.isNotEmpty
              ? Container(
                  color: grey.withOpacity(0.05),
                  child: ListView.builder(
                    itemCount: _listOfBudgets!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: blue,
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
                                      "Monthly budget",
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
                                      "Rs. ${_listOfBudgets![index].amount}",
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
                                      "Added Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: white,
                                      ),
                                    ),
                                    Text(
                                      convertToTimeZone(
                                        _listOfBudgets![index].incomeDate.toString(),
                                      ),
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
