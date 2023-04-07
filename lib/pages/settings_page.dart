import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gucentral/pages/schedule_page%20copy.dart";
import "package:gucentral/pages/schedule_page.dart";
import "package:gucentral/pages/settings/semester_range.dart";
import "package:gucentral/utils/local_auth_api.dart";
// import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:settings_ui/settings_ui.dart";
import "../main.dart";
import "../utils/SharedPrefs.dart";
import "../utils/Theme.dart";
import "../widgets/Requests.dart";

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> callScheduleInit;

  const SettingsPage({super.key, required this.callScheduleInit});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static bool timeFormatIs24 = false;
// ignore: non_constant_identifier_names
  ColorScheme MyColors = MyTheme.lightTheme.colorScheme;
  //// TILE TITLE TEXT STYLE ////
  late TextStyle titleTS;
  @override
  void initState() {
    super.initState();
    titleTS = TextStyle(fontWeight: FontWeight.w400, fontSize: 20);
  }

  @override
  Widget build(BuildContext context) {
    MyColors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: MyApp.isDarkMode.value
          ? MyColors.background
          : const Color(0xfff3f3fa),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.background,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        elevation: 2,
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
        // color: Colors.red,
        child: ListView(
          // padding: EdgeInsets.all(20),
          children: [
            SettingsList(
              shrinkWrap: true,
              platform: DevicePlatform.iOS,

              // lightTheme: SettingsThemeData(
              //   settingsListBackground: Colors.transparent,
              //   settingsSectionBackground: Colors.black12,
              // ),
              darkTheme: SettingsThemeData(
                  titleTextColor: Colors.white,
                  tileDescriptionTextColor: Colors.white70),
              sections: [
                //// GENERAL SECTION ////
                SettingsSection(
                  title: Text(
                    'General',
                    style: TextStyle(fontSize: 22, color: MyColors.secondary),
                    softWrap: true,
                  ),
                  margin: const EdgeInsetsDirectional.all(20),
                  tiles: <SettingsTile>[
                    buildDarkMode(),
                    buildTimeFormat(),
                    buildChangeName(),
                  ],
                ),

                //// SCHEDULE SECTION ////
                SettingsSection(
                  title: Text(
                    'Schedule',
                    style: TextStyle(fontSize: 22, color: MyColors.secondary),
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
                    style: TextStyle(fontSize: 22, color: MyColors.secondary),
                    softWrap: true,
                  ),
                  margin: const EdgeInsetsDirectional.all(20),
                  tiles: <SettingsTile>[
                    buildLockApp(),
                    // buildChangePassword(),
                  ],
                ),
              ],
            ),
            // DefaultTextStyle(
            //   style: TextStyle(color: MyColors.primary),
            //   child: SettingsGroup(
            //     title: "General",
            //     children: <Widget>[
            //       buildDarkMode(),
            //       buildChangeName(),
            //     ],
            //   ),
            // ),
            // SettingsGroup(title: "Schedule", children: <Widget>[
            // buildSemesterStartEnd(),
            // buildTimeSlots(),
            // buildTimeFormat(),
            // buildRamadanTS(),
            // ]),
            // SettingsGroup(title: "Security", children: <Widget>[
            //   buildLockApp(),
            //   // buildChangePassword(),
            // ]),
            // buildLogout()
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
            print(mainKey.toString());
            MyApp.isDarkMode.value = value;
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
        // MyColors.accent,
      ),
      title: Text(
        '24-Hour Time',
        style: titleTS,
      ),
    );
  }

  static const keyName = 'key-name';

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
        keyboardType: TextInputType.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 20),
          contentPadding: EdgeInsets.zero,
          // label
          // label: Text("First Name"),
          labelText: "First Name",
          hintText: prefs.getString('first_name') ?? "",
        ),
        onChanged: (value) {
          setState(() {
            prefs.setString('first_name', value);
          });
        },
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
    ;
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
      // description:
      //     const Text('If your 3rd slot starts at 12:00 pm instead of 11:45 pm'),
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
          print("Trying to auth");
          var isAuthenicated = await LocalAuthApi.authenticate();
          print("isAuthed? $isAuthenicated");
          if (isAuthenicated) {
            setState(() {
              prefs.setBool('lock', value);
            });
          }
        },
      ),
    );
  }

  buildChangePassword() {}

  buildLogout() {}
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
          border: const Border.fromBorderSide(
              BorderSide(color: MyColors.primaryVariant))),
      child: Icon(icon,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          size: 20),
    );
  }
}
