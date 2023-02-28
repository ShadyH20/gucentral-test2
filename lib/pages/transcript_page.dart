import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:navigation_drawer_animation/widet/menu_widget'

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: MyColors.background,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          elevation: 0,
          backgroundColor: MyColors.background,
          centerTitle: true,
          leadingWidth: 50.0,
          leading: MenuWidget(),
          // Builder(builder: (BuildContext context) {
          //   return Transform.translate(
          //     offset: Offset(15, 0),
          //     child: IconButton(
          //       // padding: EdgeInsets.symmetric(horizontal: 20.0),
          //       icon: SvgPicture.asset(
          //         "assets/images/nav-bar.svg",
          //         // height: 15,
          //         color: MyColors.secondary,
          //       ),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //     ),
          //   );
          // }),
          title: const Text(
            "Transcript",
            style: TextStyle(color: MyColors.primary),
          ),
          actions: [
            IconButton(
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: SvgPicture.asset(
                "assets/images/edit.svg",
                height: 30,
                // color: MyColors.secondary,
              ),
              onPressed: () {},
            ),
            Container(
              width: 10,
            )
          ]),
    );
  }
}
