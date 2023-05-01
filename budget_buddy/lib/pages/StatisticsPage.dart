import 'package:budget_buddy/pages/BudgetsPage.dart';
import 'package:budget_buddy/pages/MonthlyExpensesPage.dart';

import '../theme/Colors.dart';
import 'package:flutter/material.dart';
import '../http_Operations/httpServices.dart';
import '../utils/lineChart/GraphWidget.dart';

class StatisticsPage extends StatefulWidget {
  final int authorisedUser;
  StatisticsPage({Key? key, required this.authorisedUser});
  @override
  _StatisticsPageState createState() => _StatisticsPageState(userId: authorisedUser);
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DateTime _selectedDate;
  final HttpService _httpService = HttpService();
  late int userId;
  Map<String, dynamic>? _results;
  dynamic _balance;

  _StatisticsPageState({required this.userId});
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    fetchTotalStats();
    fetchMonthlyBalance();
  }

  void fetchTotalStats() async {
    Map<String, dynamic>? results = await _httpService.getMonthlyTotal(
      userId,
      _selectedDate.month,
      _selectedDate.year,
    );
    setState(() {
      _results = results;
    });
  }

  void fetchMonthlyBalance() async {
    dynamic balance = await _httpService.getCurrentMonthBalance(
      userId,
      _selectedDate.month,
      _selectedDate.year,
    );
    setState(() {
      _balance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: RefreshIndicator(
        edgeOffset: 60,
        color: Colors.pink,
        onRefresh: () async {
          fetchTotalStats();
          fetchMonthlyBalance();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // appbar container
              Container(
                decoration: BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                    right: 20,
                    left: 20,
                    bottom: 25,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Monthly Stats",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // graph container
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Net balance",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _balance != null
                                  ? Text(
                                      "Rs. $_balance",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    )
                                  : const Text(
                                      "No data",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        // graph data
                        Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: (size.width - 20),
                            height: 150,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ExpenseLineChart(
                                authorisedUser: userId,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // last two containers
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: (size.width - 60) / 2,
                    height: 170,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BudgetsPage(
                                    authorisedUser: userId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Budget",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _results != null
                                  ? Text(
                                      "Rs. ${_results!["incomes"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    )
                                  : const Text(
                                      "No data",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: (size.width - 60) / 2,
                    height: 170,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MonthlyExpensePage(
                                    authorisedUser: userId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Expense",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _results != null
                                  ? Text(
                                      "Rs. ${_results!["expenses"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    )
                                  : const Text(
                                      "No data",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
