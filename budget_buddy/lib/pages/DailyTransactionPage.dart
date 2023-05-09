import 'package:budget_buddy/pages/EditExpensePage.dart';
import '../theme/Colors.dart';
import 'package:flutter/material.dart';
import '../http_Operations/httpServices.dart';
import '../models/DailyTransactionModel.dart';
import 'package:intl/intl.dart';
import '../utils/calendar_utils/calendar_timeline.dart';

class DailyTransactionPage extends StatefulWidget {
  final int authorisedUser;
  const DailyTransactionPage({Key? key, required this.authorisedUser});
  @override
  _DailyTransactionPageState createState() => _DailyTransactionPageState(userId: authorisedUser);
}

class _DailyTransactionPageState extends State<DailyTransactionPage>
    with SingleTickerProviderStateMixin {
  final int userId;
  HttpService httpService = HttpService();
  List<DailyTransactionModel>? _dailyTransactions;
  DateTime currentdate = DateTime.now();
  late String date;
  double totalAmount = 0;
  late DateTime _selectedDate;
  GlobalKey<_DailyTransactionPageState> dailyTransactionsPageKey =
      GlobalKey<_DailyTransactionPageState>();

  int _selectedContainerIndex = -1;
  bool _isOverlayVisible = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  _DailyTransactionPageState({required this.userId});
  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd').format(currentdate);
    _selectedDate = DateTime.now();
    fetchDailyTransactions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  void _toggleOverlayVisibility(int index) {
    if (_selectedContainerIndex == index) {
      setState(() {
        _isOverlayVisible = !_isOverlayVisible;
      });
      if (_isOverlayVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void fetchDailyTransactions() async {
    late double amount = 0;
    List<DailyTransactionModel> dailyTransactions = await httpService.getDailyTransactions(
      userId,
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

  String convertToTimeZone(String utcDateStr) {
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
                    // horizontal calendar
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
                      activeBackgroundDayColor: primary,
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
                ? _dailyTransactions![0].message != null
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
                    // list tile section
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: List.generate(
                            _dailyTransactions!.length,
                            (index) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleOverlayVisibility(index);
                                      setState(() {
                                        _selectedContainerIndex = index;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          _dailyTransactions![index].categoryName,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: black,
                                                              fontWeight: FontWeight.w500),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          convertToTimeZone(
                                                            _dailyTransactions![index]
                                                                .expenseDate
                                                                .toString(),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: black.withOpacity(0.5),
                                                            fontWeight: FontWeight.w800,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: (size.width - 40) * 0.3,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
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
                                            ),
                                          ],
                                        ),
                                        // divider
                                        const Padding(
                                          padding: EdgeInsets.only(left: 65, top: 8),
                                          child: Divider(
                                            thickness: 0.8,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (_selectedContainerIndex == index)
                                    GestureDetector(
                                      onTap: () => _toggleOverlayVisibility(index),
                                      child: AnimatedBuilder(
                                        animation: _opacityAnimation,
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _opacityAnimation.value,
                                            child: child,
                                          );
                                        },
                                        child: IgnorePointer(
                                          ignoring: !_isOverlayVisible,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.black54,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 4,
                                                  blurRadius: 8,
                                                  offset: const Offset(
                                                    0,
                                                    3,
                                                  ), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                // delete icon
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 12.0),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () async {
                                                                  Navigator.of(context).pop();
                                                                  List<String>? response =
                                                                      await httpService
                                                                          .deleteExpense(
                                                                    _dailyTransactions![index]
                                                                        .expenseId,
                                                                  );
                                                                  _toggleOverlayVisibility(index);
                                                                  if (response!.length == 2) {
                                                                    ScaffoldMessenger.of(context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content: Text(
                                                                          response[1],
                                                                        ),
                                                                      ),
                                                                    );
                                                                    fetchDailyTransactions();
                                                                  } else {
                                                                    ScaffoldMessenger.of(context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text(
                                                                          "Something Went Wrong",
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: const Text(
                                                                  'Ok',
                                                                  style: TextStyle(
                                                                    color: Colors.pink,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(context).pop(),
                                                                child: const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                    color: Colors.pink,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            title: const Text(
                                                              "Are you sure want to delete?",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black54,
                                                              ),
                                                            ),
                                                            elevation: 1,
                                                          );
                                                        },
                                                      );
                                                      _toggleOverlayVisibility(index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // edit icon
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 12.0),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EditExpensePage(
                                                            expenseId: _dailyTransactions![index]
                                                                .expenseId,
                                                            expenseDate: _dailyTransactions![index]
                                                                .expenseDate,
                                                            expenseCategory:
                                                                _dailyTransactions![index]
                                                                    .categoryName,
                                                            expenseAmount:
                                                                _dailyTransactions![index].amount,
                                                          ),
                                                        ),
                                                      );
                                                      setState(() {
                                                        fetchDailyTransactions();
                                                      });
                                                      _toggleOverlayVisibility(index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
