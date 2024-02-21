import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';

//Page paramètres, à implémenter
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Paramètres"),
        centerTitle: true,
      ),
      body: const Center(),
    );
  }
}
