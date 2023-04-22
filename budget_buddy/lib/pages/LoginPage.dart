import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:budget_buddy/pages/RootApp.dart';
import 'package:budget_buddy/pages/SignUpPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? mailId;
  TextEditingController? passWord;
  final _formKey = GlobalKey<FormState>();
  late HttpService httpService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mailId = TextEditingController();
    passWord = TextEditingController();
    httpService = HttpService();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mailId!.dispose();
    passWord!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: const Text(
          'Budget buddy',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "san serif",
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Signup(),
                ),
              );
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 0, 76),
                fontFamily: "san serif",
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/bg.png',
                  width: 190,
                  height: 200,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                    top: 8,
                    bottom: 16,
                  ),
                  child: TextFormField(
                    controller: mailId,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email can't be empty";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'name@domain.com',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: passWord,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Add some space between the text field and button
                      Container(
                        width: 48, // Set the width of the container
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.pink, // Set the background color of the container
                          borderRadius:
                              BorderRadius.circular(8), // Set the border radius of the container
                        ),
                        child: IconButton(
                          onPressed: () async {
                            // Do something when the button is pressed
                            if (_formKey.currentState!.validate()) {
                              //api call
                              List<dynamic> responses =
                                  await httpService.loginUser(mailId!.text, passWord!.text);

                              if (responses.length == 2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(responses[0]),
                                  ),
                                );
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RootApp(authorisedUser: responses[1]),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(responses[0]),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                  child: Center(
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromARGB(255, 74, 122, 255), width: 1),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 24.0),
                          child: IconButton(
                            onPressed: () {},
                            color: Colors.blue,
                            icon: const Icon(
                              Icons.facebook,
                            ),
                          ),
                        ),
                        const Text(
                          "Login with Facebook",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(fontSize: 10),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
