import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: MyColors.primaryVariant,
        width: 260.0,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
              title: TextButton(
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: MyColors.background.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            ListTile(
              title: TextButton(
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: MyColors.background.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.background,
          centerTitle: true,
          leadingWidth: 50.0,
          leading: Builder(builder: (BuildContext context) {
            return Transform.translate(
              offset: Offset(15, 0),
              child: IconButton(
                // padding: EdgeInsets.symmetric(horizontal: 20.0),
                icon: SvgPicture.asset(
                  "assets/images/nav-bar.svg",
                  // height: 15,
                  color: MyColors.secondary,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          }),
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
