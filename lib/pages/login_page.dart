// ignore_for_file: avoid_print

import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/HomePageNavDrawer.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  _LoginPageState() {
    checkCredsExist();
  }

  @override
  void initState() {
    super.initState();
    checkCredsExist().then((userRemembered) {
      userRemembered = this.userRemembered;
      print("User Remembered? $userRemembered");
      if (userRemembered) {
        print("WE IN!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageNavDrawer(gpa: "0.00")));
      }
    });
  }

  bool showPassword = true;

  bool showLoading = false;

  bool userRemembered = false;

  void loginPressed() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      print("NOT VALID");
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      showLoading = true;
    });

    print("WILL SEND REQUEST NAAWW");
    print("${usernameController.text}, ${passwordController.text}");
    var output = await Requests.login(
        context, usernameController.text.trim(), passwordController.text);

    if (output != null) {
      if (output['success']) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageNavDrawer(gpa: output['gpa'])),
        );
      }
    }
    setState(() {
      showLoading = false;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 60.0,
                        color: MyColors.primary,
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    SvgPicture.asset(
                      "assets/images/logo-text.svg",
                      height: 70,
                      color: MyColors.primary,
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      // height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Username",
                            style: TextStyle(
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                              color: MyColors.primary,
                            ),
                          ),
                          Container(height: 5),
                          TextFormField(
                            focusNode: _usernameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.username],
                            controller: usernameController,
                            validator: (value) => value != null && value.isEmpty
                                ? 'Username cannot be empty'
                                : null,
                            style: const TextStyle(fontSize: 21),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "user.name",
                              hintStyle: TextStyle(
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.secondary.withOpacity(.15)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.5),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: MyColors.primaryVariant)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w500,
                                fontSize: 21,
                                color: MyColors.primary,
                              ),
                            ),
                            Container(height: 5),
                            TextFormField(
                              focusNode: _passwordFocusNode,
                              autofillHints: const [AutofillHints.password],
                              obscureText: showPassword,
                              textInputAction: TextInputAction.done,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: passwordController,
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Password cannot be empty'
                                      : null,
                              style: const TextStyle(fontSize: 21),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  splashRadius: 5,
                                  icon: showPassword
                                      ? const Icon(Icons.visibility,
                                          color: MyColors.secondary)
                                      : const Icon(Icons.visibility_off,
                                          color: MyColors.secondary),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                hintText: "password",
                                hintStyle: TextStyle(
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.secondary.withOpacity(.15)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.5),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: MyColors.primaryVariant)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
              ),
              Column(
                children: [
                  showLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 115,
                          height: 42,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.5)),
                              backgroundColor: MyColors.secondary,
                            ),
                            onPressed: () {
                              loginPressed();
                            },
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                  Container(height: 10),
                ],
              ),
              Container(
                height: 80,
              ),
              SvgPicture.asset(
                "assets/images/main-logo.svg",
                height: 70,
              ),
              Container(
                height: 10,
              ),
              const Text(
                "v1.0.5",
                style: TextStyle(color: MyColors.secondary),
              )
            ],
          ),
        ));
  }

  checkCredsExist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRemembered = prefs.containsKey('username');
    });
  }
}
