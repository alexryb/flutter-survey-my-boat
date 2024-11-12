import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/menu.dart';

class MenuViewModel {
  List<Menu>? menuItems;

  MenuViewModel({this.menuItems});

  getAnonymusMenuItems() {
    return menuItems = <Menu>[
      Menu(
          title: "Login",
          menuColor: Color(0xffc7d8f4),
          icon: Icons.send,
          path: "Log in"
          //items: ["Log in"]
      ),
      Menu(
          title: "Signup",
          menuColor: Color(0xffc7d8f4),
          icon: Icons.send,
          path: "Sign Up"
          //items: ["Sign Up"]
      ),
      Menu(
          title: "Surveyor\nDirectory",
          menuColor: Color(0xffc8c4bd),
          icon: Icons.folder,
          items: [
            "Regulation Standards", //"Sailboats Catalog", "Powerboats Catalog"
          ]
      ),
      Menu(
          title: "Help",
          menuColor: Color(0xff7f5741),
          icon: Icons.help,
          items: ["Support", "Privacy Policy", "Terms & Conditions"]
      ),
    ];
  }

  getMenuItems() {
    return menuItems = <Menu>[
      Menu(
          title: "Surveyor\nDirectory",
          menuColor: Color(0xffc8c4bd),
          icon: Icons.folder,
          items: [
            "Regulation Standards", //"Sailboats Catalog", "Powerboats Catalog"
          ]),
      Menu(
          title: "Surveys",
          menuColor: Color(0xff261d33),
          icon: Icons.dashboard,
          items: ["Active Surveys", "Archived Surveys", "Start New Survey",]),
      Menu(
          title: "Profile",
          menuColor: Color(0xff050505),
          icon: Icons.person,
          items: ["Profile", "Certifications", "Clients"]),
      Menu(
          title: "Settings",
          menuColor: Color(0xff2a8ccf),
          icon: Icons.settings,
          items: ["Settings", "Sign Out"]),
      Menu(
          title: "Help",
          menuColor: Color(0xff7f5741),
          icon: Icons.help,
          items: ["Feed", "Support"]),
      Menu(
          title: "About",
          menuColor: Color(0xffddcec2),
          icon: Icons.assignment_outlined,
          items: ["Privacy Policy", "Terms & Conditions"]),
      // Menu(
      //     title: "Payments",
      //     menuColor: Color(0xffddcec2),
      //     icon: Icons.payment,
      //     items: ["Payments History"]),
    ];
  }
}
