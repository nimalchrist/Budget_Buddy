import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/Colors.dart';

class EditExpensePage extends StatefulWidget {
  final int expenseId;
  final DateTime expenseDate;
  final String expenseCategory;
  final dynamic expenseAmount;
  const EditExpensePage({
    super.key,
    required this.expenseId,
    required this.expenseDate,
    required this.expenseCategory,
    required this.expenseAmount,
  });

  @override
  // ignore: no_logic_in_create_state
  State<EditExpensePage> createState() => _EditExpensePageState(
        expenseId,
        expenseDate,
        expenseCategory,
        expenseAmount,
      );
}

class _EditExpensePageState extends State<EditExpensePage> {
  final int expenseId;
  final DateTime expenseDate;
  final String expenseCategory;
  final dynamic expenseAmount;
  late TextEditingController expenseController;
  late HttpService httpService;

  _EditExpensePageState(
    this.expenseId,
    this.expenseDate,
    this.expenseCategory,
    this.expenseAmount,
  );

  String convertUtcToIst(DateTime utcDateStr) {
    DateTime istDate = utcDateStr.add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('dd-MM-yyyy').format(istDate);
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expenseController = TextEditingController(text: expenseAmount.toString());
    httpService = HttpService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          "Edit Expense",
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
            const Text(
              "Expense ID: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$expenseId',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Expense Date: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                convertUtcToIst(expenseDate).toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Expense Category: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                expenseCategory,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Expense Amount: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: 100,
                child: TextFormField(
                  controller: expenseController,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromARGB(40, 141, 156, 204),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                List<String>? responses = await httpService.editExpense(
                  expenseId,
                  expenseController.text,
                );
                if (responses!.length == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        responses[1],
                      ),
                    ),
                  );
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Something Went Wrong",
                      ),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
              child: const Text("Edit"),
            )
          ],
        ),
      ),
    );
  }
}
