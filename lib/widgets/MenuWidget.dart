import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../main.dart';
import '../utils/SharedPrefs.dart';
import 'MyColors.dart';

class MenuWidget extends StatelessWidget {
  final bool noPadding;
  const MenuWidget({Key? key, this.noPadding = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => IconButton(
        icon: SvgPicture.asset(
          "assets/images/nav-bar.svg",
          height: 15,
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: EdgeInsets.only(left: noPadding ? 0 : 20),
        onPressed: () {
          if (!MyApp.isLoading.value) {
            if (ZoomDrawer.of(context) != null) {
              ZoomDrawer.of(context)!.toggle();
              // Statusbarz.instance.refresh();
            }
          }
          // Scaffold.of(context).openDrawer();
        },
      );
}
