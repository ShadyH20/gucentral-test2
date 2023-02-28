import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/HomePageNavDrawer.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = true;

  final url = Uri.parse('http://127.0.0.1:8000/api/schedule/');

  void loginPressed() async {
    print("IM IN ONPRESSED");

    //FOR TESTING PURPOSES
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePageNavDrawer()),
    );
    //FOR TESTING PURPOSES

    var body = jsonEncode({
      'username': usernameController.text,
      'password': passwordController.text
    });
    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Accept': '*/*',
    });
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
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
                TextField(
                  controller: usernameController,
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
                            width: 2, color: MyColors.primaryVariant)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
            width: 300,
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
                TextField(
                  obscureText: showPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  style: const TextStyle(fontSize: 21),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
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
                            width: 2, color: MyColors.primaryVariant)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40,
          ),
          Container(
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )),
          Container(
            height: 90,
          ),
          SvgPicture.asset(
            "assets/images/main-logo.svg",
            height: 70,
          ),
        ],
      ),
    );
  }
}
