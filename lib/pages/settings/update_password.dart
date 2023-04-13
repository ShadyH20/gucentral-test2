import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/SharedPrefs.dart';
import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmController = TextEditingController();

  bool showCurrPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: MyColors.background,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.dark),
        backgroundColor: MyColors.background,
        foregroundColor: MyColors.secondary,
        elevation: 0,
        title: const Text(
          "Update Password",
        ),
      ),
      backgroundColor: MyColors.background,
      // 3 text fields: Current Password, New Password, Confirm New Password
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              //// DESCRIPTION ////
              // rich text
              //same text as below but embed the gucentral svg logo instead of the word "GUCentral"
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "P.S. Update your saved password in ",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: MyColors.secondary.withOpacity(0.6),
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SvgPicture.asset(
                      "assets/images/logo-text.svg",
                      height: 20,
                      color: MyColors.primary.withOpacity(0.8),
                    ),
                  ),
                  baseline: TextBaseline.alphabetic,
                  alignment: PlaceholderAlignment.middle,
                ),
                TextSpan(
                  text: " only after you have changed it on the GUC system.",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: MyColors.secondary.withOpacity(0.6),
                  ),
                ),
              ])),

              // Text(
              //   "P.S. Updates your saved password in GUCentral only after you have changed it on the GUC system.",
              //   style: TextStyle(
              //     fontFamily: "Outfit",
              //     fontWeight: FontWeight.w500,
              //     fontSize: 16,
              //     color: MyColors.secondary.withOpacity(0.6),
              //   ),
              // ),

              const SizedBox(height: 40),

              //// CURRENT PASSWORD ////
              Text(
                "Current Password",
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: MyColors.secondary,
                ),
              ),
              Container(height: 5),
              TextFormField(
                obscureText: !showCurrPassword,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _currentController,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? 'Please enter your current password'
                    : null,
                style: const TextStyle(fontSize: 18),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    splashRadius: 5,
                    icon: showCurrPassword
                        ? Icon(Icons.visibility, color: MyColors.secondary)
                        : Icon(Icons.visibility_off, color: MyColors.secondary),
                    onPressed: () {
                      setState(() {
                        showCurrPassword = !showCurrPassword;
                      });
                    },
                  ),
                  // hintText: "password",
                  hintStyle: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w500,
                      color: MyColors.secondary.withOpacity(.15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.5),
                      borderSide:
                          BorderSide(width: 2, color: MyColors.primaryVariant)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                ),
              ),

              const SizedBox(height: 20),

              //// NEW PASSWORD ////
              Text(
                "New Password",
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: MyColors.secondary,
                ),
              ),
              Container(height: 5),
              TextFormField(
                obscureText: !showNewPassword,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _newPassController,
                onChanged: (value) => setState(() {}),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? 'Please enter your new password'
                    : null,
                style: const TextStyle(fontSize: 18),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    splashRadius: 5,
                    icon: showNewPassword
                        ? Icon(Icons.visibility, color: MyColors.secondary)
                        : Icon(Icons.visibility_off, color: MyColors.secondary),
                    onPressed: () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                  ),
                  // hintText: "password",
                  hintStyle: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w500,
                      color: MyColors.secondary.withOpacity(.15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.5),
                      borderSide:
                          BorderSide(width: 2, color: MyColors.primaryVariant)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                ),
              ),

              const SizedBox(height: 20),

              //// CONFIRM NEW PASSWORD ////
              ///
              /// show a green tick if the passwords match
              Text(
                "Confirm New Password",
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: MyColors.secondary,
                ),
              ),
              Container(height: 5),
              TextFormField(
                obscureText: !showConfirmPassword,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _confirmController,
                onChanged: (value) => setState(() {}),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? 'Please confirm your new password'
                    : (value != _newPassController.text
                        ? 'Passwords do not match'
                        : null),
                style: const TextStyle(fontSize: 18),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: _newPassController.text.isNotEmpty &&
                                _confirmController.text ==
                                    _newPassController.text
                            ? Icon(
                                Icons.check_circle,
                                color: MyColors.primary,
                              )
                            : Container(),
                      ),
                      IconButton(
                        splashRadius: 5,
                        icon: showConfirmPassword
                            ? Icon(Icons.visibility, color: MyColors.secondary)
                            : Icon(Icons.visibility_off,
                                color: MyColors.secondary),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                    ],
                  ),
                  // hintText: "password",
                  hintStyle: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w500,
                      color: MyColors.secondary.withOpacity(.15)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.5),
                      borderSide:
                          BorderSide(width: 2, color: MyColors.primaryVariant)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                ),
              ),

              const SizedBox(height: 40),
              //// Change Password Button ////
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => changePassPressed(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Update Password",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: MyColors.background,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changePassPressed() async {
    bool isValid = _formKey.currentState!.validate();
    // print('Current: ${_currentController.text}');
    // print('New: ${_newPassController.text}');
    // print('Confirm: ${_confirmController.text}');
    // print('isValid: $isValid');

    if (!isValid) return;

    bool isCurrentValid =
        _currentController.text == prefs.getString('password');
    if (!isCurrentValid) {
      showSnackBar(context, 'Current password is incorrect!\nPlease try again');
      return;
    }

    bool result = await Requests.checkCredentials(
        prefs.getString(SharedPrefs.username)!, _newPassController.text);

    print('result: $result');
    if (result) {
      showSnackBar(context, 'Password will be updated soon!');
    } else {
      showSnackBar(context, 'New password in incorrect!\nPlease try again');
    }
  }
}
