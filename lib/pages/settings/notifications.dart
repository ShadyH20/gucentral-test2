// import 'package:flutter/material.dart';
// import 'package:settings_ui/settings_ui.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   // ignore: non_constant_identifier_names
//   late ColorScheme MyColors;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     MyColors = Theme.of(context).colorScheme;
//   }

//   TextStyle titleTS =
//       const TextStyle(fontWeight: FontWeight.w400, fontSize: 18);
//   TextStyle sectionTitleTs = const TextStyle(fontSize: 20);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColors.background,
//         foregroundColor: MyColors.secondary,
//         elevation: 0,
//         title: const Text(
//           "Notifications",
//         ),
//       ),
//       backgroundColor: MyColors.background,
//       // Settings tile for notifications
//       body: SizedBox(
//         width: double.infinity,
//         child: SettingsList(
//             // contentPadding: EdgeInsets.zero,
//             // shrinkWrap: true,
//             platform: DevicePlatform.iOS,
//             darkTheme: SettingsThemeData(
//               titleTextColor: Colors.white70,
//               settingsListBackground: MyColors.background,
//             ),
//             sections: [
//               //// GENERAL SECTION ////
//               SettingsSection(
//                 title: Text(
//                   'Notifications',
//                   style: sectionTitleTs,
//                   softWrap: true,
//                 ),
//                 margin: const EdgeInsetsDirectional.symmetric(
//                     horizontal: 20, vertical: 10),
//                 tiles: <SettingsTile>[

//                   // SettingsTile(
//                   //   title: Text('New Messages'),
//                   //   // subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.message,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'New Matches',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.favorite,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Super Likes',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.star,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Top Picks',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.star,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Messages',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.message,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Reminders',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.notifications,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Emails',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.email,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                   // SettingsTile(
//                   //   title: 'Push Notifications',
//                   //   subtitle: 'On',
//                   //   leading: Icon(
//                   //     Icons.notifications,
//                   //     color: MyColors.secondary,
//                   //   ),
//                   //   onPressed: (BuildContext context) {},
//                   // ),
//                 ],
//               ),
//             ]),
//       ),
//     );
//   }

//   buildNotificationsSwitch() {
//     return SettingsTile.switchTile(
//       leading: IconBuilder(
//         color: MyColors.primaryVariant,
//         // Colors.blue[300]!,
//         icon: Icons.notifications_rounded,
//       ),
//       title: Text(
//         'Schedule Notifications',
//         style: titleTS,
//       ),
//       initialValue: prefs.getBool('schedule_notifications') ?? false,
//       onToggle: (value) {},
//       trailing: Switch.adaptive(
//         activeColor: MyColors.primary,
//         value: prefs.getBool('schedule_notifications') ?? false,
//         onChanged: (value) async {
//           setState(() {
//             prefs.setBool('schedule_notifications', value);
//           });
//         },
//       ),
//     );
//   }
// }
