import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:budget_buddy/theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SetBudgetPage extends StatefulWidget {
  final int authorisedUser;
  const SetBudgetPage({super.key, required this.authorisedUser});

  @override
  State<SetBudgetPage> createState() => _SetBudgetPageState(userId: authorisedUser);
}

class _SetBudgetPageState extends State<SetBudgetPage> {
  final int userId;

  _SetBudgetPageState({required this.userId});
  late HttpService httpService;
  bool? _isSet;
  String? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetAmount = TextEditingController();
  late FocusNode _budgetAmountFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpService = HttpService();
    isButgetSetted();
    _budgetAmountFocus = FocusNode();
  }

  void isButgetSetted() async {
    bool? isSet = await httpService.isButgetSetted(userId);
    setState(() {
      _isSet = isSet;
      print(_isSet);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink, // sets the color of the selected date
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _selectedDate = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: grey.withOpacity(0.05),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: const Text(
          "Monthly Budget",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _isSet == false
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/budget_reminder.png",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                        ),
                        child: const Text(
                          'Select Date',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _selectedDate != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Text(
                              _selectedDate!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(left: 14.0),
                            child: Text(
                              "No date selected",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xff67727d),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: (size.width - 140),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _budgetAmountFocus.requestFocus();
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      offset: Offset(0, 2), // Set the offset of the shadow
                                      blurRadius: 2, // Set the blur radius of the shadow
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Enter Budget for this Month",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                focusNode: _budgetAmountFocus,
                                keyboardType: TextInputType.number,
                                controller: _budgetAmount,
                                cursorColor: black,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Amount is required';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Eg. 120",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black38,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              color: white,
                              onPressed: () async {
                                if (_selectedDate != null && _formKey.currentState!.validate()) {
                                  List<dynamic> responses = await httpService.addBudget(
                                    userId,
                                    _budgetAmount.text,
                                    _selectedDate!,
                                  );
                                  if (responses.length == 2) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(responses[1]),
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(responses[0]),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Fill the fields correctly"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Image.asset(
                    "assets/images/budget_reminder.png",
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        "Your budget is already setted for this month so no need to worry about it",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black45),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
