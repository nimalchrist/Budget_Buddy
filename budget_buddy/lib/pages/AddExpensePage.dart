import 'package:budget_buddy/models/CategoryModel.dart';
import 'package:intl/intl.dart';
import '../http_Operations/httpServices.dart';
import '../theme/Colors.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  final Function refreshCallback;
  final int authorisedUser;
  const AddExpensePage({Key? key, required this.refreshCallback, required this.authorisedUser})
      : super(key: key);
  @override
  _AddExpensePageState createState() => _AddExpensePageState(userId: this.authorisedUser);
}

class _AddExpensePageState extends State<AddExpensePage> {
  int activeCategory = 0;
  final int userId;
  HttpService httpService = HttpService();
  final TextEditingController _expenseAmount = TextEditingController(text: '0');
  List<CategoryModel>? _categories;
  String? _selectedDate;

  _AddExpensePageState({required this.userId});

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

// categories
  void fetchCategories() async {
    List<CategoryModel>? categories = await httpService.fetchCategories();

    setState(() {
      _categories = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // appbar stuff
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
              padding: const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Add expense",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // category section
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              "Choose category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: black.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _categories != null
                ? Row(
                    children: List.generate(
                      _categories!.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeCategory = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                              ),
                              width: 150,
                              height: 170,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(
                                  width: 2,
                                  color: activeCategory == index ? primary : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withOpacity(0.11),
                                    spreadRadius: 2,
                                    blurRadius: 6,
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
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: grey.withOpacity(0.15),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.category,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _categories![index].categoryName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(
                      left: 158.0,
                      top: 30,
                    ),
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                  ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
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
                const SizedBox(
                  height: 15,
                ),
                _selectedDate != null
                    ? Text(
                        _selectedDate!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      )
                    : const Text(
                        "No date selected",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff67727d),
                        ),
                      ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (size.width - 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Enter Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xff67727d),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _expenseAmount,
                            cursorColor: black,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
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
                          if (_selectedDate != null) {
                            // api call
                            List<dynamic> responses = await httpService.addExpense(
                              userId,
                              activeCategory + 1,
                              _expenseAmount.text,
                              _selectedDate!,
                            );
                            if (responses.length == 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(responses[1]),
                                ),
                              );
                              widget.refreshCallback();
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
