import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gucentral/pages/home_page.dart';
import 'package:gucentral/pages/login_page.dart';
import 'package:gucentral/pages/transcript_page.dart';
import 'package:gucentral/widgets/MyColors.dart';

import '../pages/MenuPage.dart';
import 'MeduItemList.dart';

class HomePageNavDrawer extends StatefulWidget {
  const HomePageNavDrawer({Key? key}) : super(key: key);
  @override
  State<HomePageNavDrawer> createState() => _HomePageNavDrawerState();
}

class _HomePageNavDrawerState extends State<HomePageNavDrawer> {
  MenuItemlist currentItem = MenuItems.transcript;
  @override
  Widget build(BuildContext context) => ZoomDrawer(
        dragOffset: 100,
        openDragSensitivity: 300,
        mainScreenScale: 0,
        borderRadius: 40,
        angle: 0,
        menuScreenWidth: 290,
        mainScreenTapClose: true,
        menuBackgroundColor: MyColors.primary,
        slideWidth: MediaQuery.of(context).size.width * 0.7,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
              currentItem: currentItem,
              onSelecteItem: (item) {
                setState(() => currentItem = item);
                ZoomDrawer.of(context)!.close();
              }),
        ),
      );
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return const HomePage();
      case MenuItems.grades:
        return const TranscriptPage();
      case MenuItems.courses:
        return const LoginPage();
      case MenuItems.schedule:
        return const TranscriptPage();
      case MenuItems.login:
        return const LoginPage();
      case MenuItems.transcript:
        return const TranscriptPage();
      case MenuItems.map:
        return const LoginPage();
      case MenuItems.settings:
        return const TranscriptPage();
      // case MenuItems.payment:
      //   return PaymentPage();
      // case MenuItems.promos:
      //   return PromoPage();
      // case MenuItems.notification:
      //   return NotificationNDPage();
      // case MenuItems.help:
      //   return HelpNDPage();
      // case MenuItems.aboutUs:
      //   return AboutUsPage();
      // case MenuItems.rateUs:
      default:
        return TranscriptPage();
    }
  }
}
