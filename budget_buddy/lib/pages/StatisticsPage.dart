// import 'package:budget_tracker_ui/json/day_month.dart';
import '../theme/Colors.dart';
// import 'package:budget_tracker_ui/widget/chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/calendar_utils/calendar_timeline.dart';
import '../http_Operations/httpServices.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DateTime _selectedDate;
  HttpService _httpService = HttpService();
  late int _userId;
  Map<String, dynamic>? _results;
  int? _balance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = DateTime.now();
    _userId = 1000;
    fetchTotalStats();
    fetchMonthlyBalance();
  }

  void fetchTotalStats() async {
    Map<String, dynamic>? results = await _httpService.getMonthlyTotal(
      _userId,
      _selectedDate.month,
      _selectedDate.year,
    );
    setState(() {
      _results = results;
    });
  }

  void fetchMonthlyBalance() async {
    int? balance = await _httpService.getCurrentMonthBalance(
      _userId,
      _selectedDate.month,
      _selectedDate.year,
    );
    setState(() {
      _balance = balance;
    });
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: SingleChildScrollView(
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
                    // CalendarTimeline(
                    //   initialDate: _selectedDate,
                    //   firstDate: DateTime(2020, 1, 1),
                    //   lastDate: DateTime.now().add(const Duration(days: 6)),
                    //   onDateSelected: (date) =>
                    //       setState(() => _selectedDate = date),
                    //   monthColor: const Color(0xff67727d),
                    //   dayColor: const Color(0xff67727d),
                    //   dayNameColor: const Color(0xFF333A47),
                    //   activeDayColor: Colors.white,
                    //   activeBackgroundDayColor: Colors.pink,
                    //   dotsColor: const Color(0xffffffff),
                    //   locale: 'en',
                    //   shrink: true,
                    // ),
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
                      // Positioned(
                      //   bottom: 0,
                      //   child: Container(
                      //     width: (size.width - 20),
                      //     height: 150,
                      //     child: LineChart(

                      //         // mainData(),
                      //         ),
                      //   ),
                      // )
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
                        Container(
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
                        Container(
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
    );
  }
}


            // Wrap(
            //   spacing: 20,
            //   children: List.generate(
            //     expenses.length,
            //     (index) {
            //       return Container(
            //         width: (size.width - 60) / 2,
            //         height: 170,
            //         decoration: BoxDecoration(
            //           color: white,
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: [
            //             BoxShadow(
            //               color: grey.withOpacity(0.01),
            //               spreadRadius: 10,
            //               blurRadius: 3,
            //               // changes position of shadow
            //             ),
            //           ],
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(
            //               left: 25, right: 25, top: 20, bottom: 20),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 width: 40,
            //                 height: 40,
            //                 decoration: BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     color: expenses[index]['color']),
            //                 child: Center(
            //                     child: Icon(
            //                   expenses[index]['icon'],
            //                   color: white,
            //                 )),
            //               ),
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     expenses[index]['label'],
            //                     style: const TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 13,
            //                         color: Color(0xff67727d)),
            //                   ),
            //                   const SizedBox(
            //                     height: 8,
            //                   ),
            //                   Text(
            //                     expenses[index]['cost'],
            //                     style: const TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 20,
            //                     ),
            //                   )
            //                 ],
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )