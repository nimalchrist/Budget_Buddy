import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:budget_buddy/pages/AddCategoryPage.dart';
import 'package:budget_buddy/pages/AddExpensePage.dart';
import 'package:budget_buddy/pages/DailyTransactionPage.dart';
import 'package:budget_buddy/pages/NotificationsPage.dart';
import 'package:budget_buddy/pages/ProfilePage.dart';
import 'package:budget_buddy/pages/SetBudgetPage.dart';
import 'package:budget_buddy/pages/StatisticsPage.dart';
import 'package:flutter/material.dart';
import '../theme/Colors.dart';
import '../utils/bottomBarCusomised/PopOver.dart';

class RootApp extends StatefulWidget {
  final int authorisedUser;
  const RootApp({super.key, required this.authorisedUser});

  @override
  State<RootApp> createState() => _RootAppState(userId: authorisedUser);
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  final int userId;
  _RootAppState({required this.userId});
  late List<Widget> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      DailyTransactionPage(
        authorisedUser: userId,
      ),
      StatisticsPage(
        authorisedUser: userId,
      ),
      NotificationsPage(
        authorisedUser: userId,
      ),
      ProfilePage(
        authorisedUser: userId,
      ),
    ];
  }

  void refreshPages() {
    setState(() {
      pageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<int>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return PopOver(
                child: Column(
                  children: [
                    _buildListItem(
                      context,
                      title: TextButton(
                        child: const Text(
                          'Set Budget',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetBudgetPage(
                                authorisedUser: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.pink,
                      ),
                    ),
                    _buildListItem(
                      context,
                      title: TextButton(
                        child: const Text(
                          'Add Expense',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddExpensePage(
                                refreshCallback: refreshPages,
                                authorisedUser: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      leading: const Icon(
                        Icons.add,
                        color: Colors.pink,
                      ),
                    ),
                    _buildListItem(
                      context,
                      title: TextButton(
                        child: const Text(
                          'Add Categories',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddCategoryPage(),
                            ),
                          );
                        },
                      ),
                      leading: const Icon(
                        Icons.category,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.calendar_month,
      Icons.query_stats,
      Icons.notifications,
      Icons.person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required Widget title,
    required Widget leading,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // ignore: unnecessary_null_comparison
          if (leading != null) leading,
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                style: theme.textTheme.headline6 as TextStyle,
                child: title,
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
