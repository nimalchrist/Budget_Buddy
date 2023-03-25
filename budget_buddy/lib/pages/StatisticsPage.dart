// import 'package:budget_tracker_ui/json/day_month.dart';
import '../theme/Colors.dart';
// import 'package:budget_tracker_ui/widget/chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = DateTime.now();
  }

  bool showAvg = false;

  List expenses = [
    {
      "icon": Icons.arrow_back,
      "color": blue,
      "label": "Income",
      "cost": "\$6593.75"
    },
    {
      "icon": Icons.arrow_forward,
      "color": red,
      "label": "Expense",
      "cost": "\$2645.50"
    }
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    CalendarTimeline(
                      showYears: true,
                      initialDate: _selectedDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 2)),
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                      monthColor: const Color(0xff67727d),
                      dayColor: Colors.black,
                      dayNameColor: const Color(0xFF333A47),
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: Colors.pink,
                      dotsColor: const Color(0xFF333A47),
                      locale: 'en',
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         '${_selectedDate.month}/${_selectedDate.year}',
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   // month length

                    //   children: List.generate(
                    //     6,
                    //     (index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             activeDay = index;
                    //           });
                    //         },
                    //         child: Container(
                    //           width: (MediaQuery.of(context).size.width - 40) / 6,
                    //           child: Column(
                    //             children: [
                    //               const Text(
                    //                 // months[index]['label'],
                    //                 "label name",
                    //                 style: TextStyle(fontSize: 10),
                    //               ),
                    //               const SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                     color: activeDay == index
                    //                         ? primary
                    //                         : black.withOpacity(0.02),
                    //                     borderRadius: BorderRadius.circular(5),
                    //                     border: Border.all(
                    //                         color: activeDay == index
                    //                             ? primary
                    //                             : black.withOpacity(0.1))),
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       left: 12, right: 12, top: 7, bottom: 7),
                    //                   child: Text(
                    //                     'day name',
                    //                     // months[index]['day'],
                    //                     style: TextStyle(
                    //                         fontSize: 10,
                    //                         fontWeight: FontWeight.w600,
                    //                         color: activeDay == index
                    //                             ? white
                    //                             : black),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                      // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Net balance",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "\$2446.90",
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
            Wrap(
              spacing: 20,
              children: List.generate(
                expenses.length,
                (index) {
                  return Container(
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
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: expenses[index]['color']),
                            child: Center(
                                child: Icon(
                              expenses[index]['icon'],
                              color: white,
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expenses[index]['label'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xff67727d)),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                expenses[index]['cost'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget getBody() {
  //   var size = MediaQuery.of(context).size;
  //   late DateTime _selectedDate;

  //   _selectedDate = DateTime.now();

  //   List expenses = [
  //     {
  //       "icon": Icons.arrow_back,
  //       "color": blue,
  //       "label": "Income",
  //       "cost": "\$6593.75"
  //     },
  //     {
  //       "icon": Icons.arrow_forward,
  //       "color": red,
  //       "label": "Expense",
  //       "cost": "\$2645.50"
  //     }
  //   ];

  // }
}
