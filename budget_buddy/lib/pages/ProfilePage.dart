import 'package:budget_buddy/models/ProfileInfoModel.dart';
import 'package:budget_buddy/pages/LoginPage.dart';
import 'package:budget_buddy/pages/SetBudgetPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/Colors.dart';
import 'package:flutter/material.dart';
import '../http_Operations/httpServices.dart';
import '../utils/bottomBarCusomised/PopOver.dart';

class ProfilePage extends StatefulWidget {
  final int authorisedUser;

  ProfilePage({Key? key, required this.authorisedUser});
  @override
  _ProfilePageState createState() => _ProfilePageState(userId: this.authorisedUser);
}

class _ProfilePageState extends State<ProfilePage> {
  late HttpService httpService;
  final int userId;
  ProfileInfoModel? _profileInfo;
  _ProfilePageState({required this.userId});
  int? _budget;

  void fetchBudget() async {
    int? budget = await httpService.getBudgetAmount(userId);
    setState(() {
      _budget = budget;
    });
  }

  void fetchProfileInfo() async {
    ProfileInfoModel? profileInfo = await httpService.getProfileInfo(userId);
    setState(() {
      _profileInfo = profileInfo;
    });
  }

  String timeFormatter(DateTime dateTime) {
    return DateFormat('MMM d, y').format(
      dateTime.add(
        const Duration(hours: 5, minutes: 30),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    httpService = HttpService();
    // isButgetSetted();
    fetchBudget();
    fetchProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
        actions: [
          IconButton(
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
                              'Logout',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Log out successful"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                          leading: const Icon(
                            Icons.logout,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.settings,
              color: black,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        displacement: 100,
        edgeOffset: 0,
        color: Colors.pink,
        onRefresh: () async {
          print("Called");
          fetchBudget();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: 25,
                  ),
                  child: Column(
                    children: [
                      // profile info pic and email
                      Row(
                        children: [
                          SizedBox(
                            width: (size.width - 40) * 0.4,
                            height: 100,
                            child: SizedBox(
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/author.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (size.width - 40) * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _profileInfo != null
                                      ? "@${_profileInfo!.userName}"
                                      : "Default User",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _profileInfo != null ? _profileInfo!.email : "Default Email",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: black.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primary,
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
                                    _budget != null ? "$_budget.0" : "Rs.0.0",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: white),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SetBudgetPage(
                                          authorisedUser: userId,
                                        ),
                                      ),
                                    );
                                    fetchBudget();
                                    setState(() {});
                                  },
                                  child: _budget == null
                                      ? const Padding(
                                          padding: EdgeInsets.all(13.0),
                                          child: Text(
                                            "Set now",
                                            style: TextStyle(color: white),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              _profileInfo != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xff67727d),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "@${_profileInfo!.userName}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xff67727d),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _profileInfo!.email,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Member Since",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xff67727d),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              timeFormatter(_profileInfo!.registeredAt),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    ),
            ],
          ),
        ),
      ),
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
}
