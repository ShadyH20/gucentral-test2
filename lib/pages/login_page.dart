import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MyColors.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  height: 10,
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
                  controller: passwordController,
                  style: const TextStyle(fontSize: 21),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary.withOpacity(.15)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
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
                onPressed: () {},
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
