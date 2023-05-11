import 'package:budget_buddy/models/ProfileInfoModel.dart';
import 'package:budget_buddy/pages/SetBudgetPage.dart';
import 'package:intl/intl.dart';

import '../theme/Colors.dart';
import 'package:flutter/material.dart';
import '../http_Operations/httpServices.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Under development"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
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
                              _profileInfo != null ? "@${_profileInfo!.userName}" : "Default User",
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SetBudgetPage(
                                      authorisedUser: userId,
                                    ),
                                  ),
                                );
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
    );
  }
}
