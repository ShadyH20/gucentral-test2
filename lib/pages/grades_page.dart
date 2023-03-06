import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:navigation_drawer_animation/widet/menu_widget'

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
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
          leading: const MenuWidget(),
          title: const Text(
            "Grades",
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
          ],
        ),
        body: Container(
          width: double.infinity,
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hekki", style: TextStyle(color: Colors.red)),
              Container(
                width: 300.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                  color: Colors.red,
                ),
              ),
              Container(height: 100.0),
              Container(
                color: MyColors.accent,
                width: 300.0,
                height: 300.0,
                child: ListView(
                  children: [],
                ),
              ),
            ],
          ),
        ));
  }
}
