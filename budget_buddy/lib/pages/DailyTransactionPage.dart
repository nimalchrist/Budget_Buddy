import '../theme/Colors.dart';
import 'package:flutter/material.dart';
import '../http_Operations/httpServices.dart';
import '../models/DailyTransactionModel.dart';
import 'package:intl/intl.dart';
import '../utils/calendar_utils/calendar_timeline.dart';

class DailyTransactionPage extends StatefulWidget {
  @override
  _DailyTransactionPageState createState() => _DailyTransactionPageState();
}

class _DailyTransactionPageState extends State<DailyTransactionPage> {
  HttpService httpService = HttpService();
  List<DailyTransactionModel>? _dailyTransactions;
  DateTime currentdate = DateTime.now();
  late String date;
  double totalAmount = 0;
  late DateTime _selectedDate;
  GlobalKey<_DailyTransactionPageState> dailyTransactionsPageKey =
      GlobalKey<_DailyTransactionPageState>();

  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd').format(currentdate);
    _selectedDate = DateTime.now();
    fetchDailyTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  void fetchDailyTransactions() async {
    late double amount = 0;
    List<DailyTransactionModel> dailyTransactions =
        await httpService.getDailyTransactions(
      1000,
      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
    );

    for (var amt in dailyTransactions) {
      amount += amt.amount;
    }
    setState(() {
      _dailyTransactions = dailyTransactions;
      totalAmount = amount;
    });
  }

  String convertUtcToIst(String utcDateStr) {
    DateTime utcDate = DateTime.parse(utcDateStr);
    DateTime istDate = utcDate.add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('dd-MM-yyyy').format(istDate);
    return formattedDate;
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      edgeOffset: 140,
      color: Colors.pink,
      onRefresh: () async {
        fetchDailyTransactions();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // app bar stuff
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
                          "Daily Transactions",
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
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020, 1, 1),
                      lastDate: DateTime.now().add(const Duration(days: 6)),
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                        fetchDailyTransactions();
                      },
                      monthColor: const Color(0xff67727d),
                      dayColor: const Color(0xff67727d),
                      dayNameColor: const Color(0xFF333A47),
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: Colors.pink,
                      dotsColor: const Color(0xffffffff),
                      locale: 'en',
                      shrink: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // card section
            _dailyTransactions != null
                ? _dailyTransactions!.length <= 1
                    ? const Center(
                        child: Text(
                          "No transactions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: List.generate(
                            _dailyTransactions!.length,
                            (index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: (size.width - 40) * 0.7,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: grey.withOpacity(0.1),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  size: 30,
                                                  Icons.currency_rupee_sharp,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              width: (size.width - 90) * 0.5,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _dailyTransactions![index]
                                                        .categoryName,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    convertUtcToIst(
                                                      _dailyTransactions![index]
                                                          .expenseDate
                                                          .toString(),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: black
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: (size.width - 40) * 0.3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Rs. ${_dailyTransactions![index].amount}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 65, top: 8),
                                    child: Divider(
                                      thickness: 0.8,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Check your Network connection to see the results",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            // total transaction container
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Spacer(),
                  _dailyTransactions != null
                      ? _dailyTransactions!.length != 1
                          ? Padding(
                              padding: const EdgeInsets.only(right: 80),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: black.withOpacity(0.4),
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const Spacer()
                      : const Spacer(),
                  const Spacer(),
                  _dailyTransactions != null
                      ? _dailyTransactions!.length != 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'Rs. $totalAmount',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const Spacer()
                      : const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
