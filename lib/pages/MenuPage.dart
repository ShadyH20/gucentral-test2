import 'package:flutter/material.dart';

import '../widgets/MeduItemList.dart';

class MenuPage extends StatelessWidget {
  late MenuItemlist currentItem;
  late ValueChanged<MenuItemlist> onSelecteItem;
  MenuPage({required this.currentItem, required this.onSelecteItem});

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: Colors.indigo,
          body: Column(
            children: <Widget>[
              Spacer(),
              ...MenuItems.all.map(buildMenuItem).toList(),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      );
  Widget buildMenuItem(MenuItemlist item) => ListTileTheme(
        selectedColor: Colors.grey.shade800,
        child: ListTile(
          selectedTileColor: Colors.white,
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () => onSelecteItem(item),
        ),
      );
}

class MenuItems {
  static const login = MenuItemlist('Login', Icons.login);
  static const transcript = MenuItemlist('Transcript', Icons.transcribe);
  // static const promos = MenuItemlist('Promo', Icons.card_giftcard);
  // static const notification = MenuItemlist('Notification', Icons.notifications);
  // static const help = MenuItemlist('Help', Icons.help);
  // static const aboutUs = MenuItemlist('About Us', Icons.info_outline);
  // static const rateUs = MenuItemlist('Rate Us', Icons.star_border);
  static const all = <MenuItemlist>[
    login,
    transcript
    // payment,
    // promos,
    // notification,
    // help,
    // aboutUs,
    // rateUs
  ];
}
