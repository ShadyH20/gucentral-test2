import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:statusbarz/statusbarz.dart';

import 'MyColors.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => IconButton(
        icon: SvgPicture.asset(
          "assets/images/nav-bar.svg",
          height: 15,
          color: MyColors.secondary,
        ),
        padding: const EdgeInsets.only(left: 20),
        onPressed: () {
          if (ZoomDrawer.of(context) != null) {
            ZoomDrawer.of(context)!.toggle();
            // Statusbarz.instance.refresh();
          }
          // Scaffold.of(context).openDrawer();
        },
      );
}
