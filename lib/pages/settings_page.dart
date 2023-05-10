import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gucentral/pages/schedule_page.dart";
import 'package:gucentral/pages/settings/update_password.dart';
import "package:gucentral/pages/settings/semester_range.dart";
import "package:gucentral/utils/local_auth_api.dart";
import "package:gucentral/widgets/MeduItemList.dart";
// import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
// import "package:gucentral/widgets/MyColors.dart";
import "package:settings_ui/settings_ui.dart";
import "package:vibration/vibration.dart";
import "../main.dart";
import "../utils/SharedPrefs.dart";
import "../utils/Theme.dart";
import "../widgets/Requests.dart";
import "MenuPage.dart";
// import 'package:vibration_web/vibration_web.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> callScheduleInit;

  const SettingsPage({super.key, required this.callScheduleInit});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //// TILE TITLE TEXT STYLE ////
  late TextStyle titleTS;
  late TextStyle sectionTitleTs;
  @override
  void initState() {
    super.initState();
    titleTS = const TextStyle(fontWeight: FontWeight.w400, fontSize: 18);
    sectionTitleTs = const TextStyle(fontSize: 20);
  }

  @override
  Widget build(BuildContext context) {
    MyColors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: MyApp.isDarkMode.value
          ? MyColors.background
          : const Color(0xfff3f3fa),
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: MyColors.background,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: MyColors.background,
        centerTitle: true,
        leadingWidth: 50.0,
        leading: const MenuWidget(),
        title: const Text(
          "Settings",
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SettingsList(
          // shrinkWrap: true,
          platform: DevicePlatform.iOS,

          darkTheme: SettingsThemeData(
            titleTextColor: Colors.white70,
            settingsListBackground: MyColors.background,
          ),
          sections: [
            //// GENERAL SECTION ////
            SettingsSection(
              title: Text(
                'General',
                style: sectionTitleTs,
                softWrap: true,
              ),
              margin: const EdgeInsetsDirectional.all(20),
              tiles: <SettingsTile>[
                buildDarkMode(),
                buildTimeFormat(),
                buildDefaultPage(),
                buildChangeName(),
              ],
            ),

            //// SCHEDULE SECTION ////
            SettingsSection(
              title: Text(
                'Schedule',
                style: sectionTitleTs,
                softWrap: true,
              ),
              margin: const EdgeInsetsDirectional.all(20),
              tiles: <SettingsTile>[
                buildSemStartEnd(),
                build3rdSlot(),
              ],
            ),

            //// SECURITY SECTION ////
            SettingsSection(
              title: Text(
                'Security',
                style: sectionTitleTs,
                softWrap: true,
              ),
              margin: const EdgeInsetsDirectional.all(20),
              tiles: <SettingsTile>[
                buildLockApp(),
                buildUpdatePassword(),
              ],
            ),
            // SettingsSection(
            //   tiles: [],
            //   margin: const EdgeInsetsDirectional.all(20),
            // )
          ],
        ),
      ),
    );
  }

  static const keyTheme = 'key-theme';
  buildDarkMode() {
    return SettingsTile.switchTile(
      leading:
          const IconBuilder(color: Colors.deepPurple, icon: Icons.dark_mode),
      title: Text(
        'Dark Mode',
        style: titleTS,
      ),
      initialValue: prefs.getBool('dark_mode') ?? false,

      /// DISABLED
      // enabled: false,

      onToggle: (value) {
        setState(() {
          prefs.setBool('dark_mode', value);
          // mainKey.currentState!.setDarkMode(value);
        });
      },
      trailing: Switch.adaptive(
        activeColor: MyColors.primary,
        value: prefs.getBool('dark_mode') ?? false,
        onChanged: (value) {
          setState(() {
            prefs.setBool('dark_mode', value);
            MyApp.isDarkMode.value = value;
            MyColors = Theme.of(context).colorScheme;
            vibrate();

            // mainKey.currentState!.setDarkMode(value);
          });
        },
      ),
    );
  }

  buildTimeFormat() {
    return SettingsTile.switchTile(
      onToggle: (value) {
        setState(() {
          prefs.setBool('is_24h', value);
        });
      },
      trailing: Switch.adaptive(
        value: prefs.getBool('is_24h') ?? false,
        activeColor: MyColors.primary,
        // color
        onChanged: (value) => setState(() {
          prefs.setBool('is_24h', value);
        }),
      ),
      // onPressed: (context) => ,
      initialValue: prefs.getBool('is_24h') ?? false,
      leading: IconBuilder(
        icon: Icons.access_time_filled,
        color: MyColors.primary,
      ),
      title: Text(
        '24-Hour Time',
        style: titleTS,
      ),
    );
  }

  buildDefaultPage() {
    return SettingsTile.navigation(
      value: Text(prefs.getString('default_page') ?? 'Home'),
      onPressed: (context) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const DefaultPage();
            },
          ),
        );
        setState(() {});
      },
      leading: IconBuilder(
        icon: Icons.phonelink_setup_rounded,
        color: MyColors.primary,
        // MyColors.accent,
      ),
      title: Text(
        'Default Page',
        style: titleTS,
      ),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  buildChangeName() {
    return SettingsTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: IconBuilder(
            color: MyColors.primaryVariant, icon: Icons.person_2_rounded),
      ),
      title: TextField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        autofillHints: const [AutofillHints.nickname, AutofillHints.name],

        onTapOutside: (value) {
          //unfocus textfield
          if (_nameController.text.isNotEmpty) {
            setState(() {
              prefs.setString('first_name', _nameController.text);
            });
          }
          FocusScope.of(context).unfocus();
        },

        // strutStyle: const StrutStyle(height: 0.5),
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          // isCollapsed: true,
          floatingLabelStyle: TextStyle(
              fontSize: 18, color: MyColors.secondary.withOpacity(0.7)),
          labelText: "First Name",
          labelStyle: TextStyle(
              fontSize: 18, color: MyColors.secondary.withOpacity(0.3)),
          contentPadding: EdgeInsets.zero,
          hintText: prefs.getString('first_name') ?? "",
          hintStyle: TextStyle(
              fontSize: 18, color: MyColors.secondary.withOpacity(0.2)),
        ),
        // onEditingComplete: () {
        //   if (_nameController.text.isNotEmpty) {
        //     setState(() {
        //       prefs.setString('first_name', _nameController.text);
        //     });
        //   }
        // },
        onSubmitted: (value) {
          if (_nameController.text.isNotEmpty) {
            setState(() {
              prefs.setString('first_name', _nameController.text);
            });
          }
        },
        // onChanged: (value) {
        //   setState(() {
        //     prefs.setString('first_name', value);
        //   });
        // },
      ),
      description: const Text('Change how you are greeted in the home screen!'),
      // initialValue: prefs.getBool('dark_mode') ?? false,
      // onToggle: (value) {
      //   setState(() {
      //     prefs.setBool('dark_mode', value);
      //   });
      // },
      // trailing:
    );
  }

  build3rdSlot() {
    return SettingsTile.switchTile(
      leading: IconBuilder(
        color: MyColors.primaryVariant,
        // Colors.blue[300]!,
        icon: Icons.edit_calendar_rounded,
      ),
      title: Text(
        'Delayed 3rd Slot',
        style: titleTS,
      ),
      description:
          const Text('If your 3rd slot starts at 12:00 pm instead of 11:45 am'),
      initialValue: prefs.getBool('delayed_3rd') ?? false,
      onToggle: (value) {
        setState(() {
          prefs.setBool('delayed_3rd', value);
        });
      },
      trailing: Switch.adaptive(
        activeColor: MyColors.primary,
        value: prefs.getBool('delayed_3rd') ?? false,
        onChanged: (value) {
          print("Settings: Set Delayed 3rd to $value");
          widget.callScheduleInit(value);
          setState(() {
            prefs.setBool('delayed_3rd', value);
          });
        },
      ),
    );
  }

  buildSemStartEnd() {
    return SettingsTile.navigation(
      leading: IconBuilder(
          // color: Color.fromARGB(255, 100, 57, 255),
          color: MyColors.primaryVariant,
          icon: Icons.date_range_rounded),
      title: Text(
        "Semester Start & End",
        style: titleTS,
      ),

      /// DISABLED ///
      // enabled: false,
      // description: const Text("When the current semester starts and ends"),
      onPressed: (context) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SemesterRange(),
            ));
      },
    );
  }

  buildLockApp() {
    return SettingsTile.switchTile(
      leading: IconBuilder(
        color: MyColors.primaryVariant,
        // Colors.blue[300]!,
        icon: Icons.fingerprint,
      ),
      title: Text(
        'Lock app using biometrics',
        style: titleTS,
      ),
      initialValue: prefs.getBool('lock') ?? false,
      onToggle: (value) {
        setState(() {
          // prefs.setBool('lock', value);
        });
      },
      trailing: Switch.adaptive(
        activeColor: MyColors.primary,
        value: prefs.getBool('lock') ?? false,
        onChanged: (value) async {
          var isAuthenicated = await LocalAuthApi.authenticate();
          if (isAuthenicated) {
            setState(() {
              prefs.setBool('lock', value);
            });
          }
        },
      ),
    );
  }

  buildUpdatePassword() {
    return SettingsTile.navigation(
      leading: IconBuilder(
        color: MyColors.primaryVariant,
        icon: Icons.lock_rounded,
      ),
      title: Text(
        'Update Password',
        style: titleTS,
      ),
      description: const Text(
          'Update your password when you change it on the GUC system'),
      onPressed: (context) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdatePassword(),
            ));
      },
    );
  }

  buildLogout() {}

  void vibrate() {
    // if (await Vibration.hasVibrator() ?? false) {
    print("CAN VIBRATE");
    Vibration.vibrate();
    // }
  }
}

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  MenuItemlist _defaultPage =
      MenuItems.getItem(prefs.getString('default_page') ?? 'Home');
  Icon check = Icon(Icons.check, color: MyColors.primary);
  @override
  Widget build(BuildContext context) {
    // page that lets you choose one page to be the default from a list of pages: Home, Courses, Schedule, Attendance, transcript, evaluate, map

    return Scaffold(
        backgroundColor: MyApp.isDarkMode.value
            ? Theme.of(context).colorScheme.background
            : const Color(0xfff3f3fa),
        appBar: AppBar(
          title: const Text('Default Page'),
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // list of buttons each with a page title. when pressed, it sets the default page to that page and displays a check mark to the right of the button
        body: SizedBox(
          width: double.infinity,
          // color: Colors.red,
          child: ListView(
            // padding: EdgeInsets.all(20),
            children: [
              SettingsList(
                shrinkWrap: true,
                platform: DevicePlatform.iOS,
                // lightTheme: SettingsThemeData(
                //     settingsListBackground: MyColors.background,
                //     settingsSectionBackground: Colors.black.withOpacity(0.0),
                //     ),
                darkTheme: SettingsThemeData(
                  titleTextColor: Colors.white70,
                  settingsListBackground:
                      Theme.of(context).colorScheme.background,
                ),
                sections: [
                  SettingsSection(
                    // title: Text(
                    //   'General',
                    //   style: TextStyle(fontSize: 20),
                    //   softWrap: true,
                    // ),
                    margin: const EdgeInsetsDirectional.all(20),
                    tiles: [
                      SettingsTile(
                        title: const Text('Home'),
                        // leading: const Icon(Icons.home),
                        trailing: _defaultPage == MenuItems.home ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.home;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Courses'),
                        // leading: const Icon(Icons.menu_book_rounded),
                        trailing:
                            _defaultPage == MenuItems.grades ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.grades;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Schedule'),
                        // leading: const Icon(Icons.calendar_today_rounded),
                        trailing:
                            _defaultPage == MenuItems.schedule ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.schedule;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Attendance'),
                        // leading: const Icon(Icons.check_circle_rounded),
                        trailing:
                            _defaultPage == MenuItems.attendance ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.attendance;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Transcript'),
                        // leading: const Icon(Icons.description_rounded),
                        trailing:
                            _defaultPage == MenuItems.transcript ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.transcript;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Evaluate'),
                        trailing:
                            _defaultPage == MenuItems.evaluate ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.evaluate;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                      SettingsTile(
                        title: const Text('Map'),
                        description: const Text(
                            'Choose the default page that is opened when you first open the app.'),
                        trailing: _defaultPage == MenuItems.map ? check : null,
                        onPressed: (context) {
                          setState(() {
                            _defaultPage = MenuItems.map;
                            prefs.setString(
                                'default_page', _defaultPage.toString());
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class IconBuilder extends StatelessWidget {
  const IconBuilder({
    super.key,
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          // color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(
              BorderSide(color: MyColors.primaryVariant))),
      child: Icon(icon,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          size: 20),
    );
  }
}
